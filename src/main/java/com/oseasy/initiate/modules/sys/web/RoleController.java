/**
 *
 */
package com.oseasy.initiate.modules.sys.web;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.oseasy.initiate.modules.sys.service.SystemService;
import com.oseasy.initiate.modules.sys.utils.UserUtils;
import com.oseasy.pact.modules.actyw.entity.ActYwGrole;
import com.oseasy.pact.modules.actyw.service.ActYwGroleService;
import com.oseasy.pcore.common.config.ApiConst;
import com.oseasy.pcore.common.config.ApiResult;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.mapper.JsonMapper;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.Office;
import com.oseasy.pcore.modules.sys.entity.Role;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.pcore.modules.sys.service.CoreService;
import com.oseasy.pcore.modules.sys.service.OfficeService;
import com.oseasy.putil.common.utils.Collections3;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 角色Controller


 */
@Controller
@RequestMapping(value = "${adminPath}/sys/role")
public class RoleController extends BaseController {

	@Autowired
	private CoreService coreService;
	@Autowired
	private SystemService systemService;
	@Autowired
	private OfficeService officeService;

	@Autowired
	private ActYwGroleService actYwGroleService;
	@ModelAttribute("role")
	public Role get(@RequestParam(required=false) String id) {
		if (StringUtil.isNotBlank(id)) {
			return systemService.getRole(id);
		}else{
			return new Role();
		}
	}

	@RequiresPermissions("sys:role:view")
	@RequestMapping(value = {"list", ""})
	public String list(Role role, Model model) {
//		List<Role> list = systemService.findAllRole();
//		model.addAttribute("list", list);
//		if(UserUtils.getUser().getAdmin() || UserUtils.getUser().getSysAdmin()){
//			model.addAttribute("admin", true);
//		}else{
//			model.addAttribute("admin", false);
//		}
		return "modules/sys/roleList";
	}

	@RequestMapping(value = "getRoleList", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public ApiResult getRoleList(Role role){
		try {
			List<Role> list = systemService.findAllRole();
			return ApiResult.success(list);
		}catch (Exception e){
			logger.error(e.getMessage());
			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
		}
	}


	@RequiresPermissions("sys:role:view")
	@RequestMapping(value = "form")
	public String form(Role role, Model model, HttpServletRequest request) {
		if (role.getOffice()==null) {
			role.setOffice(UserUtils.getUser().getOffice());
		}
		model.addAttribute("role", role);
		model.addAttribute("menuList", systemService.findAllMenu());
//		model.addAttribute("officeList", officeService.findAll());
//		String secondName=request.getParameter("secondName");
//		if(StringUtil.isNotEmpty(secondName)){
//			model.addAttribute("secondName",secondName);
//		}
		if(UserUtils.getUser().getAdmin() || UserUtils.getUser().getSysAdmin()){
			model.addAttribute("admin", true);
		}else{
			model.addAttribute("admin", false);
		}
		return "modules/sys/roleForm";
	}

	@RequiresPermissions("sys:role:edit")
	@RequestMapping(value = "save")
	public String save(Role role, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
//		if (!(UserUtils.getUser().getAdmin() || UserUtils.getUser().getSysAdmin()) && role.getSysData().equals(Global.YES)) {
//			addMessage(redirectAttributes, "越权操作，只有超级管理员才能修改此数据！");
//			return CoreSval.REDIRECT + adminPath + "/sys/role/?repage";
//		}
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return CoreSval.REDIRECT + adminPath + "/sys/role/?repage";
		}
		if (!beanValidator(model, role)) {
			return form(role, model,request);
		}
		if (!"true".equals(checkName(role.getOldName(), role.getName()))) {
			addMessage(model, "保存角色" + role.getName() + "失败, 角色名已存在");
			return form(role, model,request);
		}
		if (!"true".equals(checkEnname(role.getOldEnname(), role.getEnname()))) {
			addMessage(model, "保存角色" + role.getName() + "失败, 英文名已存在");
			return form(role, model,request);
		}
		if(StringUtil.isNotEmpty(role.getId())){
			Integer cc= coreService.getRoleUserCount(role.getId());
			if(cc!=null&&cc>0){
				Role old=systemService.getRole(role.getId());
				if(old!=null&&StringUtil.isNotEmpty(old.getBizType())&&!old.getBizType().equals(role.getBizType())){
					addMessage(redirectAttributes, "保存失败，该角色已分配用户，不能修改角色业务类型！");
					return CoreSval.REDIRECT + adminPath + "/sys/role/?repage";
				}
			}
		}
		coreService.saveRole(role);
		addMessage(redirectAttributes, "保存角色" + role.getName() + "成功");
		return CoreSval.REDIRECT + adminPath + "/sys/role/?repage";
	}


	@RequiresPermissions("sys:role:edit")
	@RequestMapping(value = "saveRole", method = RequestMethod.POST, produces = "application/json")
	@ResponseBody
	public ApiResult saveRole(@RequestBody Role role){
		try {
			if (Global.isDemoMode()) {
				return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":演示模式，不允许操作！");
			}
			if(StringUtil.isNotEmpty(role.getId())){
				Integer cc= coreService.getRoleUserCount(role.getId());
				if(cc!=null&&cc>0){
					Role old=systemService.getRole(role.getId());
					if(old!=null&&StringUtil.isNotEmpty(old.getBizType())&&!old.getBizType().equals(role.getBizType())){
						return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":保存失败，该角色已分配用户，不能修改角色业务类型！");
					}
				}
			}
			coreService.saveRole(role);
			return ApiResult.success();
		}catch (Exception e){
			logger.error(e.getMessage());
			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
		}
	}

	@RequiresPermissions("sys:role:edit")
	@RequestMapping(value = "delete")
	public String delete(Role role, RedirectAttributes redirectAttributes) {
		Integer cc= coreService.getRoleUserCount(role.getId());
		if(cc!=null&&cc>0){
			addMessage(redirectAttributes, "该角色已分配用户，不能删除！");
			return CoreSval.REDIRECT + adminPath + "/sys/role/?repage";
		}
		if (!(UserUtils.getUser().getAdmin() || UserUtils.getUser().getSysAdmin()) && role.getSysData().equals(Global.YES)) {
			addMessage(redirectAttributes, "越权操作，只有超级管理员才能修改此数据！");
			return CoreSval.REDIRECT + adminPath + "/sys/role/?repage";
		}
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return CoreSval.REDIRECT + adminPath + "/sys/role/?repage";
		}

		List<ActYwGrole> groles = actYwGroleService.checkUseByRole(Arrays.asList(new String[]{role.getId()}));
		if (((groles != null) && (groles.size() > 0))) {
		    addMessage(redirectAttributes, "当前角色被使用！使用流程为：[" + groles.get(0).getGroup().getName() + "],禁止被删除");
            logger.warn("当前角色被使用,禁止被删除,使用详情，请查看JSON:");
            logger.warn(JsonMapper.toJsonString(groles));
		    return CoreSval.REDIRECT + adminPath + "/sys/role/?repage";
		}
		coreService.deleteRole(role);
		addMessage(redirectAttributes, "删除角色成功");
		return CoreSval.REDIRECT + adminPath + "/sys/role/?repage";
	}

	@RequestMapping(value = "ajaxDelete", method = RequestMethod.POST, produces = "application/json")
	@ResponseBody
	public ApiResult ajaxDelete(@RequestBody Role role) {
		try{
			{
				Integer cc= coreService.getRoleUserCount(role.getId());
				role=systemService.getRole(role.getId());
				if(cc!=null&&cc>0){
					return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+"该角色已分配用户，不能删除！");
				}
				if (!(UserUtils.getUser().getAdmin() || UserUtils.getUser().getSysAdmin()) && role.getSysData().equals(Global.YES)) {
					return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+"越权操作，只有超级管理员才能修改此数据！");
				}
				if (Global.isDemoMode()) {
					return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+"演示模式，不允许操作");
				}
				List<ActYwGrole> groles = actYwGroleService.checkUseByRole(Arrays.asList(new String[]{role.getId()}));
				if (((groles != null) && (groles.size() > 0))) {
					return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+"当前角色被使用,禁止被删除");
				}
				coreService.deleteRole(role);
			}
			return ApiResult.success();
		}catch (Exception e){
			logger.error(e.getMessage());
			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
		}
	}


	/**
	 * 角色分配页面
	 * @param role
	 * @param model
	 * @return
	 */
	@RequiresPermissions("sys:role:edit")
	@RequestMapping(value = "assign")
	public String assign(Role role, Model model, HttpServletRequest request) {
		List<User> userList = coreService.findUser(new User(new Role(role.getId())));
		model.addAttribute("userList", userList);
		String secondName=request.getParameter("secondName");
		if(StringUtil.isNotEmpty(secondName)){
			model.addAttribute("secondName",secondName);
		}
		return "modules/sys/roleAssign";
	}

	/**
	 * 角色分配 -- 打开角色分配对话框
	 * @param role
	 * @param model
	 * @return
	 */
	@RequiresPermissions("sys:role:view")
	@RequestMapping(value = "usertorole")
	public String selectUserToRole(Role role, Model model) {
		List<User> userList = coreService.findUser(new User(new Role(role.getId())));
		model.addAttribute("role", role);
		model.addAttribute("userList", userList);
		model.addAttribute("selectIds", Collections3.extractToString(userList, "name", ","));
		model.addAttribute("officeList", officeService.findAll());
		return "modules/sys/selectUserToRole";
	}

	/**
	 * 角色分配 -- 根据部门编号获取用户列表
	 * @param officeId
	 * @param response
	 * @return
	 */
	@RequiresPermissions("sys:role:view")
	@ResponseBody
	@RequestMapping(value = "users")
	public List<Map<String, Object>> users(String officeId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		User user = new User();
		user.setOffice(new Office(officeId));
		Page<User> page = systemService.findUser(new Page<User>(1, -1), user);
		for (User e : page.getList()) {
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", e.getId());
			map.put("pId", 0);
			map.put("name", e.getName());
			mapList.add(map);
		}
		return mapList;
	}

	/**
	 * 角色分配 -- 从角色中移除用户
	 * @param userId
	 * @param roleId
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:role:edit")
	@RequestMapping(value = "outrole")
	public String outrole(String userId, String roleId, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return CoreSval.REDIRECT + adminPath + "/sys/role/assign?id="+roleId;
		}
		Role role = systemService.getRole(roleId);
		User user = systemService.getUser(userId);
		if (UserUtils.getUser().getId().equals(userId)) {
			addMessage(redirectAttributes, "无法从角色【" + role.getName() + "】中移除用户【" + user.getName() + "】自己！");
		}else {
			if (user.getRoleList().size() <= 1) {
				addMessage(redirectAttributes, "用户【" + user.getName() + "】从角色【" + role.getName() + "】中移除失败！这已经是该用户的唯一角色，不能移除。");
			}else{
				Boolean flag = systemService.outUserInRole(role, user);
				if (!flag) {
					addMessage(redirectAttributes, "用户【" + user.getName() + "】从角色【" + role.getName() + "】中移除失败！");
				}else {
					addMessage(redirectAttributes, "用户【" + user.getName() + "】从角色【" + role.getName() + "】中移除成功！");
				}
			}
		}
		return CoreSval.REDIRECT + adminPath + "/sys/role/assign?id="+role.getId();
	}

	/**
	 * 角色分配
	 * @param role
	 * @param idsArr
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:role:edit")
	@RequestMapping(value = "assignrole")
	public String assignRole(Role role, String[] idsArr, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return CoreSval.REDIRECT + adminPath + "/sys/role/assign?id="+role.getId();
		}
		StringBuilder msg = new StringBuilder();
		int newNum = 0;
		for (int i = 0; i < idsArr.length; i++) {
			User user = systemService.assignUserToRole(role, systemService.getUser(idsArr[i]));
			if (null != user) {
				msg.append("<br/>新增用户【" + user.getName() + "】到角色【" + role.getName() + "】！");
				newNum++;
			}
		}
		addMessage(redirectAttributes, "已成功分配 "+newNum+" 个用户"+msg);
		return CoreSval.REDIRECT + adminPath + "/sys/role/assign?id="+role.getId();
	}

	/**
	 * 验证角色名是否有效
	 * @param oldName
	 * @param name
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "checkName")
	public String checkName(String oldName, String name) {
		if (name!=null && name.equals(oldName)) {
			return "true";
		} else if (name!=null && systemService.getRoleByName(name) == null) {
			return "true";
		}
		return "false";
	}

	@RequestMapping(value="checkRoleName", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public Boolean checkRoleName(Role role){
		return systemService.checkRoleName(role);
	}

	@RequestMapping(value="checkRoleEnName", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public Boolean checkRoleEnName(Role role){
		return systemService.checkRoleEnName(role);
	}

	/**
	 * 验证角色英文名是否有效
	 * @param oldEnname
	 * @param enname
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "checkEnname")
	public String checkEnname(String oldEnname, String enname) {
		if (enname!=null && enname.equals(oldEnname)) {
			return "true";
		} else if (enname!=null && systemService.getRoleByEnname(enname) == null) {
			return "true";
		}
		return "false";
	}

}
