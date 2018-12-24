package com.oseasy.initiate.modules.sys.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.initiate.modules.sys.entity.SysCertificateRel;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.initiate.modules.sys.dao.SysCertificateRelDao;

/**
 * 系统证书资源关联Service.
 * @author chenh
 * @version 2017-11-06
 */
@Service
@Transactional(readOnly = true)
public class SysCertificateRelService extends CrudService<SysCertificateRelDao, SysCertificateRel> {

	public SysCertificateRel get(String id) {
		return super.get(id);
	}

	public List<SysCertificateRel> findList(SysCertificateRel sysCertificateRel) {
		return super.findList(sysCertificateRel);
	}

	public Page<SysCertificateRel> findPage(Page<SysCertificateRel> page, SysCertificateRel sysCertificateRel) {
		return super.findPage(page, sysCertificateRel);
	}

	@Transactional(readOnly = false)
	public void save(SysCertificateRel sysCertificateRel) {
		super.save(sysCertificateRel);
	}

	@Transactional(readOnly = false)
	public void delete(SysCertificateRel sysCertificateRel) {
		super.delete(sysCertificateRel);
	}

}