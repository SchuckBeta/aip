/**
 * .
 */

package com.oseasy.pcas.modules.cas.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.oseasy.pcas.common.config.CasSval;
import com.oseasy.pcas.modules.cas.dao.DBCasAnZhiDao;
import com.oseasy.pcas.modules.cas.dao.SysCasAnZhiDao;
import com.oseasy.pcas.modules.cas.entity.SysCasAnZhi;
import com.oseasy.pcas.modules.cas.entity.SysCasUser;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * .
 * @author chenhao
 *
 */
@Service
@Transactional(readOnly = true)
public class SysCasAnZhiService extends CrudService<SysCasAnZhiDao, SysCasAnZhi> {
    @Autowired
    SysCasUserService sysCasUserService;

    /**
     * 删除数据
     * @param entity
     */
    @Transactional(readOnly = false)
    public void delete(SysCasAnZhi entity) {
        //dao.delete(entity);
    }

    /**
     * 批量更新Enable数据
     * @param entity
     * @return
     */
    @Transactional(readOnly = false)
    public void updateByPlEnable(List<String> ids, Boolean enable){
        dao.updateByPlEnable(ids, enable);
    }

    /**
     * 批量更新DelFlag数据
     * @param entity
     * @return
     */
    @Transactional(readOnly = false)
    public void updateByPlDelFlag(List<String> ids, String delFlag){
        dao.updateByPlDelFlag(ids, delFlag);
    }

    @Transactional(readOnly = false)
    public synchronized void casJob(){
        SysCasUser psysCasUser = new SysCasUser();
        psysCasUser.setDelFlag(CoreSval.NO);
        List<SysCasAnZhi> sysCasAnZhis = DBCasAnZhiDao.findList(true);
        if(StringUtil.checkEmpty(sysCasAnZhis)){
            return;
        }

        List<SysCasUser> sysCasUsers = sysCasUserService.findAllList();
        List<SysCasAnZhi> disenableSysCasAnZhis = Lists.newArrayList();
        List<SysCasAnZhi> addtimeSysCasAnZhis = Lists.newArrayList();
        List<SysCasUser> jobSysCasUsers = Lists.newArrayList();
        for (SysCasAnZhi sysCasAnZhi : sysCasAnZhis) {
            if(sysCasAnZhi.getTime() >= CasSval.CAS_TIME_MAX){
                disenableSysCasAnZhis.add(sysCasAnZhi);
                continue;
            }

            Boolean hasDeal = false;
            for (SysCasUser sysCasUser : sysCasUsers) {
                if((sysCasAnZhi.getRuid()).equals(sysCasUser.getRuid())){
                    hasDeal = true;
                    break;
                }
            }

            if(hasDeal){
                disenableSysCasAnZhis.add(sysCasAnZhi);
            }else{
                SysCasUser curSysCasUser = SysCasAnZhi.newSysCasUser(sysCasAnZhi);
                if(curSysCasUser.getIsDeal()){
                    jobSysCasUsers.add(curSysCasUser);
                }else{
                    sysCasAnZhi.setTime(sysCasAnZhi.getTime() + 1);
                    addtimeSysCasAnZhis.add(sysCasAnZhi);
                }
            }
        }

        /**
         * 已处理或已存在的用户数据，标记为已处理.
         */
        if(StringUtil.checkNotEmpty(disenableSysCasAnZhis)){
            DBCasAnZhiDao.updatePLPropEnable(StringUtil.sqlInByListIdss(disenableSysCasAnZhis), CoreSval.YES);
        }

        /**
         * 处理失败的用户数据，处理次数+1.
         */
        if(StringUtil.checkNotEmpty(addtimeSysCasAnZhis)){
            DBCasAnZhiDao.updatePLPropTime(addtimeSysCasAnZhis);
        }

        /**
         * 处理成功的用户数据，保存到SysCasUser表.
         */
        if(StringUtil.checkNotEmpty(jobSysCasUsers)){
            sysCasUserService.savePL(jobSysCasUsers);
        }
    }
}
