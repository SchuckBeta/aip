/**
 *
 */
package com.oseasy.initiate.modules.gen.web;

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

import com.oseasy.initiate.modules.gen.entity.GenTemplate;
import com.oseasy.initiate.modules.gen.service.GenTemplateService;
import com.oseasy.initiate.modules.sys.utils.UserUtils;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 代码模板Controller


 */
@Controller
@RequestMapping(value = "${adminPath}/gen/genTemplate")
public class GenTemplateController extends BaseController {

	@Autowired
	private GenTemplateService genTemplateService;

	@ModelAttribute
	public GenTemplate get(@RequestParam(required=false) String id) {
		if (StringUtil.isNotBlank(id)) {
			return genTemplateService.get(id);
		}else{
			return new GenTemplate();
		}
	}

	@RequiresPermissions("gen:genTemplate:view")
	@RequestMapping(value = {"list", ""})
	public String list(GenTemplate genTemplate, HttpServletRequest request, HttpServletResponse response, Model model) {
		User user = UserUtils.getUser();
		if (!user.getAdmin()) {
			genTemplate.setCreateBy(user);
		}
        Page<GenTemplate> page = genTemplateService.find(new Page<GenTemplate>(request, response), genTemplate);
        model.addAttribute("page", page);
		return "modules/gen/genTemplateList";
	}

	@RequiresPermissions("gen:genTemplate:view")
	@RequestMapping(value = "form")
	public String form(GenTemplate genTemplate, Model model) {
		model.addAttribute("genTemplate", genTemplate);
		return "modules/gen/genTemplateForm";
	}

	@RequiresPermissions("gen:genTemplate:edit")
	@RequestMapping(value = "save")
	public String save(GenTemplate genTemplate, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, genTemplate)) {
			return form(genTemplate, model);
		}
		genTemplateService.save(genTemplate);
		addMessage(redirectAttributes, "保存代码模板'" + genTemplate.getName() + "'成功");
		return CoreSval.REDIRECT + adminPath + "/gen/genTemplate/?repage";
	}

	@RequiresPermissions("gen:genTemplate:edit")
	@RequestMapping(value = "delete")
	public String delete(GenTemplate genTemplate, RedirectAttributes redirectAttributes) {
		genTemplateService.delete(genTemplate);
		addMessage(redirectAttributes, "删除代码模板成功");
		return CoreSval.REDIRECT + adminPath + "/gen/genTemplate/?repage";
	}

}
