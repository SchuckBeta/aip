/**
 *
 */
package com.oseasy.pcore.modules.oa.web.a;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oseasy.initiate.modules.oa.entity.OaNotify;
import com.oseasy.initiate.modules.oa.entity.OaNotifySent;
import com.oseasy.initiate.modules.oa.service.OaNotifyService;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 网站Controller


 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaNotify")
public class OaNotifyAcontroller extends BaseController{
    @Autowired
    private OaNotifyService oaNotifyService;

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

    @RequestMapping(value="resetNotifyShow")
    @ResponseBody
    public String resetNotifyShow(HttpServletRequest request, HttpServletResponse response) {
        if (request.getSession().getAttribute("notifyShow")!=null) {//登录成功后重置是否弹出消息
            request.getSession().removeAttribute("notifyShow");
        }
        return "1";
    }

    //页面未读通知消息
    @RequestMapping(value="unReadOaNotify")
    @ResponseBody
    public List<OaNotifySent> unReadOaNotify(OaNotify oaNotify) {
        return oaNotifyService.unRead(oaNotify);

    }

    //关闭操作
    @RequestMapping(value="closeButton")
    @ResponseBody
    public String closeButton(HttpServletRequest request) {
        String oaNotifyId = request.getParameter("send_id");
        OaNotify oaNotify = oaNotifyService.get(oaNotifyId);
        oaNotifyService.updateReadFlag(oaNotify);
        return "1";
    }
}
