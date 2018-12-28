package com.oseasy.pgen.modules.gen.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.pgen.modules.gen.dao.GenTablefkDao;
import com.oseasy.pgen.modules.gen.entity.GenTablefk;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * GenTableFkService.
 * @author chenh
 * @version 2018-12-28
 */
@Service
@Transactional(readOnly = true)
public class GenTablefkService extends CrudService<GenTablefkDao, GenTablefk> {


	public GenTablefk get(String id) {
		GenTablefk entity = super.get(id);
		return entity;
	}

	public List<GenTablefk> findList(GenTablefk entity) {
		return super.findList(entity);
	}

	public Page<GenTablefk> findPage(Page<GenTablefk> page, GenTablefk entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(GenTablefk entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

	@Transactional(readOnly = false)
	public void delete(GenTablefk entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(GenTablefk entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(GenTablefk entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(GenTablefk entity) {
  	  dao.deleteWLPL(entity);
  	}
}