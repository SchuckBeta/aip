package com.oseasy.initiate.modules.sys.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.initiate.modules.sys.entity.SysPropItem;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.initiate.modules.sys.dao.SysPropItemDao;

/**
 * 系统功能配置项Service.
 * @author chenh
 * @version 2018-03-30
 */
@Service
@Transactional(readOnly = true)
public class SysPropItemService extends CrudService<SysPropItemDao, SysPropItem> {

	public SysPropItem get(String id) {
		return super.get(id);
	}

	public List<SysPropItem> findList(SysPropItem sysPropItem) {
		return super.findList(sysPropItem);
	}

	public Page<SysPropItem> findPage(Page<SysPropItem> page, SysPropItem sysPropItem) {
		return super.findPage(page, sysPropItem);
	}

	@Transactional(readOnly = false)
	public void save(SysPropItem sysPropItem) {
		super.save(sysPropItem);
	}

	@Transactional(readOnly = false)
	public void delete(SysPropItem sysPropItem) {
		super.delete(sysPropItem);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(SysPropItem sysPropItem) {
  	  dao.deleteWL(sysPropItem);
  	}
}