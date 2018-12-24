/**
 *
 */
package com.oseasy.pcore.common.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.DataEntity;
import com.oseasy.pcore.common.persistence.Page;

/**
 * Service基类

 * @version 2014-05-16
 */
//@Transactional(readOnly = true)
public abstract class CrudService<D extends CrudDao<T>, T extends DataEntity<T>> extends BaseService {

	/**
	 * 持久层对象
	 */
	@Autowired
	protected D dao;

	/**
	 * 获取单条数据
	 * @param id
	 * @return
	 */
	public T get(String id) {
		return dao.get(id);
	}

	/**
	 * 获取单条数据
	 * @param entity
	 * @return
	 */
	public T get(T entity) {
		return dao.get(entity);
	}

	/**
	 * 查询列表数据
	 * @param entity
	 * @return
	 */
	public List<T> findList(T entity) {
		return dao.findList(entity);
	}

	/**
	 * 查询分页数据
	 * @param page 分页对象
	 * @param entity
	 * @return
	 */
	public Page<T> findPage(Page<T> page, T entity) {
		entity.setPage(page);
		page.setList(dao.findList(entity));
		return page;
	}

	/**
	 * 保存数据（插入或更新）
	 * @param entity
	 */
	@Transactional(readOnly = false)
	public void save(T entity) {
		if (entity.getIsNewRecord()) {//add
			entity.preInsert();
			dao.insert(entity);
		}else{//update
			entity.preUpdate();
			dao.update(entity);
		}
	}

	/*@Transactional(readOnly = false)
	public void saveInto(T entity) {
		User user = UserUtils.getUser();
				if (StringUtils.isNotBlank(user.getId())) {
					entity.setCreateBy(user);
					entity.setUpdateBy(user);
				}
		entity.setCreateDate(new Date());
		entity.setUpdateDate(new Date());
		dao.insert(entity);
	}*/

	/**
	 * 删除数据
	 * @param entity
	 */
	@Transactional(readOnly = false)
	public void delete(T entity) {
		dao.delete(entity);
	}

}
