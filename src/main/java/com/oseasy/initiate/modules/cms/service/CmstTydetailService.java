package com.oseasy.initiate.modules.cms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.initiate.modules.cms.entity.CmstTydetail;
import com.oseasy.initiate.modules.cms.dao.CmstTydetailDao;

/**
 * 模板类型明细Service.
 * @author chenh
 * @version 2018-12-25
 */
@Service
@Transactional(readOnly = true)
public class CmstTydetailService extends CrudService<CmstTydetailDao, CmstTydetail> {


	public CmstTydetail get(String id) {
		CmstTydetail entity = super.get(id);
		return entity;
	}

	public List<CmstTydetail> findList(CmstTydetail entity) {
		return super.findList(entity);
	}

	public Page<CmstTydetail> findPage(Page<CmstTydetail> page, CmstTydetail entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(CmstTydetail entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

	@Transactional(readOnly = false)
	public void delete(CmstTydetail entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(CmstTydetail entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(CmstTydetail entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(CmstTydetail entity) {
  	  dao.deleteWLPL(entity);
  	}
}