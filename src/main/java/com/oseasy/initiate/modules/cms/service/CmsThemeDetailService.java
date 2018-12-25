package com.oseasy.initiate.modules.cms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.initiate.modules.cms.entity.CmsThemeDetail;
import com.oseasy.initiate.modules.cms.dao.CmsThemeDetailDao;

/**
 * 主题明细Service.
 * @author chenhao
 * @version 2018-12-25
 */
@Service
@Transactional(readOnly = true)
public class CmsThemeDetailService extends CrudService<CmsThemeDetailDao, CmsThemeDetail> {


	public CmsThemeDetail get(String id) {
		CmsThemeDetail entity = super.get(id);
		return entity;
	}

	public List<CmsThemeDetail> findList(CmsThemeDetail entity) {
		return super.findList(entity);
	}

	public Page<CmsThemeDetail> findPage(Page<CmsThemeDetail> page, CmsThemeDetail entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(CmsThemeDetail entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

	@Transactional(readOnly = false)
	public void delete(CmsThemeDetail entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(CmsThemeDetail entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(CmsThemeDetail entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(CmsThemeDetail entity) {
  	  dao.deleteWLPL(entity);
  	}
}