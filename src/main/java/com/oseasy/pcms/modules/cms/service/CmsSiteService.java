package com.oseasy.pcms.modules.cms.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.service.TreeService;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.pcms.modules.cms.dao.CmsSiteDao;
import com.oseasy.pcms.modules.cms.entity.CmsSite;

/**
 * 站点Service.
 * @author chenh
 * @version 2018-12-25
 */
@Service
@Transactional(readOnly = true)
public class CmsSiteService extends TreeService<CmsSiteDao, CmsSite> {

	public CmsSite get(String id) {
		return super.get(id);
	}

	public List<CmsSite> findList(CmsSite entity) {
		if (StringUtil.isNotBlank(entity.getParentIds())){
			entity.setParentIds(","+entity.getParentIds()+",");
		}
		return super.findList(entity);
	}

	@Transactional(readOnly = false)
	public void save(CmsSite entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

    @Transactional(readOnly = false)
    public void insertPL(List<CmsSite> entitys) {
        dao.insertPL(entitys);
    }

    @Transactional(readOnly = false)
    public void updatePL(List<CmsSite> entitys) {
        dao.updatePL(entitys);
    }


	@Transactional(readOnly = false)
	public void delete(CmsSite entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(CmsSite entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(CmsSite entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(CmsSite entity) {
  	  dao.deleteWLPL(entity);
  	}
}