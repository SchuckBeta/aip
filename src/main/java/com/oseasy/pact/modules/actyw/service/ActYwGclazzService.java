package com.oseasy.pact.modules.actyw.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pact.modules.actyw.dao.ActYwGclazzDao;
import com.oseasy.pact.modules.actyw.entity.ActYwGclazz;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;

/**
 * 监听类Service.
 * @author chenh
 * @version 2018-03-01
 */
@Service
@Transactional(readOnly = true)
public class ActYwGclazzService extends CrudService<ActYwGclazzDao, ActYwGclazz> {

	public ActYwGclazz get(String id) {
		return super.get(id);
	}

	public List<ActYwGclazz> findList(ActYwGclazz actYwGclazz) {
		return super.findList(actYwGclazz);
	}

	public Page<ActYwGclazz> findPage(Page<ActYwGclazz> page, ActYwGclazz actYwGclazz) {
		return super.findPage(page, actYwGclazz);
	}

	@Transactional(readOnly = false)
	public void save(ActYwGclazz actYwGclazz) {
		super.save(actYwGclazz);
	}

	@Transactional(readOnly = false)
	public void delete(ActYwGclazz actYwGclazz) {
		super.delete(actYwGclazz);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(ActYwGclazz actYwGclazz) {
  	  dao.deleteWL(actYwGclazz);
  	}

    /**
     * 批量保存.
     * @param gforms
     */
    @Transactional(readOnly = false)
    public void savePl(List<ActYwGclazz> actYwGclazz) {
        dao.savePl(actYwGclazz);
    }

    /**
     * 根据流程批量删除.
     * @param groupId 流程ID
     */
    @Transactional(readOnly = false)
    public void deletePlwlByGroup(String groupId) {
        dao.deletePlwlByGroup(groupId);
    }

    /**
     * 根据流程批量删除.
     * @param groupId 流程ID
     * @param gnodeId 节点ID
     */
    @Transactional(readOnly = false)
    public void deletePlwl(String groupId, String gnodeId) {
        dao.deletePlwl(groupId, gnodeId);
    }
}