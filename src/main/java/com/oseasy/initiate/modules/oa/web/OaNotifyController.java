/**
 *
 */
package com.oseasy.initiate.modules.oa.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

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
import com.oseasy.initiate.modules.oa.entity.OaNotify;
import com.oseasy.initiate.modules.oa.entity.OaNotifyRecord;
import com.oseasy.initiate.modules.oa.entity.OaNotifySent;
import com.oseasy.initiate.modules.oa.service.OaNotifyKeywordService;
import com.oseasy.initiate.modules.oa.service.OaNotifyService;
import com.oseasy.initiate.modules.oa.vo.OaNotifySendType;
import com.oseasy.initiate.modules.sys.utils.UserUtils;
import com.oseasy.pact.modules.actyw.service.ActYwService;
import com.oseasy.pcore.common.config.ApiConst;
import com.oseasy.pcore.common.config.ApiResult;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.utils.FtpUtil;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.putil.common.utils.StringUtil;

import net.sf.json.JSONObject;

/**
 * 通知通告Controller
TODO
 * @version 2014-05-16
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaNotify")
public class OaNotifyController extends BaseController {
	@Autowired
	private OaNotifyKeywordService oaNotifyKeywordService;
	@Autowired
	private OaNotifyService oaNotifyService;
	@Autowired
	ActYwService actYwService;

	@ModelAttribute
	public OaNotify get(@RequestParam(required=false) String id) {
		OaNotify entity = null;
		if (StringUtil.isNotBlank(id)) {
			entity = oaNotifyService.get(id);
		}
		if (entity == null) {
			entity = new OaNotify();
		}
		return entity;
	}
	/**
	 * 查看我的通知
	 */
	@RequestMapping(value = "viewMsg")
	@ResponseBody
	public OaNotify viewMsg(String oaNotifyId, Model model) {
		OaNotify oaNotify = new OaNotify();
		oaNotify.setId(oaNotifyId);
		oaNotifyService.updateReadFlag(oaNotify);
		oaNotify = oaNotifyService.get(oaNotify.getId());
		if (oaNotify == null) {
		  return null;
		}
		OaNotify  oaNotifyTmp = oaNotifyService.getRecordList(oaNotify);
		if (oaNotifyTmp == null) {
      		return null;
    	}
		if ((oaNotify == null) || (oaNotifyTmp == null)) {
		  return oaNotify;
		}
		oaNotify.setOaNotifyRecordList(oaNotifyTmp.getOaNotifyRecordList());
		SimpleDateFormat sFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		if (oaNotify.getEffectiveDate()!=null) {
			String effDate = sFormat.format(oaNotify.getEffectiveDate());
			oaNotify.setPublishDate(effDate);
		}
		if (oaNotify.getContent()!=null) {
			oaNotify.setContent(StringUtil.replaceEscapeHtml(oaNotify.getContent()));
		}
		if (oaNotify!=null&&StringUtil.isNotEmpty(oaNotify.getContent())) {
			oaNotify.setContent(oaNotify.getContent().replaceAll(FtpUtil.FTP_MARKER,FtpUtil.FTP_HTTPURL));
		}
		return oaNotify;
	}
	@RequestMapping(value = "sendTestMsg")
	@ResponseBody
	public JSONObject sendTestMsg(String uid) {
		JSONObject js=new JSONObject();
		try {
			OaNotify on=new OaNotify();
			on.setContent("这是一条测试消息内容");
			on.setTitle("这是一条测试消息标题");
			on.setSendType(OaNotifySendType.DIRECRIONAL.getVal());
			on.setStatus("1");
			on.setEffectiveDate(new Date());
			on.setType(OaNotify.Type_Enum.TYPE1.getValue());
			on.setOaNotifyRecordIds(uid);
			oaNotifyService.save(on);
			js.put("ret", "1");
			js.put("msg", "发送成功");
		} catch (Exception e) {
			logger.error(e.getMessage());
			js.put("ret", "0");
			js.put("msg", "发送失败");
		}
		return js;
	}
	@RequestMapping(value = {"getUnreadCount"})
	@ResponseBody
	public JSONObject getUnreadCount() {
		String uid=UserUtils.getUser().getId();
		JSONObject js=new JSONObject();
		js.put("ret", "1");
		if (StringUtil.isEmpty(uid)) {
			js.put("ret", "0");
			js.put("count", 0);
			return js;
		}
//		Integer c=oaNotifyService.getUnreadCount(uid);
		Integer c=oaNotifyService.getUnreadCountByUser(UserUtils.getUser());
		if (c==null) {
			c=0;
		}
		js.put("count",c);
		return js;
	}
	@RequestMapping(value = "deleteRec")
	public String deleteRec(OaNotify oaNotify, RedirectAttributes redirectAttributes) {
		oaNotifyService.deleteRec(oaNotify);
		addMessage(redirectAttributes, "删除成功");
		return CoreSval.REDIRECT + Global.getAdminPath() + "/oa/oaNotify/msgRecList/?repage";
	}


	@RequestMapping(value = "deleteSend")
	public String deleteSend(OaNotify oaNotify, RedirectAttributes redirectAttributes) {
		oaNotifyService.deleteSend(oaNotify);
		addMessage(redirectAttributes, "删除成功");
		return CoreSval.REDIRECT + Global.getAdminPath() + "/oa/oaNotify/msgSendList/?repage";
	}

	/**
	 * 批量删除接收消息
	 * @param ids OaNotify的ids，以逗号分隔
	 */
	@RequestMapping(value = "deleteRevBatch")
	@ResponseBody
	public boolean deleteRevBatch(String ids) {
		String[] idStr=ids.split(",");
		for (int i=0;i<idStr.length;i++) {
			OaNotify oaNotify=new OaNotify();
			oaNotify.setId(idStr[i]);
			oaNotifyService.deleteRec(oaNotify);
		}
		return true;
	}

	/**
	 * 批量删除发送消息
	 * @param ids OaNotify的ids，以逗号分隔
	 */
	@RequestMapping(value = "deleteSendBatch")
	@ResponseBody
	public boolean deleteSendBatch(String ids) {
		String[] idStr=ids.split(",");
		for (int i=0;i<idStr.length;i++) {
			OaNotify oaNotify=new OaNotify();
			oaNotify.setId(idStr[i]);
			oaNotifyService.deleteSend(oaNotify);
		}
		return true;
	}

	@RequestMapping(value = "getReadFlag")
	@ResponseBody
	public String getReadFlag(String oaNotifyId) {
		String flag="0";
		User u =UserUtils.getUser();
        if (u != null) {
            return oaNotifyService.getReadFlag(oaNotifyId, u);
		}
		return flag;
	}

	@RequestMapping(value = {"msgRecList"})
	public String msgRecList(OaNotify oaNotify, HttpServletRequest request, HttpServletResponse response, Model model) {
		User currUser = UserUtils.getUser();
		if (currUser!=null&&currUser.getId()!=null) {
			oaNotify.setUserId(String.valueOf(currUser.getId()));
		}else{
			oaNotify.setType("error");
		}

		oaNotify.setIsSelf(true);
		Page<OaNotify> page = oaNotifyService.find(new Page<OaNotify>(request, response), oaNotify);
		model.addAttribute("page", page);
		return "modules/oa/adminMsgRec";
	}
	@RequestMapping(value = {"msgSendList"})
	public String msgSendList(OaNotify oaNotify, HttpServletRequest request, HttpServletResponse response, Model model) {
		User currUser = UserUtils.getUser();
		if (currUser!=null&&currUser.getId()!=null) {
			oaNotify.setUserId(String.valueOf(currUser.getId()));
		}else{
			oaNotify.setType("error");
		}

		Page<OaNotify> page = oaNotifyService.findSend(new Page<OaNotify>(request, response), oaNotify);
		model.addAttribute("page", page);
		return "modules/oa/adminMsgSend";
	}
	@RequiresPermissions("oa:oaNotify:view")
	@RequestMapping(value = {"list", ""})
	public String list(OaNotify oaNotify, HttpServletRequest request, HttpServletResponse response, Model model) {
		User currUser = UserUtils.getUser();
		//logger.info("curre========="+currUser.getId());
		if (currUser!=null&&currUser.getId()!=null&&!"1".equals(currUser.getId())) {
			oaNotify.setUserId(String.valueOf(currUser.getId()));
		}
		oaNotify.setIsSelf(true);
		Page<OaNotify> page = oaNotifyService.find(new Page<OaNotify>(request, response), oaNotify);
		model.addAttribute("page", page);
		return "modules/oa/oaNotifyList";
	}



	@RequiresPermissions("oa:oaNotify:view")
	@RequestMapping(value = {"broadcastList"})
	public String broadcastList(OaNotify oaNotify, HttpServletRequest request, HttpServletResponse response, Model model) {
//		oaNotify.setSendType(OaNotifySendType.DIS_DIRECRIONAL.getVal());
//		Page<OaNotify> page = oaNotifyService.find(new Page<OaNotify>(request, response), oaNotify);
//		model.addAttribute("page", page);
		return "modules/oa/oaNotifyListBroadcast";
	}

	@RequestMapping(value="getOaNotifyList", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public ApiResult getOaNotifyList(OaNotify oaNotify, HttpServletRequest request, HttpServletResponse response, Model model){
		try {
			oaNotify.setSendType(OaNotifySendType.DIS_DIRECRIONAL.getVal());
			Page<OaNotify> page = oaNotifyService.find(new Page<OaNotify>(request, response), oaNotify);
			List<OaNotify> oaNotifies = page.getList();
			for(OaNotify oaNotifyItem: oaNotifies){
				User user = UserUtils.get(oaNotifyItem.getCreateBy().getId());
				oaNotifyItem.setCreateUser(user);
			}
			page.setList(oaNotifies);
			return  ApiResult.success(page);
		}catch (Exception e){
			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
		}
	}


	@RequiresPermissions("oa:oaNotify:view")
	@RequestMapping(value = {"assignList"})
	public String assignList(OaNotify oaNotify, HttpServletRequest request, HttpServletResponse response, Model model) {
		oaNotify.setSendType(OaNotifySendType.DIRECRIONAL.getVal());
		Page<OaNotify> page = oaNotifyService.find(new Page<OaNotify>(request, response), oaNotify);
		model.addAttribute("page", page);
		return "modules/oa/oaNotifyListAssign";
	}

	@RequiresPermissions("oa:oaNotify:view")
	@RequestMapping(value = "form")
	public String form(OaNotify oaNotify, Model model) {
//		if (StringUtil.isNotBlank(oaNotify.getId())) {
//			oaNotify = oaNotifyService.getRecordList(oaNotify);
//		}
//		model.addAttribute("oaNotify", oaNotify);
//		if ("1".equals(oaNotify.getType())) {  //团建通知
//			String teamId=oaNotify.getContent();
//			Team team=teamService.get(teamId);
//			model.addAttribute("team", team);
//			return "modules/oa/oaNotifyTeam";
//		}

		return "modules/oa/oaNotifyForm";
	}

	@RequiresPermissions("oa:oaNotify:view")
	@RequestMapping(value = "formAssign")
	public String formAssign(OaNotify oaNotify, Model model) {
		if (StringUtil.isNotBlank(oaNotify.getId())) {
			oaNotify = oaNotifyService.getRecordList(oaNotify);
		}
		model.addAttribute("oaNotify", oaNotify);
		/*if ("1".equals(oaNotify.getType())) {  //团建通知
			String teamId=oaNotify.getContent();
			Team team=teamService.get(teamId);
			model.addAttribute("team", team);
			return "modules/oa/oaNotifyTeamAssign";
		}*/
		return "modules/oa/oaNotifyFormAssign";
	}

	@RequiresPermissions("oa:oaNotify:view")
	@RequestMapping(value = "formBroadcast")
	public String formBroadcast(OaNotify oaNotify, Model model,HttpServletRequest request) {
		if (StringUtil.isNotBlank(oaNotify.getId())) {
			oaNotify = oaNotifyService.getRecordList(oaNotify);
		}

		if (StringUtil.isNotBlank(oaNotify.getId())) {
			oaNotify=oaNotifyService.getRecordList(oaNotify);
			List<String> officeIdList= Lists.newArrayList();
			List<String> officeNameList = Lists.newArrayList();
			for(OaNotifyRecord onr:oaNotify.getOaNotifyRecordList()) {
				if (!officeIdList.contains(onr.getUser().getOffice().getId())) {
					officeIdList.add(onr.getUser().getOffice().getId());
				}
				if (!officeNameList.contains(onr.getUser().getOffice().getName())) {
					officeNameList.add(onr.getUser().getOffice().getName());
				}
			}
			model.addAttribute("officeIdList", StringUtil.join(officeIdList, ","));
			model.addAttribute("officeNameList",  StringUtil.join(officeNameList, ","));
		}

		model.addAttribute("oaNotify", oaNotify);
//		if (oaNotify!=null) {
//			if (oaNotify.getStatus()!=null&&oaNotify.getStatus().equals("1")) {
//				return "modules/oa/oaNotifyFormBroadcastDetail";
//			}
//		}

		return "modules/oa/oaNotifyFormBroadcast";
	}


	@RequiresPermissions("oa:oaNotify:edit")
	@RequestMapping(value = "saveBroadcast")
	public String saveBroadcast(OaNotify oaNotify, Model model, RedirectAttributes redirectAttributes,HttpServletRequest request) {

		String sId = oaNotify.getsId();
		String protype =  oaNotify.getProtype();

		if ("1".equals(oaNotify.getSendType())) {//通知公告
			oaNotify.setType("3");
		}
		//如果是定向发送，则跳转到定向发送的保存方法
		if ("2".equals(oaNotify.getSendType())) {
			String returnStr = saveAssignBySendType(oaNotify,model,redirectAttributes);
			return returnStr;
		}


		oaNotifyService.saveCollegeBroadcast(oaNotify);
		addMessage(redirectAttributes, "保存通知'" + oaNotify.getTitle() + "'成功");

		if (StringUtil.isNoneBlank(sId)) {
//			if ("'1'".equals(protype)) {
//				ProjectAnnounce projectAnnounce = new ProjectAnnounce();
//				projectAnnounce = projectAnnounceService.get(sId);
//				projectAnnounce.setProjectState("1");
//				projectAnnounceService.save(projectAnnounce);
//				return CoreSval.REDIRECT + Global.getAdminPath() + "/project/projectAnnounce?repage";
//			}else if ("3".equals(protype)) {  //actYw
//				ActYw actYw = actYwService.get(sId);
//				actYw.setStatus("1");
//				actYwService.save(actYw);
//				return CoreSval.REDIRECT + Global.getAdminPath() + "/actyw/actYw?repage";
//			} else{
//				return CoreSval.REDIRECT + Global.getAdminPath() + "/gcontest/gContestAnnounce?repage";
//			}
		}
		return CoreSval.REDIRECT + Global.getAdminPath() + "/oa/oaNotify/broadcastList?repage";
	}


	public String saveAssignBySendType(OaNotify oaNotify, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaNotify)) {
			return form(oaNotify, model);
		}
		if (StringUtil.isNoneBlank(oaNotify.getsId())) {
			oaNotifyService.saveCollegeBroadcast(oaNotify);
			addMessage(redirectAttributes, "保存通知'" + oaNotify.getTitle() + "'成功");
			if ("'1'".equals(oaNotify.getProtype())) {
				return CoreSval.REDIRECT + Global.getAdminPath() + "/project/projectAnnounce?repage";
			}else{
				return CoreSval.REDIRECT + Global.getAdminPath() + "/gcontest/gContestAnnounce?repage";
			}
		}
		// 如果是修改，则状态为已发布，则不能再进行操作
		if (StringUtil.isNotBlank(oaNotify.getId())) {
			OaNotify e = oaNotifyService.get(oaNotify.getId());
			if ("1".equals(e.getStatus())) {
				addMessage(redirectAttributes, "已发布，不能操作！");
				return CoreSval.REDIRECT + Global.getAdminPath() + "/oa/oaNotify/formBroadcast?id="+oaNotify.getId();
			}
		}
		oaNotify.setSendType(OaNotifySendType.DIRECRIONAL.getVal());//定向的发送类型定为2
		oaNotifyService.saveCollege(oaNotify);
		addMessage(redirectAttributes, "保存通知'" + oaNotify.getTitle() + "'成功");
		return CoreSval.REDIRECT + Global.getAdminPath() + "/oa/oaNotify/broadcastList?repage";
	}



	@RequiresPermissions("oa:oaNotify:edit")
	@RequestMapping(value = "saveAssign")
	public String saveAssign(OaNotify oaNotify, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaNotify)) {
			return form(oaNotify, model);
		}
		// 如果是修改，则状态为已发布，则不能再进行操作
		if (StringUtil.isNotBlank(oaNotify.getId())) {
			OaNotify e = oaNotifyService.get(oaNotify.getId());
			if ("1".equals(e.getStatus())) {
				addMessage(redirectAttributes, "已发布，不能操作！");
				return CoreSval.REDIRECT + Global.getAdminPath() + "/oa/oaNotify/formAssign?id="+oaNotify.getId();
			}
		}
		oaNotify.setSendType(OaNotifySendType.DIRECRIONAL.getVal());//定向的发送类型定为2
		oaNotifyService.save(oaNotify);
		addMessage(redirectAttributes, "保存通知'" + oaNotify.getTitle() + "'成功");
		return CoreSval.REDIRECT + Global.getAdminPath() + "/oa/oaNotify/assignList?repage";
	}


	@RequiresPermissions("oa:oaNotify:edit")
	@RequestMapping(value = "save")
	public String save(OaNotify oaNotify, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaNotify)) {
			return form(oaNotify, model);
		}
		// 如果是修改，则状态为已发布，则不能再进行操作
		if (StringUtil.isNotBlank(oaNotify.getId())) {
			OaNotify e = oaNotifyService.get(oaNotify.getId());
			if ("1".equals(e.getStatus())) {
				addMessage(redirectAttributes, "已发布，不能操作！");
				return CoreSval.REDIRECT + Global.getAdminPath() + "/oa/oaNotify/form?id="+oaNotify.getId();
			}
		}
		oaNotifyService.save(oaNotify);
		addMessage(redirectAttributes, "保存通知'" + oaNotify.getTitle() + "'成功");
		return CoreSval.REDIRECT + Global.getAdminPath() + "/oa/oaNotify/?repage";
	}

    /**
     * 发布.
     * @param actYw              实体
     * @param model              模型
     * @param request            请求
     * @param redirectAttributes 重定向
     * @return String
     */
    @RequiresPermissions("oa:oaNotify:edit")
    @RequestMapping(value = "ajaxDeploy")
    public String ajaxDeploy(OaNotify oaNotify, Model model, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        if (StringUtil.isNotEmpty(oaNotify.getId()) && (oaNotify.getStatus() != null)) {
            OaNotify curOaNotify = oaNotifyService.get(oaNotify.getId());
            curOaNotify.setStatus(oaNotify.getStatus());
            oaNotifyService.save(curOaNotify);
            addMessage(redirectAttributes, "通知'" + oaNotify.getTitle() + "'更新成功");
        }else{
            addMessage(redirectAttributes, "通知更新失败");
        }
        return CoreSval.REDIRECT + Global.getAdminPath() + "/oa/oaNotify/broadcastList?repage";
    }


	@RequestMapping(value="updatePublish", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public ApiResult updatePublish(OaNotify oaNotify, HttpServletRequest request, HttpServletResponse response, Model model){
		try {
			if (StringUtil.isNotEmpty(oaNotify.getId()) && (oaNotify.getStatus() != null)) {
				OaNotify curOaNotify = oaNotifyService.get(oaNotify.getId());
				curOaNotify.setStatus(oaNotify.getStatus());
				oaNotifyService.save(curOaNotify);
				return ApiResult.success();
			}else {
				return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":通知更新失败");
			}
		}catch (Exception e){
			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
		}
	}

	@RequiresPermissions("oa:oaNotify:edit")
	@RequestMapping(value = "delete")
	public String delete(OaNotify oaNotify, RedirectAttributes redirectAttributes) {
		oaNotifyService.delete(oaNotify);
		addMessage(redirectAttributes, "删除通告成功");
		return CoreSval.REDIRECT + Global.getAdminPath() + "/oa/oaNotify/broadcastList?repage";
	}

	@RequestMapping(value="delOaNotify", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public ApiResult delOaNotify(OaNotify oaNotify, HttpServletRequest request, HttpServletResponse response, Model model){
		try {
			oaNotifyService.delete(oaNotify);
			return ApiResult.success();
		}catch (Exception e){
			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
		}
	}

	/**
	 * 我的通知列表
	 */
	@RequestMapping(value = "self")
	public String selfList(OaNotify oaNotify, HttpServletRequest request, HttpServletResponse response, Model model) {
		oaNotify.setIsSelf(true);
//		Page<OaNotify> page = oaNotifyService.find(new Page<OaNotify>(request, response), oaNotify);
		Page<OaNotify> page = oaNotifyService.findAllRecord(new Page<OaNotify>(request, response), oaNotify);
		model.addAttribute("page", page);
		return "modules/oa/oaNotifyList";
	}



	/**
	 * 我的通知列表-数据
	 */
	@RequiresPermissions("oa:oaNotify:view")
	@RequestMapping(value = "selfData")
	@ResponseBody
	public Page<OaNotify> listData(OaNotify oaNotify, HttpServletRequest request, HttpServletResponse response, Model model) {
		oaNotify.setIsSelf(true);
		Page<OaNotify> page = oaNotifyService.find(new Page<OaNotify>(request, response), oaNotify);
		return page;
	}

	/**
	 * 查看我的通知
	 */
	@RequestMapping(value = "view")
	public String view(OaNotify oaNotify, Model model) {
		if (StringUtil.isNotBlank(oaNotify.getId())) {
			oaNotifyService.updateReadFlag(oaNotify);
//			oaNotify = oaNotifyService.getRecordList(oaNotify);
			oaNotify = oaNotifyService.getRecordListByUser(oaNotify);
			if (oaNotify!=null&&StringUtil.isNotEmpty(oaNotify.getContent())) {
				oaNotify.setContent(oaNotify.getContent().replaceAll(FtpUtil.FTP_MARKER,FtpUtil.FTP_HTTPURL));
			}
			model.addAttribute("oaNotify", oaNotify);
			/*if ("1".equals(oaNotify.getType())) {  //团建通知
				//根据team 查询团建信息
				String teamId=oaNotify.getContent();
				Team team=teamService.get(teamId);
				model.addAttribute("team", team);

//				OaNotifyRecord oaNotifyRecord=



//				//根据 teamId、userId 查询team_user_relation的状态
//				TeamUserRelation tu=new TeamUserRelation();
//				tu.setTeamId(teamId);
//				User user= UserUtils.getUser();
//				tu.setUser(user);
//				TeamUserRelation  teamUserRelation=teamUserRelationService.getByTeamAndUser(tu);
//				String state=teamUserRelation.getState();
//				model.addAttribute("state", state);  //state为0可以同意、不同意、忽略
				return "modules/oa/oaNotifyTeam";
			}*/
			if (oaNotify!=null) {
				if ("1".equals(oaNotify.getSendType())) {
					return "modules/oa/oaNotifyFormBroadcast";
				}else if ("2".equals(oaNotify.getSendType())) {
					return "modules/oa/oaNotifyFormAssign";
				}
			}else{
			  return CoreSval.REDIRECT + Global.getAdminPath() + "/oa/oaNotify/self?repage";
			}

			//return "modules/oa/oaNotifyForm";
		}
		return CoreSval.REDIRECT + Global.getAdminPath() + "/oa/oaNotify/self?repage";
	}

	/**
	 * 查看我的通知-数据
	 */
	@RequestMapping(value = "viewData")
	@ResponseBody
	public OaNotify viewData(OaNotify oaNotify, Model model) {
		if (StringUtil.isNotBlank(oaNotify.getId())) {
			oaNotifyService.updateReadFlag(oaNotify);
			return oaNotify;
		}
		return null;
	}

	/**
	 * 查看我的通知-发送记录
	 */
	@RequestMapping(value = "viewRecordData")
	@ResponseBody
	public OaNotify viewRecordData(OaNotify oaNotify, Model model) {
		if (StringUtil.isNotBlank(oaNotify.getId())) {
			oaNotify = oaNotifyService.getRecordList(oaNotify);
			return oaNotify;
		}
		return null;
	}

	/**
	 * 获取我的通知数目
	 */
	@RequestMapping(value = "self/count")
	@ResponseBody
	public String selfCount(OaNotify oaNotify, Model model) {
		oaNotify.setIsSelf(true);
		oaNotify.setReadFlag("0");
		return String.valueOf(oaNotifyService.findCount(oaNotify));
	}
	/**
	 * 获取我的通知数目
	 */
	@RequestMapping(value = "validateName")
	@ResponseBody
	public String validateName(String title,String oldTitle) {
		if (StringUtil.equals(title,oldTitle)) {
			return "0";
		}
		OaNotify oaNotify = new OaNotify();
		oaNotify.setTitle(title);
		return String.valueOf(oaNotifyService.findCount(oaNotify));
	}

	@RequestMapping(value = "checkTitle")
	@ResponseBody
	public boolean checkTitle(String title,String oldTitle) {
		if (StringUtil.equals(title,oldTitle)) {
			return true;
		}

		OaNotify oaNotify = new OaNotify();
		oaNotify.setTitle(title);
		if ( oaNotifyService.findCount(oaNotify)>0) {
			return false;
		}
		return true;
	}
	//通告添加
	@RequestMapping(value = "allNoticeForm")
	public String allNoticeForm(OaNotify oaNotify, Model model, RedirectAttributes redirectAttributes) {

	    if (oaNotify != null) {
	  	  //处理关键字
	  		if (StringUtil.isNotEmpty(oaNotify.getId())) {
	  			if ("4".equals(oaNotify.getType())||"8".equals(oaNotify.getType())||"9".equals(oaNotify.getType())) {
	  					oaNotify.setKeywords(oaNotifyKeywordService.findListByEsid(oaNotify.getId()));
	  			}
	  		}
	  		if (oaNotify!=null&&StringUtil.isNotEmpty(oaNotify.getContent())) {
	  			oaNotify.setContent(oaNotify.getContent().replaceAll(FtpUtil.FTP_MARKER,FtpUtil.FTP_HTTPURL));
	  		}
	    }
		return  "modules/oa/notice/allNoticeForm";
	}
	@RequestMapping(value = "saveAllNotice")
	public String saveAllNotice(OaNotify oaNotify, Model model, RedirectAttributes redirectAttributes) {
		oaNotifyService.saveCollegeBroadcast(oaNotify);
		addMessage(redirectAttributes, "保存通告" + oaNotify.getTitle() + "成功");
		return CoreSval.REDIRECT + Global.getAdminPath() + "/oa/oaNotify/broadcastList";
	}

	@RequestMapping(value="saveNotify", method = RequestMethod.POST, produces = "application/json")
	@ResponseBody
	public ApiResult saveNotify(@RequestBody OaNotify oaNotify){
		try {
			oaNotifyService.saveCollegeBroadcast(oaNotify);
			return ApiResult.success();
		}catch (Exception e){
			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
		}
	}

}