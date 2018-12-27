package com.oseasy.initiate.modules.sys.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.initiate.modules.sys.dao.SysCertificateIssuedDao;
import com.oseasy.initiate.modules.sys.entity.SysCertificateIssued;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 系统证书执行记录Service.
 * @author chenh
 * @version 2017-11-07
 */
@Service
@Transactional(readOnly = true)
public class SysCertificateIssuedService extends CrudService<SysCertificateIssuedDao, SysCertificateIssued> {

	public SysCertificateIssued get(String id) {
		return super.get(id);
	}

	public List<SysCertificateIssued> findList(SysCertificateIssued sysCertificateIssued) {
		return super.findList(sysCertificateIssued);
	}

	public Page<SysCertificateIssued> findPage(Page<SysCertificateIssued> page, SysCertificateIssued sysCertificateIssued) {
		return super.findPage(page, sysCertificateIssued);
	}

	/**
   * 根据证书查询授予记录列表;
   * @param entity
   * @return
   */
  public List<SysCertificateIssued> findListByCert(SysCertificateIssued sysCertificateIssued) {
    return dao.findListByCert(sysCertificateIssued);
  }

  public Page<SysCertificateIssued> findPageByCert(Page<SysCertificateIssued> page, SysCertificateIssued sysCertificateIssued) {
    sysCertificateIssued.setPage(page);
    page.setList(findListByCert(sysCertificateIssued));
    return page;
  }

  /**
   * 根据执行人查询授予记录列表;
   * @param entity
   * @return
   */
  public List<SysCertificateIssued> findListByIssued(SysCertificateIssued sysCertificateIssued) {
    return dao.findListByIssued(sysCertificateIssued);
  }

  public Page<SysCertificateIssued> findPageByIssued(Page<SysCertificateIssued> page, SysCertificateIssued sysCertificateIssued) {
    sysCertificateIssued.setPage(page);
    page.setList(findListByIssued(sysCertificateIssued));
    return page;
  }

  /**
   * 根据被执行人查询授予记录列表;
   * @param entity
   * @return
   */
  public List<SysCertificateIssued> findListByAccept(SysCertificateIssued sysCertificateIssued) {
    return dao.findListByAccept(sysCertificateIssued);
  }

  public Page<SysCertificateIssued> findPageByAccept(Page<SysCertificateIssued> page, SysCertificateIssued sysCertificateIssued) {
    sysCertificateIssued.setPage(page);
    page.setList(findListByAccept(sysCertificateIssued));
    return page;
  }

  /**
   * 根据业务查询授予记录列表;
   * @param entity
   * @return
   */
  public List<SysCertificateIssued> findListByYw(SysCertificateIssued sysCertificateIssued) {
    return dao.findListByYw(sysCertificateIssued);
  }

  public Page<SysCertificateIssued> findPageByYw(Page<SysCertificateIssued> page, SysCertificateIssued sysCertificateIssued) {
    sysCertificateIssued.setPage(page);
    page.setList(findListByYw(sysCertificateIssued));
    return page;
  }

	@Transactional(readOnly = false)
	public void save(SysCertificateIssued sysCertificateIssued) {
	  if (StringUtil.isEmpty(sysCertificateIssued.getIsYw())) {
      sysCertificateIssued.setIsYw(Global.NO);
    }
	  if (sysCertificateIssued.getIssuedBy() == null) {
      sysCertificateIssued.setIssuedBy(CoreUtils.getUser());
    }
	  if (sysCertificateIssued.getIsYw() == null) {
	    sysCertificateIssued.setIssuedBy(CoreUtils.getUser());
	  }
		super.save(sysCertificateIssued);
	}

	@Transactional(readOnly = false)
	public void delete(SysCertificateIssued sysCertificateIssued) {
		super.delete(sysCertificateIssued);
	}

}