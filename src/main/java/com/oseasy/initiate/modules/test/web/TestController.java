/**
 *
 */
package com.oseasy.initiate.modules.test.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oseasy.initiate.modules.sys.utils.UserUtils;
import com.oseasy.initiate.modules.test.entity.Test;
import com.oseasy.initiate.modules.test.service.TestService;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 测试Controller


 */
@Controller
@RequestMapping(value = "${adminPath}/test/test")
public class TestController extends BaseController {

	@Autowired
	private TestService testService;

	@ModelAttribute
	public Test get(@RequestParam(required=false) String id) {
		if (StringUtil.isNotBlank(id)) {
			return testService.get(id);
		}else{
			return new Test();
		}
	}

	/**
	 * 显示列表页
	 * @param test
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = {"list", ""})
	public String list(Test test, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/test/testList";
	}

	/**
	 * 获取硕正列表数据（JSON）
	 * @param test
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "listData")
	@ResponseBody
	public Page<Test> listData(Test test, HttpServletRequest request, HttpServletResponse response, Model model) {
		User user = UserUtils.getUser();
		if (!user.getAdmin()) {
			test.setCreateBy(user);
		}
        Page<Test> page = testService.findPage(new Page<Test>(request, response), test);
        return page;
	}

	/**
	 * 新建或修改表单
	 * @param test
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "form")
	public String form(Test test, Model model) {
		model.addAttribute("test", test);
		return "modules/test/testForm";
	}

	/**
	 * 表单保存方法
	 * @param test
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "save")
	public String save(Test test, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, test)) {
			return form(test, model);
		}
//		testService.save(test);
		addMessage(redirectAttributes, "保存测试'" + test.getName() + "'成功");
		return CoreSval.REDIRECT + adminPath + "/test/test/?repage";
	}

	/**
	 * 删除数据方法
	 * @param id
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "delete")
	@ResponseBody
	public String delete(Test test, RedirectAttributes redirectAttributes) {
//		testService.delete(test);
//		addMessage(redirectAttributes, "删除测试成功");
//		return CoreSval.REDIRECT + adminPath + "/test/test/?repage";
		return "true";
	}

}
