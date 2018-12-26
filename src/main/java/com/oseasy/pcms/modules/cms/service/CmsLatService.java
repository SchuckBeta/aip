package com.oseasy.pcms.modules.cms.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.pcms.modules.cms.dao.CmsLatDao;
import com.oseasy.pcms.modules.cms.entity.CmsLat;

/**
 * 布局Service.
 * @author chenh
 * @version 2018-12-25
 */
@Service
@Transactional(readOnly = true)
public class CmsLatService extends CrudService<CmsLatDao, CmsLat> {

	public CmsLat get(String id) {
		return super.get(id);
	}

	public List<CmsLat> findList(CmsLat entity) {
		return super.findList(entity);
	}

	public Page<CmsLat> findPage(Page<CmsLat> page, CmsLat entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(CmsLat entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

    @Transactional(readOnly = false)
    public void insertPL(List<CmsLat> entitys) {
        dao.insertPL(entitys);
    }

    @Transactional(readOnly = false)
    public void updatePL(List<CmsLat> entitys) {
        dao.updatePL(entitys);
    }


	@Transactional(readOnly = false)
	public void delete(CmsLat entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(CmsLat entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(CmsLat entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(CmsLat entity) {
  	  dao.deleteWLPL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLAll() {
  	    dao.deleteWLAll();
  	}
}