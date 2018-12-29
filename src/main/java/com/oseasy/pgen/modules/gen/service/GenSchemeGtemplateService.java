package com.oseasy.pgen.modules.gen.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.pgen.modules.gen.entity.GenSchemeGtemplate;
import com.oseasy.pgen.modules.gen.dao.GenSchemeGtemplateDao;

/**
 * 模板方案组关联Service.
 * @author chenh
 * @version 2018-12-29
 */
@Service
@Transactional(readOnly = true)
public class GenSchemeGtemplateService extends CrudService<GenSchemeGtemplateDao, GenSchemeGtemplate> {

	public GenSchemeGtemplate get(String id) {
		return super.get(id);
	}

	public List<GenSchemeGtemplate> findList(GenSchemeGtemplate entity) {
		return super.findList(entity);
	}

	public Page<GenSchemeGtemplate> findPage(Page<GenSchemeGtemplate> page, GenSchemeGtemplate entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(GenSchemeGtemplate entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

    @Transactional(readOnly = false)
    public void insertPL(List<GenSchemeGtemplate> entitys) {
        dao.insertPL(entitys);
    }

    @Transactional(readOnly = false)
    public void updatePL(List<GenSchemeGtemplate> entitys) {
        dao.updatePL(entitys);
    }


	@Transactional(readOnly = false)
	public void delete(GenSchemeGtemplate entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(GenSchemeGtemplate entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(GenSchemeGtemplate entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(GenSchemeGtemplate entity) {
  	  dao.deleteWLPL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLAll() {
  	    dao.deleteWLAll();
  	}
}