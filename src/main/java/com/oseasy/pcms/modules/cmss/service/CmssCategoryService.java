package com.oseasy.pcms.modules.cmss.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import com.oseasy.initiate.common.config.SysIds;
import com.oseasy.pcms.common.config.CmsSval;
import com.oseasy.pcms.common.utils.CmsUtil;
import com.oseasy.pcms.modules.cmss.dao.CmssCategoryDao;
import com.oseasy.pcms.modules.cmss.entity.CmsSite;
import com.oseasy.pcms.modules.cmss.entity.CmssCategory;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.TreeService;
import com.oseasy.pcore.modules.sys.entity.Dict;
import com.oseasy.pcore.modules.sys.entity.Office;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;

/**
 * 栏目管理Service.
 * @author liangjie
 * @version 2018-08-30
 */
@Service
@Transactional(readOnly = true)
public class CmssCategoryService extends TreeService<CmssCategoryDao, CmssCategory> {
    public static final String CACHE_CATEGORY_LIST = "categoryList";

    private CmssCategory entity = new CmssCategory();

    @SuppressWarnings("unchecked")
    public List<CmssCategory> find(boolean isCurrentSite, String module) {

        List<CmssCategory> list = (List<CmssCategory>)CoreUtils.getCache(CACHE_CATEGORY_LIST);
        if (list == null) {
            CmssCategory category = new CmssCategory();
            //category.setOffice(new Office());
            category.setCmsSite(new CmsSite());
            category.setParent(new CmssCategory());
            list = dao.findList(category);
            // 将没有父节点的节点，找到父节点
            Set<String> parentIdSet = Sets.newHashSet();
            for (CmssCategory e : list) {
                if (e.getParent()!=null && StringUtils.isNotBlank(e.getParent().getId())) {
                    boolean isExistParent = false;
                    for (CmssCategory e2 : list) {
                        if (e.getParent().getId().equals(e2.getId())) {
                            isExistParent = true;
                            break;
                        }
                    }
                    if (!isExistParent) {
                        parentIdSet.add(e.getParent().getId());
                    }
                }
            }
            if (parentIdSet.size() > 0) {
                //FIXME 暂且注释，用于测试
//              dc = dao.createDetachedCriteria();
//              dc.add(Restrictions.in("id", parentIdSet));
//              dc.add(Restrictions.eq("delFlag", Category.DEL_FLAG_NORMAL));
//              dc.addOrder(Order.asc("site.id")).addOrder(Order.asc("sort"));
//              list.addAll(0, dao.find(dc));
            }
            CoreUtils.putCache(CACHE_CATEGORY_LIST, list);
        }

        if (isCurrentSite) {
            List<CmssCategory> categoryList = Lists.newArrayList();
            for (CmssCategory e : list) {
                if (CmssCategory.isRoot(e.getId()) || (e.getCmsSite()!=null && e.getCmsSite().getId() !=null
                        && e.getCmsSite().getId().equals(CmsSite.getCurrentSiteId()))) {
                    if (StringUtils.isNotEmpty(module)) {
                        if (module.equals(e.getModule()) || "".equals(e.getModule())) {
                            categoryList.add(e);
                        }
                    }else{
                        categoryList.add(e);
                    }
                }
            }
            return categoryList;
        }
        return list;
    }

    public List<CmssCategory> findByParentId(String parentId, String siteId) {
        CmssCategory parent = new CmssCategory();
        parent.setId(parentId);
        entity.setParent(parent);
        CmsSite site = new CmsSite();
        site.setId(siteId);
        entity.setCmsSite(site);
        return dao.findByParentIdAndSiteId(entity);
    }





    /**
     * 获取当前机构官网首页栏目菜单(支持2/3级节点)
     * @param parentId
     * @return
     */
    public Map<String, List<CmssCategory>> getCategoryTrees(String parentId) {
        if (StringUtils.isEmpty(parentId)) {
            return null;
        }

        Map<String, List<CmssCategory>> trees = new HashMap<String, List<CmssCategory>>();
        List<CmssCategory> firstCategory=Lists.newArrayList();
        List<CmssCategory> secondCategorys=Lists.newArrayList();

        List<CmssCategory> threeCategorys=Lists.newArrayList();

        List<CmssCategory> list = Lists.newArrayList();
        CmssCategory first = new CmssCategory();
        first.setName("首页");
        first.setId("1");
        first.setParentId("0");
        first.setIsNewtab(0);
        first.setHref("/");
        secondCategorys.add(first);
        CmssCategory m = new CmssCategory();
        m.setParentIds("0");
//        m.setInMenu(Global.SHOW);
        m.setIsShow(1);

        List<CmssCategory> sourcelist = findByParentIdsLike(m);
        CmssCategory.sortList(list, sourcelist, parentId);

        //firstCategory.add(first);
        trees.put(CmsSval.CmsKeys.SITE_CATEGORYS_INDEX_FIRST.getKey(), firstCategory);


        for (CmssCategory tempCategory:list) {
            if (tempCategory.getParentId().equals(parentId)) {
//                if (StringUtils.equals("1",tempCategory.getInMenu())) {
                    secondCategorys.add(tempCategory);
//                }
            }else{
                threeCategorys.add(tempCategory);
            }
        }


        for (CmssCategory tempCategory2:secondCategorys) {
            List<CmssCategory> children=Lists.newArrayList();
            for (CmssCategory tempCategory3:threeCategorys) {
                if (tempCategory3.getParentId().equals(tempCategory2.getId())) {
//                    if (StringUtils.equals("1",tempCategory3.getInMenu())) {
                        children.add(tempCategory3);
//                    }
                }
                List<CmssCategory> children3=Lists.newArrayList();
                for(CmssCategory tempCategory4:threeCategorys){
                    if(tempCategory4.getParentId().equals(tempCategory3.getId())){
                        children3.add(tempCategory4);

                    }
                }
                tempCategory3.setChildList(children3);
            }
            tempCategory2.setChildList(children);
        }

        trees.put(CmsSval.CmsKeys.SITE_CATEGORYS_INDEX_SENCOND.getKey(),secondCategorys);
        return trees;
    }

    public Page<CmssCategory> find(Page<CmssCategory> page, CmssCategory category) {
//      DetachedCriteria dc = dao.createDetachedCriteria();
//      if (category.getSite()!=null && StringUtils.isNotBlank(category.getSite().getId())) {
//          dc.createAlias("site", "site");
//          dc.add(Restrictions.eq("site.id", category.getSite().getId()));
//      }
//      if (category.getParent()!=null && StringUtils.isNotBlank(category.getParent().getId())) {
//          dc.createAlias("parent", "parent");
//          dc.add(Restrictions.eq("parent.id", category.getParent().getId()));
//      }
//      if (StringUtils.isNotBlank(category.getInMenu()) && Category.SHOW.equals(category.getInMenu())) {
//          dc.add(Restrictions.eq("inMenu", category.getInMenu()));
//      }
//      dc.add(Restrictions.eq(Category.FIELD_DEL_FLAG, Category.DEL_FLAG_NORMAL));
//      dc.addOrder(Order.asc("site.id")).addOrder(Order.asc("sort"));
//      return dao.find(page, dc);
//      page.setSpringPage(dao.findByParentId(category.getParent().getId(), page.getSpringPage()));
//      return page;
        category.setPage(page);
//        category.setInMenu(Global.SHOW);
        page.setList(dao.findModule(category));
        return page;
    }

    @Transactional(readOnly = false)
    public void save(CmssCategory category) {
        //1
        category.setCmsSite(new CmsSite(CmsSite.getCurrentSiteId()));
//        if (StringUtils.isNotBlank(category.getViewConfig())) {
//            category.setViewConfig(StringEscapeUtils.unescapeHtml4(category.getViewConfig()));
//        }
        super.save(category);
        CoreUtils.removeCache(CACHE_CATEGORY_LIST);
        CmsUtil.removeCache("mainNavList_"+category.getCmsSite().getId());
    }

    @Transactional(readOnly = false)
    public void delete(CmssCategory category) {
        CmssCategory c=get(category.getId());
        if(c!=null){
            super.delete(c);
            CoreUtils.removeCache(CACHE_CATEGORY_LIST);
            CmsUtil.removeCache("mainNavList_"+c.getCmsSite().getId());
        }
    }

    @Transactional(readOnly = false)
    public CmssCategory saveNew(CmsSite site, Office office) {
        CmssCategory root = get(SysIds.SITE_CATEGORYS_SYS_ROOT.getId());
        CmssCategory category = new CmssCategory();
        category.setParent(root);
        category.setCmsSite(site);
//        category.setOffice(office);
//        category.setInMenu(Global.SHOW);
//        category.setInList(Global.SHOW);
        category.setShowModes("0");
        category.setAllowComment(Global.NO);
        category.setIsAudit(Global.NO);
        category.setName(site.getName()+"根栏目");
        category.setRemarks("系统自动创建["+site.getName()+"根栏目],禁止删除");
        super.save(category);

        CoreUtils.removeCache(CACHE_CATEGORY_LIST);
        CmsUtil.removeCache("mainNavList_"+category.getCmsSite().getId());
        return category;
    }

    /**
     * 通过编号获取栏目列表
     */
    public List<CmssCategory> findByIds(String ids) {
        List<CmssCategory> list = Lists.newArrayList();
        String[] idss = StringUtils.split(ids,",");
        if (idss.length>0) {
//          List<Category> l = dao.findByIdIn(idss);
//          for (String id : idss) {
//              for (Category e : l) {
//                  if (e.getId().equals(id)) {
//                      list.add(e);
//                      break;
//                  }
//              }
//          }
            for(String id : idss) {
                CmssCategory e = dao.get(id);
                if (null != e) {
                    //System.out.println("e.id:"+e.getId()+",e.name:"+e.getName());
                    list.add(e);
                }
                //list.add(dao.get(id));

            }
        }
        return list;
    }

    /**
     * 根据parentIds获取栏目分类
     * @param parentIds
     * @return
     */
    public List<CmssCategory> findByParentIdsLike(String parentIds) {
        CmssCategory m = new CmssCategory();
        m.setParentIds(parentIds);
        return findByParentIdsLike(m);
    }
    public List<CmssCategory> findByParentIdsLike(CmssCategory m) {
        return dao.findByParentIdsLike(m);
    }

    public CmssCategory findByName(String meunname) {
        return dao.getCategoryByName(meunname);
    }
    public void updateHref(String id,String href) {
        dao.updateHref(id,href);
    }


	@Autowired
	private CmssCategoryDao cmsCategoryDao;
	public CmssCategory get(String id) {
		return super.get(id);
	}

	public List<CmssCategory> findList(CmssCategory cmsCategory) {
		return super.findList(cmsCategory);
	}

	public Page<CmssCategory> findPage(Page<CmssCategory> page, CmssCategory cmsCategory) {
		return super.findPage(page, cmsCategory);
	}


  	@Transactional(readOnly = false)
  	public void deleteWL(CmssCategory cmsCategory) {
  	  dao.deleteWL(cmsCategory);
  	}

	@Transactional(readOnly = false)
	public void updateOrder(String ids,String sorts){
		String[] idList = ids.split(",");
		String[] sortList = sorts.split(",");
		List<CmssCategory> cmsCategoryList = new ArrayList<>();
		for(int i=0;i<idList.length;i++){
			CmssCategory cmsCategory = new CmssCategory();
			cmsCategory.setId(idList[i]);
			cmsCategory.setSort(Integer.valueOf(sortList[i]));
			cmsCategoryList.add(cmsCategory);
		}

		cmsCategoryDao.updateOrder(cmsCategoryList);
	}
	@Transactional(readOnly = false)
	public void update(CmssCategory cmsCategory){
		dao.update(cmsCategory);
	}

	@Transactional(readOnly = false)
	public List<CmssCategory> getListBySiteId(String siteId) {
		return dao.getListBySiteId(siteId);
	}

	@Transactional(readOnly = false)
	public void  saveList(List<CmssCategory> cmsCategoryList) {
		dao.saveList(cmsCategoryList);
	}

	@Transactional(readOnly = false)
	public void updateShow(CmssCategory cmsCategory){dao.updateShow(cmsCategory);}
	@Transactional(readOnly = false)
	public void delBySiteId(String siteId) {
		dao.delBySiteId(siteId);
	}
	@Transactional(readOnly = false)
	public void updateList(List<CmssCategory> cmsCategoryList) {
		dao.updateList(cmsCategoryList);
	}

	public CmssCategory getByIdAndType(String siteId, String type) {
		return dao.getByIdAndType(siteId,type);
	}

    public List<Dict> getProCategoryByActywId(String actywId){
        return dao.getProCategoryByActywId(actywId);
    }

	public void deleteByCheck(CmssCategory category) {
		CmssCategory c=get(category.getId());
		if(c!=null){
			if(StringUtils.isNotEmpty(c.getHref())){

			}
			super.delete(c);
			CoreUtils.removeCache(CACHE_CATEGORY_LIST);
			CmsUtil.removeCache("mainNavList_"+c.getCmsSite().getId());
		}
	}
}