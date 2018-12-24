package com.oseasy.pact.modules.actyw.service;

import java.util.Arrays;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.oseasy.pact.modules.actyw.dao.ActYwFormDao;
import com.oseasy.pact.modules.actyw.entity.ActYwForm;
import com.oseasy.pact.modules.actyw.entity.ActYwFormVo;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowType;
import com.oseasy.pact.modules.actyw.tool.process.vo.FormStyleType;
import com.oseasy.pact.modules.actyw.tool.process.vo.FormTheme;
import com.oseasy.pact.modules.actyw.tool.process.vo.FormType;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 项目流程表单Service.
 * @author chenhao
 * @version 2017-05-23
 */
@Service
@Transactional(readOnly = true)
public class ActYwFormService extends CrudService<ActYwFormDao, ActYwForm> {
  private static final String FORM_MODE_FILE = "1";

  public ActYwForm get(String id) {
		return super.get(id);
	}

	public List<ActYwForm> findList(ActYwForm actYwForm) {
        if(StringUtil.checkEmpty(actYwForm.getThemes())){
            if(actYwForm.getTheme() != null){
                actYwForm.setThemes(Arrays.asList(new Integer[]{actYwForm.getTheme()}));
            }else{
                actYwForm.setThemes(FormTheme.getAllIds());
            }
        }
		return super.findList(actYwForm);
	}

    /**
     * 根据Style查询列表只有FormStyleType.FST_LIST类型.
     * @param actYwForm
     *            实体
     * @return List
     */
    public List<ActYwForm> findListByInStyleList(ActYwForm actYwForm) {
        if (actYwForm == null) {
            return null;
        }
        if(StringUtil.checkEmpty(actYwForm.getThemes())){
            if(actYwForm.getTheme() != null){
                actYwForm.setThemes(Arrays.asList(new Integer[]{actYwForm.getTheme()}));
            }else{
                actYwForm.setThemes(FormTheme.getAllIds());
            }
        }
        return dao.findListByInStyle(new ActYwFormVo(true, actYwForm));
    }

    /**
     * 根据Style查询列表无FormStyleType.FST_LIST类型 .
     * @param actYwForm
     *            实体
     * @return List
     */
    public List<ActYwForm> findListByInStyleNoList(ActYwForm actYwForm) {
        if (actYwForm == null) {
            return null;
        }
        if(StringUtil.checkEmpty(actYwForm.getThemes())){
            if(actYwForm.getTheme() != null){
                actYwForm.setThemes(Arrays.asList(new Integer[]{actYwForm.getTheme()}));
            }else{
                actYwForm.setThemes(FormTheme.getAllIds());
            }
        }
        return dao.findListByInStyle(new ActYwFormVo(false, actYwForm));
    }

	public Page<ActYwForm> findPage(Page<ActYwForm> page, ActYwForm actYwForm) {
	    if(StringUtil.checkEmpty(actYwForm.getThemes())){
	        if(actYwForm.getTheme() != null){
	            actYwForm.setThemes(Arrays.asList(new Integer[]{actYwForm.getTheme()}));
	        }else{
	            actYwForm.setThemes(FormTheme.getAllIds());
	        }
        }
		return super.findPage(page, actYwForm);
	}

	@Transactional(readOnly = false)
	public void save(ActYwForm actYwForm) {
	    if ((actYwForm != null) && StringUtil.isNotEmpty(actYwForm.getType())) {
            actYwForm.setFlowType(FormType.getFlowStrByKey(actYwForm.getType()));

            List<FlowType> allFlowTypes = Lists.newArrayList();
            for (String curfType : actYwForm.getFlowTypes()) {
                FlowType curflowType = FlowType.getByKey(curfType);
                if (curflowType != null) {
                    allFlowTypes.add(curflowType);
                }
            }

            FormType formType = FormType.getByKey(actYwForm.getType());
            if (allFlowTypes.contains(FlowType.FWT_ALL)) {
                actYwForm.setProType(FlowType.FWT_ALL.getType().getTypes());
            }else{
                actYwForm.setProType(FormType.getProStrByKey(actYwForm.getType()));
            }

            if (StringUtil.isEmpty(actYwForm.getName())) {
                actYwForm.setName(formType.getName());
            }

            actYwForm.setModel(FORM_MODE_FILE);
            if ((actYwForm.getPath()).contains(StringUtil.POSTFIX_JSP)) {
                actYwForm.setPath((actYwForm.getPath()).replaceAll(StringUtil.POSTFIX_JSP, ""));
            }

            actYwForm.setPath(actYwForm.getPath());
            if (formType != null) {
                actYwForm.setStyleType(formType.getStyle().getKey());
                actYwForm.setClientType(formType.getClient().getKey());
            }

	        super.save(actYwForm);
    	    if (formType != null) {
                if ((formType.getStyle()).equals(FormStyleType.FST_LIST)) {
                  actYwForm.setListId(actYwForm.getId());
                  super.save(actYwForm);
                }
    	    }
	    }
	}

	@Transactional(readOnly = false)
	public void delete(ActYwForm actYwForm) {
		super.delete(actYwForm);
	}

}