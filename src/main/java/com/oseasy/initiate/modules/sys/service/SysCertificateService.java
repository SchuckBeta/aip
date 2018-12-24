package com.oseasy.initiate.modules.sys.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.initiate.modules.sys.entity.SysCertificate;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.initiate.modules.sys.dao.SysCertificateDao;

/**
 * 系统证书表Service.
 * @author chenh
 * @version 2017-10-23
 */
@Service
@Transactional(readOnly = true)
public class SysCertificateService extends CrudService<SysCertificateDao, SysCertificate> {

	public SysCertificate get(String id) {
		return super.get(id);
	}

	public List<SysCertificate> findList(SysCertificate sysCertificate) {
		return super.findList(sysCertificate);
	}

	public Page<SysCertificate> findPage(Page<SysCertificate> page, SysCertificate sysCertificate) {
		return super.findPage(page, sysCertificate);
	}

	@Transactional(readOnly = false)
	public void save(SysCertificate sysCertificate) {
	  if (sysCertificate.getHasUse() == null) {
	    sysCertificate.setHasUse(false);
	  }
		super.save(sysCertificate);
	}

	@Transactional(readOnly = false)
	public void delete(SysCertificate sysCertificate) {
		super.delete(sysCertificate);
	}
	@Transactional(readOnly = false)
	public void updateHasUsePL(List<SysCertificate> sysCertificates, Boolean hasUse) {
	  dao.updateHasUsePL(sysCertificates, hasUse);
	}

}