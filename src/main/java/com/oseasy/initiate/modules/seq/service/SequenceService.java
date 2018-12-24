package com.oseasy.initiate.modules.seq.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.initiate.modules.seq.entity.Sequence;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.initiate.modules.seq.dao.SequenceDao;

/**
 * 序列表Service.
 * @author zy
 * @version 2018-10-08
 */
@Service
@Transactional(readOnly = true)
public class SequenceService extends CrudService<SequenceDao, Sequence> {

	public Sequence get(String id) {
		return super.get(id);
	}

	public List<Sequence> findList(Sequence entity) {
		return super.findList(entity);
	}

	public Page<Sequence> findPage(Page<Sequence> page, Sequence entity) {
		return super.findPage(page, entity);
	}

	@Transactional(readOnly = false)
	public void save(Sequence entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

    @Transactional(readOnly = false)
    public void insertPL(List<Sequence> entitys) {
        dao.insertPL(entitys);
    }

    @Transactional(readOnly = false)
    public void updatePL(List<Sequence> entitys) {
        dao.updatePL(entitys);
    }


	@Transactional(readOnly = false)
	public void delete(Sequence entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(Sequence entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(Sequence entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(Sequence entity) {
  	  dao.deleteWLPL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLAll() {
  	    dao.deleteWLAll();
  	}

	@Transactional(readOnly = false)
	public String nextSequence(String name) {
		return dao.nextSequence(name);
	}
}