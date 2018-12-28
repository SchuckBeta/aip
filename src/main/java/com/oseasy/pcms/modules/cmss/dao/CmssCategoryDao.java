package com.oseasy.pcms.modules.cmss.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcms.modules.cmss.entity.CmssCategory;
import com.oseasy.pcore.common.persistence.TreeDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.pcore.modules.sys.entity.Dict;

/**
 * 栏目管理DAO接口.
 * @author liangjie
 * @version 2018-08-30
 */
@MyBatisDao
public interface CmssCategoryDao extends TreeDao<CmssCategory> {
    public void updateHref(@Param("id")String id,@Param("href")String href);
    public List<CmssCategory> findModule(CmssCategory category);

//  public List<Category> findByParentIdsLike(Category category);
//  {
//      return find("from Category where parentIds like :p1", new Parameter(parentIds));
//  }

    public List<CmssCategory> findByModule(String module);
//  {
//      return find("from Category where delFlag=:p1 and (module='' or module=:p2) order by site.id, sort",
//              new Parameter(Category.DEL_FLAG_NORMAL, module));
//  }

    public List<CmssCategory> findByParentId(String parentId, String isMenu);
//  {
//      return find("from Category where delFlag=:p1 and parent.id=:p2 and inMenu=:p3 order by site.id, sort",
//              new Parameter(Category.DEL_FLAG_NORMAL, parentId, isMenu));
//  }

    public List<CmssCategory> findByParentIdAndSiteId(CmssCategory entity);

    public List<Map<String, Object>> findStats(String sql);
//  {
//      return find("from Category where delFlag=:p1 and parent.id=:p2 and site.id=:p3 order by site.id, sort",
//              new Parameter(Category.DEL_FLAG_NORMAL, parentId, siteId));
//  }

    /**
     * 根据parentId获取栏目
     * @param entity
     * @return
     */
    public List<CmssCategory> getByParentId(CmssCategory entity);

    /**
     * 根据parentId获取栏目
     * @param entity
     * @return
     */
    public List<CmssCategory> findListIdsLike(CmssCategory entity);

    /**
     * 根据name获取栏目
     * @param entity
     * @return
     */
    public CmssCategory getCategoryByName(String name);

    //public List<Category> findByIdIn(String[] ids);
//  {
//      return find("from Category where id in (:p1)", new Parameter(new Object[]{ids}));
//  }
    //public List<Category> find(Category category);

//  @Query("select distinct c from Category c, Role r, User u where c in elements (r.categoryList) and r in elements (u.roleList)" +
//          " and c.delFlag='" + Category.DEL_FLAG_NORMAL + "' and r.delFlag='" + Role.DEL_FLAG_NORMAL +
//          "' and u.delFlag='" + User.DEL_FLAG_NORMAL + "' and u.id=?1 or (c.user.id=?1 and c.delFlag='" + Category.DEL_FLAG_NORMAL +
//          "') order by c.site.id, c.sort")
//  public List<Category> findByUserId(Long userId);

  /**
   * 物理删除.
   * @param entity
   */
  public void deleteWL(CmssCategory cmsCategory);

  public void updateOrder(@Param("cmsCategoryList") List<CmssCategory> cmsCategory);

  public List<CmssCategory> getListBySiteId(String siteId);

  public void saveList(@Param("cmsCategoryList")List<CmssCategory> cmsCategoryList);
  public void updateShow(CmssCategory cmsCategory);

  public void delBySiteId(String siteId);

    public void updateList(@Param("cmsCategoryList")List<CmssCategory> cmsCategoryList);

    public CmssCategory getByIdAndType(@Param("siteId")String siteId, @Param("type")String type);

    public List<Dict> getProCategoryByActywId(String actywId);
}