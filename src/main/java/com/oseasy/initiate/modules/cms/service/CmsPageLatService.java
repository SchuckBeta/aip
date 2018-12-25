package com.oseasy.initiate.modules.cms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.initiate.modules.cms.entity.CmsPageLat;
import com.oseasy.initiate.modules.cms.dao.CmsPageLatDao;

/**
 * 页面布局Service.
 * @author chenh
 * @version 2018-12-25
 */
@Service
@Transactional(readOnly = true)
public class CmsPageLatService extends CrudService<CmsPageLatDao, CmsPageLat> {


	public CmsPageLat get(String id) {
		CmsPageLat entity = super.get(id);
		return entity;
	}

	public List<CmsPageLat> findList(CmsPageLat entity) {
		return super.findList(entity);
	}

	public Page<CmsPageLat> findPage(Page<CmsPageLat> page, CmsPageLat entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(CmsPageLat entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

	@Transactional(readOnly = false)
	public void delete(CmsPageLat entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(CmsPageLat entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(CmsPageLat entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(CmsPageLat entity) {
  	  dao.deleteWLPL(entity);
  	}
}