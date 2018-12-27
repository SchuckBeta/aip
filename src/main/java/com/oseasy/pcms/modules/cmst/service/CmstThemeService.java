package com.oseasy.pcms.modules.cmst.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.pcms.modules.cmst.dao.CmstThemeDao;
import com.oseasy.pcms.modules.cmst.entity.CmstTheme;

/**
 * 站点模板主题Service.
 * @author chenh
 * @version 2018-12-25
 */
@Service
@Transactional(readOnly = true)
public class CmstThemeService extends CrudService<CmstThemeDao, CmstTheme> {


	public CmstTheme get(String id) {
		CmstTheme entity = super.get(id);
		return entity;
	}

	public List<CmstTheme> findList(CmstTheme entity) {
		return super.findList(entity);
	}

	public Page<CmstTheme> findPage(Page<CmstTheme> page, CmstTheme entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(CmstTheme entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

	@Transactional(readOnly = false)
	public void delete(CmstTheme entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(CmstTheme entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(CmstTheme entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(CmstTheme entity) {
  	  dao.deleteWLPL(entity);
  	}
}