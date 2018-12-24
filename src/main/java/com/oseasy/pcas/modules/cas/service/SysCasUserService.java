package com.oseasy.pcas.modules.cas.service;

import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcas.common.config.CasSval;
import com.oseasy.pcas.modules.cas.dao.SysCasUserDao;
import com.oseasy.pcas.modules.cas.entity.SysCasUser;
import com.oseasy.pcas.modules.cas.vo.CheckRet;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.StringUtil;

@Service
@Transactional(readOnly = true)
public class SysCasUserService extends CrudService<SysCasUserDao, SysCasUser> {
	public static Logger logger = Logger.getLogger(SysCasUserService.class);

    /**
     * 获取单条数据
     * @param id
     * @return
     */
    public SysCasUser get(String id) {
        return super.get(id);
    }

    /**
     * 获取单条数据
     * @param entity
     * @return
     */
    public SysCasUser get(SysCasUser entity) {
        return dao.get(entity);
    }

    /**
     * 查询列表数据
     * @param entity
     * @return
     */
    public List<SysCasUser> findList(SysCasUser entity) {
        return dao.findList(entity);
    }

    /**
     * 查询分页数据
     * @param page 分页对象
     * @param entity
     * @return
     */
    public Page<SysCasUser> findPage(Page<SysCasUser> page, SysCasUser entity) {
        entity.setPage(page);
        page.setList(dao.findList(entity));
        return page;
    }

    /**
     * 查询所有数据列表
     * @param entity
     * @return
     */
    public List<SysCasUser> findAllList(){
        return dao.findAllList();
    }

    /**
     * 保存数据（插入）
     * @param entity
     */
    @Transactional(readOnly = false)
    public void insert(SysCasUser entity) {
        dao.insert(entity);
    }

    /**
     * 保存数据（更新）
     * @param entity
     */
    @Transactional(readOnly = false)
    public void update(SysCasUser entity) {
        dao.update(entity);
    }

    /**
     * 保存数据（插入或更新）
     * @param entity
     */
    @Transactional(readOnly = false)
    public void save(SysCasUser entity) {
        if ((entity.getIsNewRecord())) {
            if (StringUtil.isEmpty(entity.getId())) {
                entity.setTime(1);
            }
            if (entity.getLastLoginDate() == null) {
                entity.setLastLoginDate(new Date());
            }
            if (entity.getEnable() == null) {
                entity.setEnable(true);
            }
        }
        if(entity.getType() == null){
            entity.setType(CasSval.CAS_TYPE);
        }
        super.save(entity);
    }

    /**
     * 删除数据
     * @param entity
     */
    @Transactional(readOnly = false)
    public void delete(SysCasUser entity) {
        dao.delete(entity);
    }

    /**
     * 批量修改CAS状态.
     * @param entity
     */
    @Transactional(readOnly = false)
    public void updateALLEnable(SysCasUser entity) {
        if((entity.getType() == null)){
            entity.setType(CasSval.CAS_TYPE);
        }
        dao.updateALLEnable(entity);
    }

    /**
     * 批量保存.
     * @param entitys
     */
    @Transactional(readOnly = false)
    public void savePL(List<SysCasUser> entitys) {
        dao.savePL(entitys);
    }

    /**
     * 检查用户是否存在
     * @param entity
     * @return
     */
    public SysCasUser checkSysCaseUser(SysCasUser entity) {
        if(entity == null){
            entity = new SysCasUser();
        }

        if(StringUtil.isEmpty(entity.getRuid()) || (entity.getType() == null)){
            entity.setCheckRet(CheckRet.FALSE.getKey());
            return entity;
        }

        SysCasUser pentity = new SysCasUser();
        pentity.setRuid(entity.getRuid());
        List<SysCasUser> entitys = dao.findList(pentity);
        if(StringUtil.checkEmpty(entitys)){
            entity.setCheckRet(CheckRet.FALSE.getKey());
            return entity;
        }

        String rutype = entity.getRutype();
        Boolean checkUtype = entity.getCheckUtype();
        if((entitys.size() > 0)){
            entity = entitys.get(0);
            if(StringUtil.isEmpty(entity.getRutype()) && StringUtil.isNotEmpty(rutype)){
                entity.setRutype(rutype);
            }
            entity.setCheckUtype(checkUtype);
            entity.setCheckRet(CheckRet.TRUE.getKey());
        }else{
            entity.setEnable(true);
        }

        return entity;
    }
}
