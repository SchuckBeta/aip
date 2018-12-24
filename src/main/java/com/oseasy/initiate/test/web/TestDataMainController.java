/**
 *
 */
package com.oseasy.initiate.test.web;

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

import com.oseasy.initiate.test.entity.TestDataMain;
import com.oseasy.initiate.test.service.TestDataMainService;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 主子表生成Controller

 * @version 2015-04-06
 */
@Controller
@RequestMapping(value = "${adminPath}/test/testDataMain")
public class TestDataMainController extends BaseController {

	@Autowired
	private TestDataMainService testDataMainService;

	@ModelAttribute
	public TestDataMain get(@RequestParam(required=false) String id) {
		TestDataMain entity = null;
		if (StringUtil.isNotBlank(id)) {
			entity = testDataMainService.get(id);
		}
		if (entity == null) {
			entity = new TestDataMain();
		}
		return entity;
	}

	@RequiresPermissions("test:testDataMain:view")
	@RequestMapping(value = {"list", ""})
	public String list(TestDataMain testDataMain, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<TestDataMain> page = testDataMainService.findPage(new Page<TestDataMain>(request, response), testDataMain);
		model.addAttribute("page", page);
		return "initiate/test/testDataMainList";
	}

	@RequiresPermissions("test:testDataMain:view")
	@RequestMapping(value = "form")
	public String form(TestDataMain testDataMain, Model model) {
		model.addAttribute("testDataMain", testDataMain);
		return "initiate/test/testDataMainForm";
	}

	@RequiresPermissions("test:testDataMain:edit")
	@RequestMapping(value = "save")
	public String save(TestDataMain testDataMain, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, testDataMain)) {
			return form(testDataMain, model);
		}
		testDataMainService.save(testDataMain);
		addMessage(redirectAttributes, "保存主子表成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/test/testDataMain/?repage";
	}

	@RequiresPermissions("test:testDataMain:edit")
	@RequestMapping(value = "delete")
	public String delete(TestDataMain testDataMain, RedirectAttributes redirectAttributes) {
		testDataMainService.delete(testDataMain);
		addMessage(redirectAttributes, "删除主子表成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/test/testDataMain/?repage";
	}

}