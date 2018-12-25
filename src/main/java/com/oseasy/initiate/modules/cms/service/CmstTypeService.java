package com.oseasy.initiate.modules.cms.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.service.TreeService;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.initiate.modules.cms.entity.CmstType;
import com.oseasy.initiate.modules.cms.dao.CmstTypeDao;

/**
 * 模板类型Service.
 * @author chenh
 * @version 2018-12-25
 */
@Service
@Transactional(readOnly = true)
public class CmstTypeService extends TreeService<CmstTypeDao, CmstType> {

	public CmstType get(String id) {
		return super.get(id);
	}

	public List<CmstType> findList(CmstType entity) {
		if (StringUtil.isNotBlank(entity.getParentIds())){
			entity.setParentIds(","+entity.getParentIds()+",");
		}
		return super.findList(entity);
	}

	@Transactional(readOnly = false)
	public void save(CmstType entity) {
		if(entity.getIsNewRecord()){
	    }
		super.save(entity);
	}

    @Transactional(readOnly = false)
    public void insertPL(List<CmstType> entitys) {
        dao.insertPL(entitys);
    }

    @Transactional(readOnly = false)
    public void updatePL(List<CmstType> entitys) {
        dao.updatePL(entitys);
    }


	@Transactional(readOnly = false)
	public void delete(CmstType entity) {
		super.delete(entity);
	}

	@Transactional(readOnly = false)
	public void deletePL(CmstType entity) {
		dao.deletePL(entity);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(CmstType entity) {
  	  dao.deleteWL(entity);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(CmstType entity) {
  	  dao.deleteWLPL(entity);
  	}
}