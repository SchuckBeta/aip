package com.oseasy.pcms.modules.cmss.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcms.common.config.CmsSval;
import com.oseasy.pcms.common.utils.CmsUtil;
import com.oseasy.pcms.modules.cmss.dao.CmssMenuDao;
import com.oseasy.pcms.modules.cmss.entity.CmssMenu;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.service.TreeService;
import com.oseasy.pcore.common.utils.CacheUtils;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 站点菜单Service.
 * @author chenhao
 * @version 2019-01-01
 */
@Service
@Transactional(readOnly = true)
public class CmssMenuService extends TreeService<CmssMenuDao, CmssMenu> {

	public CmssMenu get(String id) {
		return super.get(id);
	}

	public List<CmssMenu> findList(CmssMenu entity) {
		if (StringUtil.isNotBlank(entity.getParentIds())){
			entity.setParentIds(","+entity.getParentIds()+",");
		}
		return super.findList(entity);
	}

	@Transactional(readOnly = false)
	public void save(CmssMenu entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

//    @Transactional(readOnly = false)
//    public void insertPL(List<CmssMenu> entitys) {
//        dao.insertPL(entitys);
//    }
//
//    @Transactional(readOnly = false)
//    public void updatePL(List<CmssMenu> entitys) {
//        dao.updatePL(entitys);
//    }


	@Transactional(readOnly = false)
	public void delete(CmssMenu entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(CmssMenu entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(CmssMenu entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(CmssMenu entity) {
  	  dao.deleteWLPL(entity);
  	}

    public List<CmssMenu> findAll() {
        return CmsUtil.findAllCmssMenu();
    }

    /**
     * .
     * @param menu
     */
    public void changeIsShow(CmssMenu menu) {
        dao.updateIsShow(menu);
        CoreUtils.removeCache(CmsSval.CmsCaches.CMSS_MENU_LIST.getKey());
        // 清除日志相关缓存
        CacheUtils.remove(CoreSval.CoreCaches.LOG_CMSSMENU_NAME_PATH_MAP.getKey());
    }

    public Boolean checkName(CmssMenu menu) {
        return (dao.checkName(menu) < 1 )? true:false;
    }

    @Transactional(readOnly = false)
    public void updateSort(CmssMenu menu) {
        dao.updateSort(menu);
        // 清除用户菜单缓存
        CoreUtils.removeCache(CmsSval.CmsCaches.CMSS_MENU_LIST.getKey());
//      // 清除权限缓存
//      systemRealm.clearAllCachedAuthorizationInfo();
        // 清除日志相关缓存
        CacheUtils.remove(CoreSval.CoreCaches.LOG_CMSSMENU_NAME_PATH_MAP.getKey());
    }

    public CmssMenu getByName(String name) {
        return dao.getByName(name);
    }

    public CmssMenu getByHref(String href) {
        return dao.getByHref(href);
    }
}