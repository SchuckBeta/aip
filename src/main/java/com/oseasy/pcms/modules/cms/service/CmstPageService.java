package com.oseasy.pcms.modules.cms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.pcms.modules.cms.dao.CmstPageDao;
import com.oseasy.pcms.modules.cms.entity.CmstPage;

/**
 * 模板页面Service.
 * @author chenh
 * @version 2018-12-26
 */
@Service
@Transactional(readOnly = true)
public class CmstPageService extends CrudService<CmstPageDao, CmstPage> {


	public CmstPage get(String id) {
		CmstPage entity = super.get(id);
		return entity;
	}

	public List<CmstPage> findList(CmstPage entity) {
		return super.findList(entity);
	}

	public Page<CmstPage> findPage(Page<CmstPage> page, CmstPage entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(CmstPage entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

	@Transactional(readOnly = false)
	public void delete(CmstPage entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(CmstPage entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(CmstPage entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(CmstPage entity) {
  	  dao.deleteWLPL(entity);
  	}
}