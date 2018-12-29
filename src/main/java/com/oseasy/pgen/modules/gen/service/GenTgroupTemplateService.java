package com.oseasy.pgen.modules.gen.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.pgen.modules.gen.entity.GenTgroupTemplate;
import com.oseasy.pgen.modules.gen.dao.GenTgroupTemplateDao;

/**
 * 模板组关联Service.
 * @author chenh
 * @version 2018-12-29
 */
@Service
@Transactional(readOnly = true)
public class GenTgroupTemplateService extends CrudService<GenTgroupTemplateDao, GenTgroupTemplate> {

	public GenTgroupTemplate get(String id) {
		return super.get(id);
	}

	public List<GenTgroupTemplate> findList(GenTgroupTemplate entity) {
		return super.findList(entity);
	}

	public Page<GenTgroupTemplate> findPage(Page<GenTgroupTemplate> page, GenTgroupTemplate entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(GenTgroupTemplate entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

    @Transactional(readOnly = false)
    public void insertPL(List<GenTgroupTemplate> entitys) {
        dao.insertPL(entitys);
    }

    @Transactional(readOnly = false)
    public void updatePL(List<GenTgroupTemplate> entitys) {
        dao.updatePL(entitys);
    }


	@Transactional(readOnly = false)
	public void delete(GenTgroupTemplate entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(GenTgroupTemplate entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(GenTgroupTemplate entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(GenTgroupTemplate entity) {
  	  dao.deleteWLPL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLAll() {
  	    dao.deleteWLAll();
  	}
}