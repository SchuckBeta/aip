/**
 *
 */
package com.oseasy.initiate.modules.oa.web;

import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oseasy.initiate.modules.oa.service.OaNotifyKeywordService;
import com.oseasy.initiate.modules.sys.utils.UserUtils;
import com.oseasy.pcore.common.config.ApiConst;
import com.oseasy.pcore.common.config.ApiResult;
import com.oseasy.pcore.common.config.CoreJkey;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.utils.FtpUtil;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.oa.entity.OaNotify;
import com.oseasy.pcore.modules.oa.service.OaNotifyService;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;
import com.oseasy.putil.common.utils.StringUtil;

import net.sf.json.JSONObject;

/**
 * 通知通告Controller
 *
 * @version 2014-05-16
 */
@Controller
@RequestMapping(value = "${frontPath}/oa/oaNotify")
public class FrontOaNotifyController extends BaseController {
    private static final String DOWN_FILE_F = "f/ftp/ueditorUpload/downFile";
    private static final String DOWN_FILE_A = "a/ftp/ueditorUpload/downFile";
    @Autowired
    private OaNotifyKeywordService oaNotifyKeywordService;
    @Autowired
    private OaNotifyService oaNotifyService;

    @ModelAttribute
    public OaNotify get(@RequestParam(required = false) String id) {
        OaNotify entity = null;
        if (StringUtil.isNotBlank(id)) {
            entity = oaNotifyService.get(id);
        }
        if (entity == null) {
            entity = new OaNotify();
        }
        return entity;
    }

    public static String convertFront(String content) {
        if (((content).indexOf(DOWN_FILE_A) != -1)) {
            content = content.replaceAll(DOWN_FILE_A, DOWN_FILE_F);
        }
        return content;
    }

    @RequestMapping(value = {"viewList"})
    public String viewList(OaNotify oaNotify, HttpServletRequest request, HttpServletResponse response, Model model) {
//		User currUser = CoreUtils.getUser();
//		//logger.info("curre========="+currUser.getId());
//		if (currUser!=null&&currUser.getId()!=null&&!"1".equals(currUser.getId())) {
//			oaNotify.setUserId(String.valueOf(currUser.getId()));
//		}
//		oaNotify.setIsSelf(true);
//		Page<OaNotify> page = oaNotifyService.find(new Page<OaNotify>(request, response), oaNotify);
//		model.addAttribute("page", page);
        return "modules/oa/oaNotifyViewList";
    }

    @RequestMapping(value = {"getUnreadCount"})
    @ResponseBody
    public JSONObject getUnreadCount() {
        String uid = CoreUtils.getUser().getId();
        JSONObject js = new JSONObject();
        js.put(CoreJkey.JK_RET, "1");
        if (StringUtil.isEmpty(uid)) {
            js.put(CoreJkey.JK_RET, "0");
            js.put("count", 0);
            return js;
        }
//		Integer c=oaNotifyService.getUnreadCount(uid);
        Integer c = oaNotifyService.getUnreadCountByUser(CoreUtils.getUser());
        if (c == null) {
            c = 0;
        }
        js.put("count", c);
        return js;
    }


    /**
     * 首页我的通知列表
     */
    @RequestMapping(value = "indexMyNoticeList")
    public String indexMyNoticeList(OaNotify oaNotify, HttpServletRequest request, HttpServletResponse response, Model model) {
//        User currUser = CoreUtils.getUser();
//        if((currUser == null) || StringUtil.isEmpty(currUser.getId())){
//            return CoreSval.REDIRECT+ FrontController.LOGIN;
//        }
//        //logger.info("curre========="+currUser.getId());
//        if (currUser != null && currUser.getId() != null) {
//            oaNotify.setUserId(String.valueOf(currUser.getId()));
//        } else {
//            oaNotify.setType("error");
//        }
//
//        oaNotify.setIsSelf(true);
//        Page<OaNotify> page = oaNotifyService.findAllRecord(new Page<OaNotify>(request, response), oaNotify);
//        model.addAttribute("page", page);
        return "modules/oa/indexOaNotifyList";
    }
    //复制源码
    @RequestMapping(value = "getNotifyList", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public ApiResult getNotifyList(OaNotify oaNotify, HttpServletRequest request, HttpServletResponse response, Model model) {
        try {
            User currUser = CoreUtils.getUser();

            //logger.info("curre========="+currUser.getId());
            if (currUser != null && currUser.getId() != null) {
                oaNotify.setUserId(String.valueOf(currUser.getId()));
            } else {
                oaNotify.setType("error");
                return ApiResult.failed(ApiConst.CODE_INNER_ERROR, ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR) + ":用户不存在，请重新登录");
            }
            oaNotify.setIsSelf(true);
            Page<OaNotify> page = oaNotifyService.findAllRecord(new Page<OaNotify>(request, response), oaNotify);
            List<OaNotify> list = page.getList();
            for (OaNotify oaNotifyItem : list) {
                String id = oaNotifyItem.getCreateBy().getId();
                User user = UserUtils.get(id);
                oaNotifyItem.setCreateUser(user);
            }
            return ApiResult.success(page);
        } catch (Exception e) {
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR, ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR) + ":" + e.getMessage());
        }
    }


    /**
     * 首页我的通知列表
     */
    @RequestMapping(value = "indexMySendNoticeList")
    public String indexMySendNoticeList(OaNotify oaNotify, HttpServletRequest request, HttpServletResponse response, Model model) {
        User currUser = CoreUtils.getUser();
        //logger.info("curre========="+currUser.getId());
        if (currUser != null && currUser.getId() != null) {
            oaNotify.setUserId(String.valueOf(currUser.getId()));
        } else {
            oaNotify.setType("error");
        }

        Page<OaNotify> page = oaNotifyService.findSend(new Page<OaNotify>(request, response), oaNotify);
        model.addAttribute("page", page);
        return "modules/oa/indexOaNotifySendList";
    }

    /*
       我的通知列表接收消息
    * */

    @RequestMapping(value = "getNotifySendList", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public ApiResult getNotifySendList(OaNotify oaNotify, HttpServletRequest request, HttpServletResponse response, Model model){
        try {
            User currUser = CoreUtils.getUser();
            //logger.info("curre========="+currUser.getId());
            if (currUser != null && currUser.getId() != null) {
                oaNotify.setUserId(String.valueOf(currUser.getId()));
            } else {
                oaNotify.setType("error");
                return ApiResult.failed(ApiConst.CODE_INNER_ERROR, ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR) + ":用户不存在，请重新登录");
            }
            Page<OaNotify> page = oaNotifyService.findSend(new Page<OaNotify>(request, response), oaNotify);
            List<OaNotify> list = page.getList();
            for (OaNotify oaNotifyItem : list) {
                String id = oaNotifyItem.getUserId();
                User user = UserUtils.get(id);
                oaNotifyItem.setReceiveUser(user);
            }
            return ApiResult.success(page);
        }catch (Exception e){
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR, ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR) + ":" + e.getMessage());
        }
    }


    @RequestMapping(value = "getReadFlag")
    @ResponseBody
    public String getReadFlag(String oaNotifyId) {
        String flag = "0";
        User u = CoreUtils.getUser();
        if (u != null) {
            return oaNotifyService.getReadFlag(oaNotifyId, u);
        }
        return flag;
    }

    /**
     * 查看我的通知
     */
    @RequestMapping(value = "view")
    @ResponseBody
    public OaNotify view(String oaNotifyId, Model model) {
        OaNotify oaNotify = new OaNotify();
        oaNotify.setId(oaNotifyId);
        oaNotifyService.updateReadFlag(oaNotify);
        oaNotify = oaNotifyService.get(oaNotify.getId());
        if (oaNotify == null) {
            return null;
        }
//		OaNotify  oaNotifyTmp = oaNotifyService.getRecordList(oaNotify);
        OaNotify oaNotifyTmp = oaNotifyService.getRecordListByUser(oaNotify);
        if (oaNotifyTmp == null) {
            return null;
        }
        if ((oaNotify == null) || (oaNotifyTmp == null)) {
            return oaNotify;
        }
        oaNotify.setOaNotifyRecordList(oaNotifyTmp.getOaNotifyRecordList());
        SimpleDateFormat sFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if (oaNotify.getEffectiveDate() != null) {
            String effDate = sFormat.format(oaNotify.getEffectiveDate());
            oaNotify.setPublishDate(effDate);
        }
        if (oaNotify.getContent() != null) {
            oaNotify.setContent(FrontOaNotifyController.convertFront(oaNotify.getContent()));
            oaNotify.setContent(StringUtil.replaceEscapeHtml(oaNotify.getContent()));
        }
        if (oaNotify != null && StringUtil.isNotEmpty(oaNotify.getContent())) {
            oaNotify.setContent(oaNotify.getContent().replaceAll(FtpUtil.FTP_MARKER, FtpUtil.FTP_HTTPURL));
        }
        return oaNotify;
    }

    /**
     * 查看双创动态、双创通知、省市动态
     */
    @RequestMapping(value = "viewDynamic")
    public String viewDynamic(OaNotify oaNotify, Model model, HttpServletRequest request) {
//        if (oaNotify != null) {
//            if (StringUtil.isEmpty(oaNotify.getViews())) {
//                oaNotify.setViews("0");
//            }
//            if (StringUtil.isNotEmpty(oaNotify.getId())) {
//                oaNotify.setKeywords(oaNotifyKeywordService.findListByEsid(oaNotify.getId()));
//            }
//            if (StringUtil.isNotEmpty(oaNotify.getContent())) {
//                oaNotify.setContent(FrontOaNotifyController.convertFront(oaNotify.getContent()));
//                oaNotify.setContent(StringEscapeUtils.unescapeHtml4(oaNotify.getContent()));
//            }
//            if (oaNotify != null && StringUtil.isNotEmpty(oaNotify.getContent())) {
//                oaNotify.setContent(oaNotify.getContent().replaceAll(FtpUtil.FTP_MARKER, FtpUtil.FTP_HTTPURL));
//            }
//            if (StringUtil.isNotEmpty(oaNotify.getId())) {
//                model.addAttribute("more", oaNotifyService.getMore(oaNotify.getType(), oaNotify.getId(), oaNotify.getKeywords()));
//            }
//            if (StringUtil.isNotEmpty(oaNotify.getId())) {
//                InteractiveUtil.updateViews(oaNotify.getId(), request, CacheUtils.DYNAMIC_VIEWS_QUEUE);
//            }
//        }
        return "modules/oa/dynamicView";
    }

    @RequestMapping(value = "deleteRec")
    public String deleteRec(OaNotify oaNotify, RedirectAttributes redirectAttributes) {
        oaNotifyService.deleteRec(oaNotify);
        addMessage(redirectAttributes, "删除成功");
        return CoreSval.REDIRECT + frontPath + "/oa/oaNotify/indexMyNoticeList/?repage";
    }

    // 删除接收消息 by王清腾
    @RequestMapping(value = "delNotify", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    @ResponseBody
    public ApiResult delNotify(OaNotify oaNotify) {
        try {
            oaNotifyService.deleteRec(oaNotify);
            return ApiResult.success();
        }catch (Exception e){
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR, ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR) + ":" + e.getMessage());
        }
    }


    @RequestMapping(value = "deleteSend")
    public String deleteSend(OaNotify oaNotify, RedirectAttributes redirectAttributes) {
        oaNotifyService.deleteSend(oaNotify);
        addMessage(redirectAttributes, "删除成功");
        return CoreSval.REDIRECT + frontPath + "/oa/oaNotify/indexMySendNoticeList/?repage";
    }

    // 删除发送消息 by王清腾
    @RequestMapping(value = "delSendNotify", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    @ResponseBody
    public ApiResult delSendNotify(OaNotify oaNotify) {
        try {
            oaNotifyService.deleteSend(oaNotify);
            return ApiResult.success();
        }catch (Exception e){
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR, ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR) + ":" + e.getMessage());
        }
    }

    /**
     * 批量删除接收消息
     *
     * @param ids OaNotify的ids，以逗号分隔
     */
    @RequestMapping(value = "deleteRevBatch")
    @ResponseBody
    public boolean deleteRevBatch(String ids) {
        String[] idStr = ids.split(",");
        for (int i = 0; i < idStr.length; i++) {
            OaNotify oaNotify = new OaNotify();
            oaNotify.setId(idStr[i]);
            oaNotifyService.deleteRec(oaNotify);
        }
        return true;
    }

    /**
     * 批量删除发送消息
     *
     * @param ids OaNotify的ids，以逗号分隔
     */
    @RequestMapping(value = "deleteSendBatch")
    @ResponseBody
    public boolean deleteSendBatch(String ids) {
        String[] idStr = ids.split(",");
        for (String anIdStr : idStr) {
            OaNotify oaNotify = new OaNotify();
            oaNotify.setId(anIdStr);
            oaNotifyService.deleteSend(oaNotify);
        }
        return true;
    }

    @RequestMapping(value="delNotifySendBatch", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public ApiResult delNotifyBatch(String ids){
        try {
            String[] idStr = ids.split(",");
            for (String anIdStr : idStr) {
                OaNotify oaNotify =oaNotifyService.get(anIdStr);
                oaNotifyService.deleteSend(oaNotify);
            }
            return  ApiResult.success();
        }catch (Exception e){
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR, ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR) + ":" + e.getMessage());
        }
    }

    @RequestMapping(value="delNotifyRecBatch", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public ApiResult delNotifyRecBatch(String ids){
        try {
            String[] idStr = ids.split(",");
            for (String anIdStr : idStr) {
                OaNotify oaNotify =oaNotifyService.get(anIdStr);
                oaNotifyService.deleteRec(oaNotify);
            }
            return  ApiResult.success();
        }catch (Exception e){
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR, ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR) + ":" + e.getMessage());
        }
    }


    /**
     * 双创动态，双创通知，省市动态分页
     */
    @RequestMapping(value = "getPageJson")
    @ResponseBody
    public Page<OaNotify> getPageJson(OaNotify oaNotify, int pageNo, int pageSize, String funcName) {
        oaNotify.setStatus("1");
        Page<OaNotify> page = new Page<OaNotify>(pageNo, pageSize);
        page.setFuncName(funcName);
        page = oaNotifyService.findPage(page, oaNotify);
        return page;
    }
}