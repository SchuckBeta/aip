package com.oseasy.pact.modules.actyw.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oseasy.initiate.modules.sys.utils.UserUtils;
import com.oseasy.pact.modules.actyw.entity.ActYwGassign;
import com.oseasy.pact.modules.actyw.entity.ActYwGnode;
import com.oseasy.pact.modules.actyw.entity.ActYwGrole;
import com.oseasy.pact.modules.actyw.entity.ActYwGroup;
import com.oseasy.pact.modules.actyw.service.ActYwGassignService;
import com.oseasy.pact.modules.actyw.service.ActYwGnodeService;
import com.oseasy.pact.modules.actyw.service.ActYwGroleService;
import com.oseasy.pcore.common.config.CoreIds;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.Office;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.pcore.modules.sys.service.UserService;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 业务指派表Controller.
 * @author zy
 * @version 2018-04-03
 */
@Controller
@RequestMapping(value = "${adminPath}/actyw/actYwGassign")
public class ActYwGassignController extends BaseController {

	@Autowired
	private ActYwGassignService actYwGassignService;
	@Autowired
	private ActYwGnodeService actYwGnodeService;
	@Autowired
	private ActYwGroleService actYwGroleService;
	@Autowired
	private UserService userService;

	@ModelAttribute
	public ActYwGassign get(@RequestParam(required=false) String id) {
		ActYwGassign entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = actYwGassignService.get(id);
		}
		if (entity == null){
			entity = new ActYwGassign();
		}
		return entity;
	}

	@RequestMapping(value = {"list", ""})
	public String list(ActYwGassign actYwGassign, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ActYwGassign> page = actYwGassignService.findPage(new Page<ActYwGassign>(request, response), actYwGassign);
		model.addAttribute("page", page);
		return "modules/actyw/actYwGassignList";
	}

	@RequestMapping(value = "form")
	public String form(ActYwGassign actYwGassign, Model model) {
		model.addAttribute("actYwGassign", actYwGassign);
		return "modules/actyw/actYwGassignForm";
	}

	@RequestMapping(value = "toGassignView")
	public String toGassignView(ActYwGassign actYwGassign, HttpServletRequest request, Model model) {
		String promodelIds=request.getParameter("promodelIds");
		String ywId=request.getParameter(ActYwGroup.JK_ACTYW_ID);
		String gnodeId=request.getParameter(ActYwGroup.JK_GNODE_ID);
		String secondName=request.getParameter("secondName");
		if(StringUtil.isNotEmpty(secondName)){
			model.addAttribute("secondName", secondName);
		}
		ActYwGnode actYwGnode=actYwGnodeService.getByg(gnodeId);
		model.addAttribute("actYwGnode", actYwGnode);
		List<ActYwGrole> roles=actYwGnode.getGroles();
//		JSONObject userJs=userService.findUserJsByRoles(roles);
//		Role role=actYwGnode.getGroles().get(0).getRole();
//		List<User> userList =userService.findListByRoleName(role.getEnname());

		List<Map<String,String>> userLists =actYwGroleService.findListByRoleNames(roles);
		model.addAttribute("promodelIds", promodelIds);
		model.addAttribute("gnodeId", gnodeId);
		model.addAttribute("ywId", ywId);
		model.addAttribute("userList", userLists);
		model.addAttribute("actYwGassign", actYwGassign);
		model.addAttribute("promodelNum", promodelIds.split(",").length);

		return "modules/actyw/actYwGassignUser";
	}

	@RequestMapping(value = "save")
	public String save(ActYwGassign actYwGassign, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, actYwGassign)){
			return form(actYwGassign, model);
		}
		actYwGassignService.save(actYwGassign);
		addMessage(redirectAttributes, "保存业务指派表成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwGassign/?repage";
	}

	@RequestMapping(value = "delete")
	public String delete(ActYwGassign actYwGassign, RedirectAttributes redirectAttributes) {
		actYwGassignService.delete(actYwGassign);
		addMessage(redirectAttributes, "删除业务指派表成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwGassign/?repage";
	}

	@RequestMapping(value = "ajaxGetToDoNumByUser")
	@ResponseBody
	public List<Map<String ,String>> ajaxGetToDoNumByUser(String userIds,String gnodeId) {
		List<String> userIdList= Arrays.asList(userIds.split(","));
		List<Map<String ,String>> listMap=new ArrayList<Map<String ,String>>();
		for(String userId: userIdList){
			Map<String ,String> map=new HashMap<String ,String>();
			String num=actYwGassignService.getToDoNumByUserId(userId,gnodeId);
			User user=UserUtils.get(userId);

			String name= user.getName();
			map.put("userId",userId);
			//map.put("userId",user.getr);
			if(user.getOffice()!=null&& StringUtil.isNotEmpty(user.getOffice().getName())){
				String officeName=user.getOffice().getName();
				map.put("officeName",officeName);
			}else{
				Office office=CoreUtils.getOffice(CoreIds.SYS_OFFICE_TOP.getId());
				map.put("officeName",office.getName());
			}

			map.put("name",name);
			map.put("num",num);
			listMap.add(map);
		}
		return listMap;
	}

	@RequestMapping(value = "saveAssign")
	public String saveAssign(ActYwGassign actYwGassign, Model model,HttpServletRequest request, RedirectAttributes redirectAttributes) {

		//指派的项目id
		String promodelIds=request.getParameter("promodelIds");
		//指派的人员id
		String userIds=request.getParameter("userIds");
		actYwGassignService.saveAssign(actYwGassign,promodelIds,userIds);
		addMessage(redirectAttributes, "指派完成");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/form/taskAssignList/?actywId="+actYwGassign.getYwId();
	}

}