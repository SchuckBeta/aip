package com.oseasy.pcms.modules.cms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.pcms.modules.cms.dao.CmsPageDao;
import com.oseasy.pcms.modules.cms.entity.CmsPage;

/**
 * 页面Service.
 * @author chenh
 * @version 2018-12-25
 */
@Service
@Transactional(readOnly = true)
public class CmsPageService extends CrudService<CmsPageDao, CmsPage> {


	public CmsPage get(String id) {
		CmsPage entity = super.get(id);
		return entity;
	}

	public List<CmsPage> findList(CmsPage entity) {
		return super.findList(entity);
	}

	public Page<CmsPage> findPage(Page<CmsPage> page, CmsPage entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(CmsPage entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

	@Transactional(readOnly = false)
	public void delete(CmsPage entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(CmsPage entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(CmsPage entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(CmsPage entity) {
  	  dao.deleteWLPL(entity);
  	}
}