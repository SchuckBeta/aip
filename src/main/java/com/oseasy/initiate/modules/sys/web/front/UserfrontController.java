package com.oseasy.initiate.modules.sys.web.front;

import java.io.IOException;
import java.util.HashMap;
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
import com.oseasy.pcore.common.config.ApiConst;
import com.oseasy.pcore.common.config.ApiResult;
import com.oseasy.pcore.common.config.ApiTstatus;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.persistence.PageMap;
import com.oseasy.pcore.common.utils.CacheUtils;
import com.oseasy.pcore.common.utils.VsftpUtils;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.oa.entity.OaNotify;
import com.oseasy.pcore.modules.oa.service.OaNotifyService;
import com.oseasy.pcore.modules.sys.entity.Role;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.pcore.modules.sys.service.CoreService;
import com.oseasy.pcore.modules.sys.service.UserService;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.putil.common.utils.exception.ExceptionUtil;

@Controller
@RequestMapping(value = "${frontPath}/sys/user")
public class UserfrontController extends BaseController {
	@Autowired
	private SystemService systemService;
	@Autowired
	private OaNotifyService oaNotifyService;
	@Autowired
	UserService userService;
	@Autowired
	CoreService coreService;

	@ModelAttribute
	public User get(@RequestParam(required=false) String id) {
		if (StringUtil.isNotBlank(id)) {
			User user = coreService.getUser(id);
			return user;
		}else{
			return new User();
		}
	}

	@RequestMapping(value = {"index"})
	public String index(User user, Model model,HttpServletRequest request) {
		String teamId = request.getParameter("teamId");
		String opType = request.getParameter("opType");
		String userType = request.getParameter("userType");
		model.addAttribute("teamId", teamId);
		model.addAttribute("opType", opType);
		model.addAttribute("userType", userType);
		model.addAttribute("user", user);
		return "modules/sys/userIndex";

	}

	@RequestMapping(value="getUserDetail", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public ApiResult getUserDetail(User user){
		try {
			return ApiResult.success(user);
		}catch (Exception e){
			logger.error(ExceptionUtil.getStackTrace(e));
			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
		}
	}

	@RequestMapping(value = {"indexPublish"})
	public String indexPublish(User user, Model model,HttpServletRequest request) {
		String teamId = request.getParameter("teamId");
		String opType = request.getParameter("opType");
		String userType = request.getParameter("userType");
		model.addAttribute("teamId", teamId);
		model.addAttribute("opType", opType);
		model.addAttribute("userType", userType);
		return "modules/sys/userIndexPublish";

	}

	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String officeId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<User> list = coreService.findUserByOfficeId(officeId);
		for (int i=0; i<list.size(); i++) {
			User e = list.get(i);
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", "u_"+e.getId());
			map.put("pId", officeId);
			map.put("name", StringUtil.replace(e.getName(), " ", ""));
			mapList.add(map);
		}
		return mapList;
	}

	@RequestMapping("userListTree")
	public String userListTree(User user, String grade, String professionId,String allTeacher,HttpServletRequest request, HttpServletResponse response, Model model) {
		String userType = request.getParameter("userType");
		String teacherType = request.getParameter("teacherType");
		String userName = request.getParameter("userName");
		if (StringUtil.isNotBlank(userName)) {
			user.setName(userName);
			model.addAttribute("userName", userName);
		}
		if (StringUtil.isNotBlank(teacherType)) {
			user.setTeacherType(teacherType);
			model.addAttribute("teacherType", teacherType);
		}
		if ("1".equals(allTeacher)) {
			user.setTeacherType(null);
		}
		if (StringUtil.isNotBlank(grade) && "3".equals(grade)) {
			user.setProfessional(professionId);
		}

    Page<User> page = null;
    if (StringUtil.isNotEmpty(userType)) {
      user.setUserType(userType);

      if ((userType).equals("1")) {
        page = systemService.findListTreeByStudent(new Page<User>(request, response), user);
      }else if ((userType).equals("2")) {
        page = systemService.findListTreeByTeacher(new Page<User>(request, response), user);
      }else{
        page = systemService.findListTreeByUser(new Page<User>(request, response), user);
      }
    }

		model.addAttribute("page", page);
		model.addAttribute("userType", userType);
		return "modules/sys/userListTree";
	}


    //查询学校成员列表 by 王清腾
    @RequestMapping(value = "/ajaxUserListTree", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    @ResponseBody
    public ApiTstatus<HashMap<String, Object>> ajaxUserListTree(User user, HttpServletRequest request, HttpServletResponse response) {
        ApiTstatus<HashMap<String, Object>> actYwApiStatus = new ApiTstatus<HashMap<String, Object>>(false, "查询失败");
        String userName = request.getParameter("userName");
        String teacherType = request.getParameter("teacherType");
        String userType = request.getParameter("userType");
        String allTeacher = request.getParameter("allTeacher");
        String grade = request.getParameter("grade");
        String professionId = request.getParameter("professionId");
        HashMap<String, Object> userListTreeMap = new HashMap<String, Object>();

        if (StringUtil.isNotBlank(userName)) {
            user.setName(userName);
        }

        if (StringUtil.isNotBlank(teacherType)) {
            user.setTeacherType(teacherType);
        }

        if ("1".equals(allTeacher)) {
            user.setTeacherType(null);
        }
        if (StringUtil.isNotBlank(grade) && "3".equals(grade)) {
            user.setProfessional(professionId);
        }

        userListTreeMap.put("userName", userName);
        userListTreeMap.put("teacherType", teacherType);

        if (StringUtil.isNotEmpty(userType)) {
            Page<User> page = null;
            user.setUserType(userType);
            switch ((userType)) {
                case "1":
                    page = systemService.findListTreeByStudent(new Page<User>(request, response), user);
                    break;
                case "2":
                    page = systemService.findListTreeByTeacher(new Page<User>(request, response), user);
                    break;
                default:
                    page = systemService.findListTreeByUser(new Page<User>(request, response), user);
                    break;
            }
            Map<String, Object> membersMap = new PageMap().getPageMap(page);
            userListTreeMap.putAll(membersMap);
            actYwApiStatus.setMsg("查询成功");
            actYwApiStatus.setStatus(true);
            actYwApiStatus.setDatas(userListTreeMap);
            return actYwApiStatus;
        }
        return actYwApiStatus;
    }


    @RequestMapping("userListTreePublish")
    public String userListTreePublish(User user, HttpServletRequest request, HttpServletResponse response, Model model) {
        String userType = request.getParameter("userType");
        Page<User> page = null;
        if (StringUtil.isNotEmpty(userType)) {
            user.setUserType(userType);
            if ((userType).equals("1")) {
                page = systemService.findListTreeByStudent(new Page<User>(request, response), user);
            } else if ((userType).equals("2")) {
                page = systemService.findListTreeByTeacher(new Page<User>(request, response), user);
            } else {
                page = systemService.findListTreeByUser(new Page<User>(request, response), user);
            }
        }

		if (page!=null) {
			List<User> userList = page.getList();
			if (userList!=null&&userList.size()>0) {
				for(User usertmp:userList) {
					List<Role> roleList = coreService.findListByUserId(usertmp.getId());
					usertmp.setRoleList(roleList);
				}
			}
		}

		List<Role>  roleList = systemService.findAllRole();

		model.addAttribute("roleList",roleList);

		model.addAttribute("page", page);
		model.addAttribute("userType", userType);
		//	return "modules/sys/userList";
		return "modules/sys/userListTreePublish";
	}


	@RequestMapping(value = "delete")
	public String delete(OaNotify oaNotify, RedirectAttributes redirectAttributes) {
		oaNotifyService.delete(oaNotify);
		addMessage(redirectAttributes, "删除发送通知成功");
		return CoreSval.REDIRECT + frontPath + "/sys/user/indexMySendNoticeList/?repage";
	}

	@ResponseBody
	@RequestMapping(value = "isExistMobile")
	public String isExistMobile(String mobile) {
		if (StringUtil.isNotEmpty(mobile) && UserUtils.isExistMobile(mobile)) {
			return "true";
		}
		return "false";
	}

	@ResponseBody
	@RequestMapping(value = "checkMobile")
	public String checkMobile(@RequestParam(value="user.mobile")String mobile,@RequestParam(value="id")String id) {
		if (mobile !=null && coreService.getUserByMobile(mobile,id) == null) {
			return "true";
		}
		return "false";
	}
	/**
	 * 检查loginName 登录名不能与其他人的登录名相同，不能与其他人的no相同
	 * @param userid
	 * @param loginName
	 * @return
	 */
	@RequestMapping(value = "checkLoginName")
	@ResponseBody
	public String checkLoginName(String loginName,String userid) {
		if (userService.getByLoginNameOrNo(loginName, userid)== null) {
			return "true";
		}
		return "false";
	}


	/**
	 * 检查学号，学号不能与其他人的学号相同，不能与其他人的loginName相同
	 * @param userid
	 * @param no
	 * @return
	 */
	@RequestMapping(value = "checkNo")
	@ResponseBody
	public String checkNo(String no,String userid) {
		if (userService.getByLoginNameOrNo(no, userid)== null) {
			return "true";
		}
		return "false";
	}

	/**
	 * addby zhangzheng 检查输入的手机号是否已经注册过
	 * @param mobile
	 * @return true:没注册，允许修改
	 */
	@RequestMapping("checkMobileExist")
	@ResponseBody
	public Boolean checkMobileExist(String mobile) {
		User userForSearch=new User();
		userForSearch.setMobile(mobile);
		User cuser=UserUtils.getUser();
		if (cuser==null||StringUtil.isEmpty(cuser.getId())) {
			return false;
		}
		userForSearch.setId(cuser.getId());
		User user = userService.getByMobileWithId(userForSearch);
		if (user==null) {
			return true;
		}else{
			return false;
		}

	}


//	@ResponseBody
//	@RequestMapping(value = "ifTeamNameExist")
//	public String ifTeamNameExist(String name,String teamId) {
//		logger.info("name:"+name);
//		logger.info("teamId:"+teamId);
//		List<Team> teamList  = teamService.selectTeamByName(name);
//		if (teamList !=null && teamList.size()>0) {
//			if (StringUtil.isNotBlank(teamId)) {
//				if (teamId.equals(teamList.get(0).getId())) {
//					return  "true";
//				}
//			}
//			return "false";
//		}
//		return "true";
//	}

	@ResponseBody
	@RequestMapping(value="uploadPhoto")
	public boolean uploadFTP(HttpServletRequest request,User user) {
		String arrUrl = request.getParameter("arrUrl");
		if (user!=null) {
			user.setPhoto(arrUrl);
			userService.updateUser(user);
		}
		return true;
	}
	@ResponseBody
	@RequestMapping(value="checkUserInfoPerfect")
	public boolean checkUserInfoPerfect() {
		if (UserUtils.checkInfoPerfect(UserUtils.getUser())) {
			return true;
		}else{
			return false;
		}
	}

	//修改头像信息
    @ResponseBody
    @RequestMapping(value = "/ajaxUpdatePhoto", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    public ApiTstatus<User> ajaxUpdatePhoto(@RequestParam(required = false) String userId, @RequestParam(required = true) String photo) {
        if(StringUtil.isEmpty(userId)){
            userId = UserUtils.getUser().getId();
        }
        if(StringUtil.isEmpty(photo)){
            userId = UserUtils.getUser().getId();
        }
        User user = userService.findUserById(userId);

		//替换头像地址
		if(StringUtil.isNotEmpty(photo)){
			String newUrl= null;
			try {
				newUrl = VsftpUtils.moveFile(photo);
			} catch (IOException e) {
				logger.error(e.toString());
			}
			if(StringUtil.isNotEmpty(newUrl)){
				user.setPhoto(newUrl);
			}
		}

        //user.setPhoto(photo);
        userService.updateUser(user);

        if (user!=null) {
            CacheUtils.remove(CoreUtils.USER_CACHE, CoreUtils.USER_CACHE_ID_ + user.getId());
            CacheUtils.remove(CoreUtils.USER_CACHE, CoreUtils.USER_CACHE_LOGIN_NAME_ + user.getLoginName());
        }
        return new ApiTstatus<User>(true, "修改头像成功", user);
    }

	@RequestMapping(value="checkUserNoUnique", method = RequestMethod.POST, produces = "application/json")
	@ResponseBody
	public Boolean checkUserNoUnique(@RequestBody User user){
		return userService.checkUserNoUnique(user);
	}
}
