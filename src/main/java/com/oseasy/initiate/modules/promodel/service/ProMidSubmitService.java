package com.oseasy.initiate.modules.promodel.service;

import com.oseasy.initiate.modules.promodel.dao.ProMidSubmitDao;
import com.oseasy.initiate.modules.promodel.entity.ProMidSubmit;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 中期提交信息表Service.
 * @author zy
 * @version 2017-12-01
 */
@Service
@Transactional(readOnly = true)
public class ProMidSubmitService extends CrudService<ProMidSubmitDao, ProMidSubmit> {

	public ProMidSubmit get(String id) {
		return super.get(id);
	}

	public List<ProMidSubmit> findList(ProMidSubmit proMidSubmit) {
		return super.findList(proMidSubmit);
	}

	public Page<ProMidSubmit> findPage(Page<ProMidSubmit> page, ProMidSubmit proMidSubmit) {
		return super.findPage(page, proMidSubmit);
	}

	@Transactional(readOnly = false)
	public void save(ProMidSubmit proMidSubmit) {
		super.save(proMidSubmit);
	}

	@Transactional(readOnly = false)
	public void delete(ProMidSubmit proMidSubmit) {
		super.delete(proMidSubmit);
	}

	public ProMidSubmit getByGnodeId(String proModelId, String gnodeId) {
		return dao.getByGnodeId(proModelId, gnodeId) ;
	}
}