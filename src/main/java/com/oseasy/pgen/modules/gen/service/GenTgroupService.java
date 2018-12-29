package com.oseasy.pgen.modules.gen.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.pgen.modules.gen.entity.GenTgroup;
import com.oseasy.pgen.modules.gen.dao.GenTgroupDao;

/**
 * 模板组Service.
 * @author chenh
 * @version 2018-12-29
 */
@Service
@Transactional(readOnly = true)
public class GenTgroupService extends CrudService<GenTgroupDao, GenTgroup> {

	public GenTgroup get(String id) {
		return super.get(id);
	}

	public List<GenTgroup> findList(GenTgroup entity) {
		return super.findList(entity);
	}

	public Page<GenTgroup> findPage(Page<GenTgroup> page, GenTgroup entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(GenTgroup entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

    @Transactional(readOnly = false)
    public void insertPL(List<GenTgroup> entitys) {
        dao.insertPL(entitys);
    }

    @Transactional(readOnly = false)
    public void updatePL(List<GenTgroup> entitys) {
        dao.updatePL(entitys);
    }


	@Transactional(readOnly = false)
	public void delete(GenTgroup entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(GenTgroup entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(GenTgroup entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(GenTgroup entity) {
  	  dao.deleteWLPL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLAll() {
  	    dao.deleteWLAll();
  	}
}