package com.oseasy.pact.modules.actyw.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pact.modules.actyw.dao.ActYwAnnounceDao;
import com.oseasy.pact.modules.actyw.entity.ActYwAnnounce;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;

/**
 * 项目流程通告Service.
 * @author chenhao
 * @version 2017-05-23
 */
@Service
@Transactional(readOnly = true)
public class ActYwAnnounceService extends CrudService<ActYwAnnounceDao, ActYwAnnounce> {

	public ActYwAnnounce get(String id) {
		return super.get(id);
	}

	public List<ActYwAnnounce> findList(ActYwAnnounce actYwAnnounce) {
		return super.findList(actYwAnnounce);
	}

	public Page<ActYwAnnounce> findPage(Page<ActYwAnnounce> page, ActYwAnnounce actYwAnnounce) {
		return super.findPage(page, actYwAnnounce);
	}

	@Transactional(readOnly = false)
	public void save(ActYwAnnounce actYwAnnounce) {
		super.save(actYwAnnounce);
	}

	@Transactional(readOnly = false)
	public void delete(ActYwAnnounce actYwAnnounce) {
		super.delete(actYwAnnounce);
	}

}