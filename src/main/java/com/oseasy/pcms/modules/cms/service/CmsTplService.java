package com.oseasy.pcms.modules.cms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.pcms.modules.cms.dao.CmsTplDao;
import com.oseasy.pcms.modules.cms.entity.CmsTpl;

/**
 * 模板Service.
 * @author chenh
 * @version 2018-12-25
 */
@Service
@Transactional(readOnly = true)
public class CmsTplService extends CrudService<CmsTplDao, CmsTpl> {


	public CmsTpl get(String id) {
		CmsTpl entity = super.get(id);
		return entity;
	}

	public List<CmsTpl> findList(CmsTpl entity) {
		return super.findList(entity);
	}

	public Page<CmsTpl> findPage(Page<CmsTpl> page, CmsTpl entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(CmsTpl entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

	@Transactional(readOnly = false)
	public void delete(CmsTpl entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(CmsTpl entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(CmsTpl entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(CmsTpl entity) {
  	  dao.deleteWLPL(entity);
  	}
}