package com.oseasy.pcms.modules.cmsp.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.pcms.modules.cmsp.dao.CmsPlatDao;
import com.oseasy.pcms.modules.cmsp.entity.CmsPlat;

/**
 * 页面布局Service.
 * @author chenh
 * @version 2018-12-25
 */
@Service
@Transactional(readOnly = true)
public class CmsPlatService extends CrudService<CmsPlatDao, CmsPlat> {


	public CmsPlat get(String id) {
		CmsPlat entity = super.get(id);
		return entity;
	}

	public List<CmsPlat> findList(CmsPlat entity) {
		return super.findList(entity);
	}

	public Page<CmsPlat> findPage(Page<CmsPlat> page, CmsPlat entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(CmsPlat entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

	@Transactional(readOnly = false)
	public void delete(CmsPlat entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(CmsPlat entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(CmsPlat entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(CmsPlat entity) {
  	  dao.deleteWLPL(entity);
  	}
}