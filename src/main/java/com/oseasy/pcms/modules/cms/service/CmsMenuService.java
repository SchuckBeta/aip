package com.oseasy.pcms.modules.cms.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcms.common.config.CmsSval;
import com.oseasy.pcms.common.utils.CmsUtil;
import com.oseasy.pcms.modules.cms.dao.CmsMenuDao;
import com.oseasy.pcms.modules.cms.entity.CmsMenu;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.service.TreeService;
import com.oseasy.pcore.common.utils.CacheUtils;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * CMS菜单Service.
 * @author chenh
 * @version 2019-01-01
 */
@Service
@Transactional(readOnly = true)
public class CmsMenuService extends TreeService<CmsMenuDao, CmsMenu> {
	public CmsMenu get(String id) {
		return super.get(id);
	}

	public List<CmsMenu> findList(CmsMenu entity) {
		if (StringUtil.isNotBlank(entity.getParentIds())){
			entity.setParentIds(StringUtil.DOTH + entity.getParentIds() + StringUtil.DOTH);
		}
		return super.findList(entity);
	}

	@Transactional(readOnly = false)
	public void save(CmsMenu entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

//    @Transactional(readOnly = false)
//    public void insertPL(List<CmsMenu> entitys) {
//        dao.insertPL(entitys);
//    }
//
//    @Transactional(readOnly = false)
//    public void updatePL(List<CmsMenu> entitys) {
//        dao.updatePL(entitys);
//    }

	@Transactional(readOnly = false)
	public void delete(CmsMenu entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(CmsMenu entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(CmsMenu entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(CmsMenu entity) {
  	  dao.deleteWLPL(entity);
  	}

    public List<CmsMenu> findAllMenu() {
        return CmsUtil.findAllCmsMenu();
    }

    /**
     * .
     * @param menu
     */
    public void changeIsShow(CmsMenu menu) {
        dao.updateIsShow(menu);
        CoreUtils.removeCache(CmsSval.CmsCaches.CMS_MENU_LIST.getKey());
        // 清除日志相关缓存
        CacheUtils.remove(CoreSval.CoreCaches.LOG_CMSMENU_NAME_PATH_MAP.getKey());
    }

    public Boolean checkName(CmsMenu menu) {
        return (dao.checkName(menu) < 1 )? true:false;
    }

    @Transactional(readOnly = false)
    public void updateSort(CmsMenu menu) {
        dao.updateSort(menu);
        // 清除用户菜单缓存
        CoreUtils.removeCache(CmsSval.CmsCaches.CMS_MENU_LIST.getKey());
//      // 清除权限缓存
//      systemRealm.clearAllCachedAuthorizationInfo();
        // 清除日志相关缓存
        CacheUtils.remove(CoreSval.CoreCaches.LOG_CMSMENU_NAME_PATH_MAP.getKey());
    }

    public CmsMenu getByName(String name) {
        return dao.getByName(name);
    }

    public CmsMenu getByHref(String href) {
        return dao.getByHref(href);
    }
}