package com.oseasy.initiate.modules.sys.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oseasy.initiate.modules.sys.entity.SysProp;
import com.oseasy.initiate.modules.sys.service.SysPropService;
import com.oseasy.initiate.modules.sys.vo.SysPropType;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 系统功能Controller.
 * @author chenh
 * @version 2018-03-30
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sysProp")
public class SysPropController extends BaseController {

	@Autowired
	private SysPropService sysPropService;

	@ModelAttribute
	public SysProp get(@RequestParam(required=false) String id) {
		SysProp entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = sysPropService.get(id);
		}
		if (entity == null){
			entity = new SysProp();
		}
		return entity;
	}

	@RequiresPermissions("sys:sysProp:view")
	@RequestMapping(value = {"list", ""})
	public String list(SysProp sysProp, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<SysProp> page = sysPropService.findPage(new Page<SysProp>(request, response), sysProp);
		model.addAttribute("page", page);
        model.addAttribute(SysPropType.SYS_PROP_TYPES, SysPropType.values());
		return "modules/sys/sysPropList";
	}

	@RequiresPermissions("sys:sysProp:view")
	@RequestMapping(value = "form")
	public String form(SysProp sysProp, Model model) {
		model.addAttribute("sysProp", sysProp);
        model.addAttribute(SysPropType.SYS_PROP_TYPES, SysPropType.values());
		return "modules/sys/sysPropForm";
	}

    @RequiresPermissions("sys:sysPropItem:view")
    @RequestMapping(value = "listForm")
    public String listForm(SysProp sysProp, Model model) {
        model.addAttribute("sysProp", sysPropService.get(sysProp.getId()));
        model.addAttribute(SysPropType.SYS_PROP_TYPES, SysPropType.values());
        return "modules/sys/sysPropListForm";
    }

    @RequiresPermissions("sys:sysProp:view")
    @RequestMapping(value = "setProp")
    public String setProp(SysProp sysProp, Model model) {
//        if(StringUtil.isNotEmpty(sysProp.getId())){
//            sysProp = sysPropService.get(sysProp.getId());
//            Map<String, Object> maps = SysPropType.getMaps(pwRenewalRuleService);
////			maps.put(SysPropType.SPT_ENTER.getKey(), JsonMapper.fromJsonString("", sysProp.getItems().get(0).getParams()));
//			//maps.put(SysPropType.SPT_DOOR.getKey(), sysProp);
//
//
//			model.addAttribute("sysPropAA", sysProp);
//            model.addAttribute("sysProp", SysProp.render(maps, sysProp));
//        }
        model.addAttribute(SysPropType.SYS_PROP_TYPES, SysPropType.values());
        return "modules/sys/sysPropSetForm";
    }



	@RequiresPermissions("sys:sysProp:edit")
	@RequestMapping(value = "save")
	public String save(SysProp sysProp, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sysProp)){
			return form(sysProp, model);
		}
		sysPropService.save(sysProp);
		addMessage(redirectAttributes, "保存系统功能成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/sys/sysProp/?repage";
	}

	@RequiresPermissions("sys:sysProp:edit")
	@RequestMapping(value = "delete")
	public String delete(SysProp sysProp, RedirectAttributes redirectAttributes) {
		sysPropService.delete(sysProp);
		addMessage(redirectAttributes, "删除系统功能成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/sys/sysProp/?repage";
	}

}