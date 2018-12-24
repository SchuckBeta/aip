package com.oseasy.pcore.modules.authorize.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.pcore.modules.authorize.dao.SysLicenseDao;
import com.oseasy.pcore.modules.authorize.entity.SysLicense;

/**
 * 授权信息Service
 * @author 9527
 * @version 2017-04-13
 */
@Service
@Transactional(readOnly = true)
public class SysLicenseService extends CrudService<SysLicenseDao, SysLicense> {
	public static boolean unValid=false;
	public static final String KEY="0e531a31dd73418c8951b1a1c83db33c";

	public SysLicense getLicense() {
		return super.get(KEY);
	}

	public SysLicense get(String id) {
		return super.get(id);
	}

	public List<SysLicense> findList(SysLicense sysLicense) {
		return super.findList(sysLicense);
	}

	public Page<SysLicense> findPage(Page<SysLicense> page, SysLicense sysLicense) {
		return super.findPage(page, sysLicense);
	}

	@Transactional(readOnly = false)
	public void saveLicense(SysLicense sysLicense) {
		sysLicense.setId(KEY);
		super.save(sysLicense);
	}
	@Transactional(readOnly = false)
	public void save(SysLicense sysLicense) {
		super.save(sysLicense);
	}
	@Transactional(readOnly = false)
	public void delete(SysLicense sysLicense) {
		super.delete(sysLicense);
	}
	@Transactional(readOnly = false)
	public void insertWithId(SysLicense sysLicense) {
		dao.insertWithId(sysLicense);
	}
}