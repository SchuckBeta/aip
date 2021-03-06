package com.oseasy.pcms.modules.cmst.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.pcms.modules.cmst.dao.CmstRelDao;
import com.oseasy.pcms.modules.cmst.entity.CmstRel;

/**
 * 站点模板关联Service.
 * @author chenh
 * @version 2018-12-25
 */
@Service
@Transactional(readOnly = true)
public class CmstRelService extends CrudService<CmstRelDao, CmstRel> {


	public CmstRel get(String id) {
		CmstRel entity = super.get(id);
		return entity;
	}

	public List<CmstRel> findList(CmstRel entity) {
		return super.findList(entity);
	}

	public Page<CmstRel> findPage(Page<CmstRel> page, CmstRel entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(CmstRel entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

	@Transactional(readOnly = false)
	public void delete(CmstRel entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(CmstRel entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(CmstRel entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(CmstRel entity) {
  	  dao.deleteWLPL(entity);
  	}
}