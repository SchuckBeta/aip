package com.oseasy.initiate.modules.cms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.initiate.modules.cms.entity.CmssSiteTpl;
import com.oseasy.initiate.modules.cms.dao.CmssSiteTplDao;

/**
 * 站点模板Service.
 * @author chenh
 * @version 2018-12-25
 */
@Service
@Transactional(readOnly = true)
public class CmssSiteTplService extends CrudService<CmssSiteTplDao, CmssSiteTpl> {


	public CmssSiteTpl get(String id) {
		CmssSiteTpl entity = super.get(id);
		return entity;
	}

	public List<CmssSiteTpl> findList(CmssSiteTpl entity) {
		return super.findList(entity);
	}

	public Page<CmssSiteTpl> findPage(Page<CmssSiteTpl> page, CmssSiteTpl entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(CmssSiteTpl entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

	@Transactional(readOnly = false)
	public void delete(CmssSiteTpl entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(CmssSiteTpl entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(CmssSiteTpl entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(CmssSiteTpl entity) {
  	  dao.deleteWLPL(entity);
  	}
}