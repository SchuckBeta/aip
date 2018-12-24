package com.oseasy.initiate.modules.promodel.service;

import com.oseasy.initiate.modules.promodel.dao.ProReportDao;
import com.oseasy.initiate.modules.promodel.entity.ProReport;
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
public class ProReportService extends CrudService<ProReportDao, ProReport> {

	public ProReport get(String id) {
		return super.get(id);
	}

	public List<ProReport> findList(ProReport ProReport) {
		return super.findList(ProReport);
	}

	public Page<ProReport> findPage(Page<ProReport> page, ProReport ProReport) {
		return super.findPage(page, ProReport);
	}

	@Transactional(readOnly = false)
	public void save(ProReport ProReport) {
		super.save(ProReport);
	}

	@Transactional(readOnly = false)
	public void delete(ProReport ProReport) {
		super.delete(ProReport);
	}

	public ProReport getByGnodeId(String proModelId, String gnodeId) {
		return dao.getByGnodeId(proModelId, gnodeId) ;
	}
}