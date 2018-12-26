package com.oseasy.pcms.modules.cms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.pcms.modules.cms.dao.CmsThemeDao;
import com.oseasy.pcms.modules.cms.entity.CmsTheme;

/**
 * 主题Service.
 * @author chenhao
 * @version 2018-12-25
 */
@Service
@Transactional(readOnly = true)
public class CmsThemeService extends CrudService<CmsThemeDao, CmsTheme> {


	public CmsTheme get(String id) {
		CmsTheme entity = super.get(id);
		return entity;
	}

	public List<CmsTheme> findList(CmsTheme entity) {
		return super.findList(entity);
	}

	public Page<CmsTheme> findPage(Page<CmsTheme> page, CmsTheme entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(CmsTheme entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

	@Transactional(readOnly = false)
	public void delete(CmsTheme entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(CmsTheme entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(CmsTheme entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(CmsTheme entity) {
  	  dao.deleteWLPL(entity);
  	}
}