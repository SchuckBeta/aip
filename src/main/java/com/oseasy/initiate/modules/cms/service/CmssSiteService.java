package com.oseasy.initiate.modules.cms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.initiate.modules.cms.entity.CmssSite;
import com.oseasy.initiate.modules.cms.dao.CmssSiteDao;

/**
 * 站点明细Service.
 * @author chenhao
 * @version 2018-12-25
 */
@Service
@Transactional(readOnly = true)
public class CmssSiteService extends CrudService<CmssSiteDao, CmssSite> {


	public CmssSite get(String id) {
		CmssSite entity = super.get(id);
		return entity;
	}

	public List<CmssSite> findList(CmssSite entity) {
		return super.findList(entity);
	}

	public Page<CmssSite> findPage(Page<CmssSite> page, CmssSite entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(CmssSite entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

	@Transactional(readOnly = false)
	public void delete(CmssSite entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(CmssSite entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(CmssSite entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(CmssSite entity) {
  	  dao.deleteWLPL(entity);
  	}
}