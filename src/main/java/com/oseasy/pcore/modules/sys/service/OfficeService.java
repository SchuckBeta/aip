/**
 *
 */
package com.oseasy.pcore.modules.sys.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.service.TreeService;
import com.oseasy.pcore.modules.sys.dao.OfficeDao;
import com.oseasy.pcore.modules.sys.entity.Office;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;
import com.oseasy.pcore.modules.sys.utils.OfficeUtils;

/**
 * 机构Service

 * @version 2014-05-16
 */
@Service
@Transactional(readOnly = true)
public class OfficeService extends TreeService<OfficeDao, Office> {
	@Autowired
	OfficeDao officeDao;
	public List<Office> findAll() {
		return CoreUtils.getOfficeList();
	}

	public List<Office> findList(Boolean isAll) {
		if (isAll != null && isAll) {
			return CoreUtils.getOfficeAllList();
		}else{
			return CoreUtils.getOfficeList();
		}
	}

	public List<Office> findListFront(Boolean isAll) {
		return CoreUtils.getOfficeListFront();
	}

	@Transactional(readOnly = true)
	public List<Office> findList(Office office) {
		if (office != null) {
			office.setParentIds(office.getParentIds()+"%");
			return dao.findByParentIdsLike(office);
		}
		return  new ArrayList<Office>();
	}

	@Transactional(readOnly = false)
	public void save(Office office) {
//	    if(office.getIsNewRecord()){
//	        office.setId(IdGen.uuid());
//	    }
		super.save(office);
		CoreUtils.removeCache(CoreUtils.CACHE_OFFICE_LIST);
		CoreUtils.removeCache("officeListFront");
		OfficeUtils.clearCache();
	}

	@Transactional(readOnly = false)
	public void saveById(Office office) {
		if(office.getId()!=null && "1".equals(office.getId())){
			dao.updateSpace(office);
		}
		save(office);
	}

	@Transactional(readOnly = false)
	public void delete(Office office) {
		super.delete(office);
		CoreUtils.removeCache(CoreUtils.CACHE_OFFICE_LIST);
		CoreUtils.removeCache("officeListFront");
		OfficeUtils.clearCache();
	}

	@Transactional(readOnly = false)
	public void update(Office office) {
		officeDao.update(office);
		CoreUtils.removeCache(CoreUtils.CACHE_OFFICE_LIST);
		CoreUtils.removeCache("officeListFront");
		OfficeUtils.clearCache();
	}

	public String selelctParentId(String id) {
		return officeDao.selelctParentId(id);
	}

	public Boolean checkByName(String parentId, String name) {
	    return (officeDao.checkNameByParent(parentId, name) == 0) ? false : true;
	}

	public Boolean checkByNameAndId(String id,String parentId, String name) {
		return (officeDao.checkByNameAndId(id,parentId, name) == 0) ? false : true;
	}

	public List<Office> findColleges() {
		return officeDao.findColleges();
	}

	public List<Office> findProfessionals(String parentId) {
		return officeDao.findProfessionals(parentId);
	}

	public List<Office>  findProfessionByParentIdsLike(Office office) {
		return officeDao.findProfessionByParentIdsLike(office);
	}

	public  List<Office> findProfessionByParentIds(String officeIds) {
		return officeDao.findProfessionByParentIds(officeIds);
	}

}
