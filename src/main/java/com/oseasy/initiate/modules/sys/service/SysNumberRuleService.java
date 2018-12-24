package com.oseasy.initiate.modules.sys.service;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import com.alibaba.fastjson.JSONObject;
import com.oseasy.initiate.modules.sys.dao.AppTypeDao;
import com.oseasy.initiate.modules.sys.entity.SysNumberRuleDetail;
import com.oseasy.initiate.modules.sys.utils.EnumUtils;
import com.oseasy.pact.modules.act.entity.Act;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.pcore.common.utils.IdGen;
import com.oseasy.pcore.modules.sys.entity.Dict;
import com.oseasy.pcore.modules.sys.utils.DictUtils;
import com.oseasy.putil.common.utils.Tree;
import com.oseasy.putil.common.utils.exception.RunException;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.initiate.modules.sys.entity.SysNumberRule;
import com.oseasy.initiate.modules.sys.dao.SysNumberRuleDao;
import org.springframework.util.StringUtils;

/**
 * 编号规则管理Service.
 *
 * @author 李志超
 * @version 2018-05-17
 */
@Service
@Transactional(readOnly = false)
public class SysNumberRuleService extends CrudService<SysNumberRuleDao, SysNumberRule> {

    private static String APP_TYPE = "app_type"; //字典表中type为app_type数据

    @Autowired
    private AppTypeDao appTypeDao;
    @Autowired
    private SysNumberRuleDetailService sysNumberRuleDetailService;


    public SysNumberRule get(String id) {
        return super.get(id);
    }

    public List<SysNumberRule> findList(SysNumberRule sysNumberRule) {
        return dao.findList(sysNumberRule);
    }

    public Page<SysNumberRule> findPage(Page<SysNumberRule> page, SysNumberRule sysNumberRule) {
        return super.findPage(page, sysNumberRule);
    }

    @Transactional(readOnly = false)
    public void save(SysNumberRule sysNumberRule) {
        try {
            if (StringUtils.isEmpty(sysNumberRule.getId())) {//判断主键为空时进行保存操作
                if (!StringUtils.isEmpty(dao.getRuleByAppType(sysNumberRule.getAppType(), sysNumberRule.getId()))) {//做应用类型唯一性校验
                    throw new RunException("该应用编号规则已存在, 不可重复添加");
                }
                super.save(sysNumberRule);
            } else { //判断主键非空时为编辑操作，对规则明细表中的内容进行删除操作
                sysNumberRuleDetailService.deleteByRuleId(sysNumberRule.getId());
            }

            List<SysNumberRuleDetail> sysNumberRuleDetailList = sysNumberRule.getSysNumberRuleDetailList();
            //对明细列表进行顺序排序
            Collections.sort(sysNumberRuleDetailList, new Comparator<SysNumberRuleDetail>() {
                public int compare(SysNumberRuleDetail detail1, SysNumberRuleDetail detail2) {
                    return detail1.getSort() - detail1.getSort();
                }
            });
            //设置规则主表中的规则正则
            sysNumberRule.setRule(getRegRuleText(sysNumberRuleDetailList, sysNumberRule.getId()));

            super.save(sysNumberRule);
            sysNumberRuleDetailService.batchSave(sysNumberRuleDetailList);
        } catch (RunException e) {
            throw new RunException(e.getMsg());
        }
    }

    @Transactional(readOnly = false)
    public void update(SysNumberRule sysNumberRule) {
        super.save(sysNumberRule);
    }

    /**
     * 生成编号规则正则
     *
     * @param sysNumberRuleDetailList 规则明细列表
     * @param fk                      规则主表id
     * @return
     */
    private String getRegRuleText(List<SysNumberRuleDetail> sysNumberRuleDetailList, String fk) {

        StringBuffer rule = new StringBuffer();

        for (SysNumberRuleDetail detail : sysNumberRuleDetailList) {

            //通过规则类型获取该规则正则，并进行拼接
            rule.append(EnumUtils.RuleType.getRuleText(detail));

            //设置规则明细中的主表id及明细表主键
            detail.setProNumberRuleId(fk);
            detail.setId(IdGen.uuid());
        }
        return rule.toString();
    }

    @Transactional(readOnly = false)
    public void delete(SysNumberRule sysNumberRule) {
        try {
            sysNumberRuleDetailService.deleteByRuleId(sysNumberRule.getId());
            dao.deleteWL(sysNumberRule);
        } catch (Exception e) {
            throw new RuntimeException("删除失败,请联系管理员");
        }
    }

    @Transactional(readOnly = false)
    public void deleteWL(SysNumberRule sysNumberRule) {
        dao.deleteWL(sysNumberRule);
    }

    @Transactional(readOnly = true)
    public List<Tree> getAppTypeTreeList() {

        try {
            //获取字典表中的APP_TYPE类别
            List<Dict> dictList = DictUtils.getDictListByType(APP_TYPE);
            List<Tree> trees = new ArrayList<>();

            //添加大类下的小类
            dictList.forEach(dict -> {
                Tree tree = new Tree();
                tree.setId(dict.getId());
                tree.setText(dict.getLabel());
                tree.setParentId("0");

                //获取字典表中value值：{"method":"getAppTypeList", "params":{"flowType":1}}
                JSONObject jsonObject = JSONObject.parseObject(dict.getValue());
                jsonObject.getJSONObject("params").put("parentId", dict.getId());

                //获取appTypeDao中的methods
                Method[] methods = appTypeDao.getClass().getDeclaredMethods();
                //遍历appTypeDao中的methods
                for (Method method : methods) {
                    //匹配value中method方法是否相同，相同则执行此方法
                    if (method.getName().equals((String) jsonObject.get("method"))) {
                        try {
                            List<Tree> childList = (List<Tree>) method.invoke(appTypeDao, jsonObject.getJSONObject("params"));
                            tree.setChildList(childList);
                            trees.add(tree);
                        } catch (IllegalAccessException e) {
                            e.printStackTrace();
                        } catch (InvocationTargetException e) {
                            e.printStackTrace();
                        }
                    }
                }
            });
            return trees;
        } catch (Exception e) {
            throw new RunException("查询应用列表数据失败，请联系管理员");
        }
    }

    @Transactional(readOnly = true)
    public SysNumberRule getRuleByAppType(String appType, String id) {
        return dao.getRuleByAppType(appType, id);
    }
    //根据规则id获得具体规则明细
    public List<SysNumberRuleDetail> findSysNumberRuleDetailList(String id) {
        return sysNumberRuleDetailService.findSysNumberRuleDetailList(id);
    }
}