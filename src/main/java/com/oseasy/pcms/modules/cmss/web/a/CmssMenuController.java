package com.oseasy.pcms.modules.cmss.web.a;

import java.io.IOException;
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
import com.oseasy.initiate.common.config.SysIdx;
import com.oseasy.initiate.modules.ftp.service.FtpService;
import com.oseasy.pcms.modules.cmss.entity.CmssMenu;
import com.oseasy.pcms.modules.cmss.service.CmssMenuService;
import com.oseasy.pcore.common.config.ApiConst;
import com.oseasy.pcore.common.config.ApiResult;
import com.oseasy.pcore.common.config.CoreIds;
import com.oseasy.pcore.common.config.CoreJkey;
import com.oseasy.pcore.common.config.CorePages;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.CoreUrl;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.utils.FtpUtil;
import com.oseasy.pcore.common.utils.VsftpUtils;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.putil.common.utils.exception.ExceptionUtil;

import net.sf.json.JSONObject;

/**
 * 站点菜单Controller.
 *
 * @author chenhao
 * @version 2019-01-01
 */
@Controller
@RequestMapping(value = "${adminPath}/cmss/cmssMenu")
public class CmssMenuController extends BaseController {
    private static final String CMSS_LIST = "/cmss/cmssMenu/";

    @Autowired
    private CmssMenuService entityService;
    @Autowired
    private FtpService ftpService;

    @ModelAttribute
    public CmssMenu get(@RequestParam(required = false) String id) {
        CmssMenu entity = null;
        if (StringUtil.isNotBlank(id)) {
            entity = entityService.get(id);
        }
        if (entity == null) {
            entity = new CmssMenu();
        }
        return entity;
    }

    @RequiresPermissions("cmss:cmssMenu:view")
    @RequestMapping(value = { "list", "" })
    public String list(Model model) {
        return "modules/pcms/cmss/cmssMenuList";
    }

    @RequiresPermissions("cmss:cmssMenu:view")
    @RequestMapping(value = "form")
    public String form(CmssMenu menu, Model model, HttpServletRequest request) {
        if (menu.getParent() == null || menu.getParent().getId() == null) {
            menu.setParent(new CmssMenu(CmssMenu.getRootId()));
        }
        menu.setParent(entityService.get(menu.getParent().getId()));
        // 获取排序号，最末节点排序号+30
        if (StringUtil.isBlank(menu.getId())) {
            List<CmssMenu> list = Lists.newArrayList();
            List<CmssMenu> sourcelist = entityService.findAll();
            CmssMenu.sortList(list, sourcelist, menu.getParentId(), false);
            if (list.size() > 0) {
                menu.setSort(list.get(list.size() - 1).getSort() + 30);
            }
        }
        String secondName = request.getParameter("secondName");
        if (StringUtil.isNotEmpty(secondName)) {
            model.addAttribute("secondName", secondName);
        }
        model.addAttribute("menu", menu);
        return "modules/pcms/cmss/cmssMenuForm";
    }

    @RequiresPermissions("cmss:cmssMenu:edit")
    @RequestMapping(value = "save")
    public String save(CmssMenu menu, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        if (!(CoreUtils.getUser().getAdmin() || CoreUtils.getUser().getSysAdmin())) {
            addMessage(redirectAttributes, "越权操作，只有超级管理员才能添加或修改数据！");
            return CoreSval.REDIRECT + Global.getAdminPath() + "/sys/role/?repage";
        }
        if (Global.isDemoMode()) {
            addMessage(redirectAttributes, "演示模式，不允许操作！");
            return CoreSval.REDIRECT + Global.getAdminPath() + CMSS_LIST;
        }
        if (!beanValidator(model, menu)) {
            return form(menu, model, request);
        }
        try {
            String arrUrl = request.getParameter("arrUrl");
            if (arrUrl != null && !"".equals(arrUrl)) {
                if (menu.getImgUrl() != null) {
                    ftpService.del(menu.getImgUrl());
                }
                String img = FtpUtil.moveFile(FtpUtil.getftpClient(), arrUrl);
                menu.setImgUrl(img);
            }
        } catch (Exception e) {
            logger.error(ExceptionUtil.getStackTrace(e));
        }
        entityService.save(menu);
        addMessage(redirectAttributes, "保存菜单'" + menu.getName() + "'成功");
        return CoreSval.REDIRECT + Global.getAdminPath() + CMSS_LIST;
    }

    @RequiresPermissions("cmss:cmssMenu:edit")
    @RequestMapping(value = "delete")
    public String delete(CmssMenu menu, RedirectAttributes redirectAttributes) {
        if (Global.isDemoMode()) {
            addMessage(redirectAttributes, "演示模式，不允许操作！");
            return CoreSval.REDIRECT + Global.getAdminPath() + CMSS_LIST;
        }
        entityService.delete(menu);
        addMessage(redirectAttributes, "删除菜单成功");
        return CoreSval.REDIRECT + Global.getAdminPath() + CMSS_LIST;
    }

    @RequiresPermissions("user")
    @RequestMapping(value = "tree")
    public String tree() {
        return "modules/pcms/cmss/cmssMenuTree";
    }

    @ResponseBody
    @RequestMapping(value = "getMenuList", method = RequestMethod.GET, produces = "application/json")
    public ApiResult getMenuList(Model model) {
        try {
            List<CmssMenu> list = Lists.newArrayList();
            List<CmssMenu> sourcelist = entityService.findAll();
            CmssMenu.sortList(list, sourcelist, CmssMenu.getRootId(), true);
            return ApiResult.success(list);
        } catch (Exception e) {
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,
                    ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR) + StringUtil.MAOH + e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping(value = "getMenuTree", method = RequestMethod.GET, produces = "application/json")
    public ApiResult getMenuTree() {
        try {
            List<CmssMenu> list = Lists.newArrayList();
            List<CmssMenu> sourcelist = entityService.findAll();
            CmssMenu.sortList(list, sourcelist, CmssMenu.getRootId(), true);
            List<CmssMenu> listMenu = CmssMenu.buildMenuTree(list);
            return ApiResult.success(listMenu);
        } catch (Exception e) {
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,
                    ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR) + StringUtil.MAOH + e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping(value = "ajaxDeleteMenu", method = RequestMethod.POST, produces = "application/json")
    public ApiResult ajaxDeleteMenu(@RequestBody CmssMenu menu) {
        try {
            entityService.delete(menu);
            return ApiResult.success();
        } catch (Exception e) {
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,
                    ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR) + StringUtil.MAOH + e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping(value = "ajaxChangeMenuIsShow", method = RequestMethod.POST, produces = "application/json")
    public ApiResult ajaxChangeIsShow(@RequestBody CmssMenu menu) {
        try {
            entityService.changeIsShow(menu);
            return ApiResult.success();
        } catch (Exception e) {
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,
                    ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR) + StringUtil.MAOH + e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping(value = "saveMenu", method = RequestMethod.POST, produces = "application/json")
    public ApiResult saveMenu(@RequestBody CmssMenu menu, Model model) {
        try {
            menu.setParentIds(menu.getParent().getParentIds() + menu.getParent().getId() + StringUtil.DOTH);
            if (!(CoreUtils.getUser().getAdmin() || CoreUtils.getUser().getSysAdmin())) {
                return ApiResult.failed(ApiConst.CODE_INNER_ERROR,
                        ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR) + ":越权操作，只有超级管理员才能添加或修改数据！");
            }
            if (Global.isDemoMode()) {
                return ApiResult.failed(ApiConst.CODE_INNER_ERROR,
                        ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR) + ":演示模式，不允许操作！");
            }
            try {
                if (StringUtil.isNotEmpty(menu.getImgUrl())) {
                    String newUrl = VsftpUtils.moveFile(menu.getImgUrl());
                    menu.setImgUrl(newUrl);
                }
            } catch (IOException e) {
                logger.error(e.toString());
            }
            entityService.save(menu);
            return ApiResult.success(menu);

        } catch (Exception e) {
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,
                    ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR) + StringUtil.MAOH + e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping(value = "checkMenuName", method = RequestMethod.GET, produces = "application/json")
    public Boolean checkName(CmssMenu menu) {
        return entityService.checkName(menu);
    }

    @RequiresPermissions("user")
    @RequestMapping(value = "treePlus")
    public String treePlus(String parentId, Model model, String href) {
        List<CmssMenu> list = Lists.newArrayList();
        List<CmssMenu> sourcelist = entityService.findAll();
        CmssMenu.sortList(list, sourcelist, parentId, true);
        // 没有下级菜单
        if (list.size() == 0) {
            model.addAttribute(CoreJkey.JK_MSG, "无权限访问该页面");
            return CorePages.ERROR_MSG.getIdxUrl();
        }
        CmssMenu firstMenu = entityService.get(parentId);
        List<CmssMenu> secondMenus = Lists.newArrayList();
        List<CmssMenu> threeMenus = Lists.newArrayList();

        for (CmssMenu menu : list) {
            if (menu.getParent().getId().equals(parentId)) {
                if (StringUtil.equals("1", menu.getIsShow())) {
                    secondMenus.add(menu);
                }
            } else {
                threeMenus.add(menu);
            }
        }
        for (CmssMenu menu2 : secondMenus) {
            List<CmssMenu> children = Lists.newArrayList();
            for (CmssMenu menu3 : threeMenus) {
                if (menu3.getParent().getId().equals(menu2.getId())) {
                    if (StringUtil.equals(CoreIds.SYS_TREE_ROOT.getId(), menu3.getIsShow())) {
                        children.add(menu3);
                    }
                }
            }
            menu2.setChildren(children);
        }

        if (StringUtil.isNotEmpty(firstMenu.getHref())
                && StringUtil.isNotEmpty((firstMenu.getHref()).replaceAll(StringUtil.KGE, StringUtil.EMPTY))) {
            model.addAttribute("hasHome", true);
        } else {
            model.addAttribute("hasHome", false);
        }
        model.addAttribute("firstMenu", firstMenu);
        model.addAttribute("secondMenus", secondMenus);
        model.addAttribute(CoreJkey.JK_HREF, href);
        return SysIdx.SYSIDX_BACK_V4.getIdxUrl();
    }

    @RequiresPermissions("user")
    @RequestMapping(value = "treeselect")
    public String treeselect(String parentId, Model model) {
        model.addAttribute(CoreJkey.JK_PID, parentId);
        return "modules/pcms/cmss/cmssMenuTreeselect";
    }

    /**
     * 批量修改菜单排序
     */
    @RequiresPermissions("cmss:cmssMenu:edit")
    @RequestMapping(value = "updateSort")
    public String updateSort(String[] ids, Integer[] sorts, RedirectAttributes redirectAttributes) {
        if (Global.isDemoMode()) {
            addMessage(redirectAttributes, "演示模式，不允许操作！");
            return CoreSval.REDIRECT + Global.getAdminPath() + CMSS_LIST;
        }
        for (int i = 0; i < ids.length; i++) {
            CmssMenu menu = new CmssMenu(ids[i]);
            menu.setSort(sorts[i]);
            entityService.updateSort(menu);
        }
        addMessage(redirectAttributes, "保存菜单排序成功!");
        return CoreSval.REDIRECT + Global.getAdminPath() + CMSS_LIST;
    }

    @RequestMapping(value = "ajaxUpdateSort", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public ApiResult ajaxUpdateSort(@RequestBody CmssMenu menu, RedirectAttributes redirectAttributes) {
        if (Global.isDemoMode()) {
            return ApiResult.failed(ApiConst.STATUS_FAIL, ApiConst.getErrMsg(ApiConst.STATUS_FAIL) + "演示模式，不允许操作！");
        }
        for (int i = 0; i < menu.getMenuList().size(); i++) {
            CmssMenu menuIndex = menu.getMenuList().get(i);
            entityService.updateSort(menuIndex);
        }
        addMessage(redirectAttributes, "保存菜单排序成功!");
        return ApiResult.success();
    }

    /**
     * isShowHide是否显示隐藏菜单
     *
     * @param extId
     * @param response
     * @return
     */
    @ResponseBody
    @RequiresPermissions("user")
    @RequestMapping(value = "treeData")
    public List<Map<String, Object>> treeData(@RequestParam(required = false) String extId,
            @RequestParam(required = false) String isShowHide, HttpServletResponse response) {
        List<Map<String, Object>> mapList = Lists.newArrayList();
        List<CmssMenu> list = entityService.findAll();
        for (int i = 0; i < list.size(); i++) {
            CmssMenu e = list.get(i);
            if (StringUtil.isBlank(extId) || (extId != null && !extId.equals(e.getId())
                    && e.getParentIds().indexOf(StringUtil.DOTH + extId + StringUtil.DOTH) == -1)) {
                if (isShowHide != null && isShowHide.equals(CoreSval.HIDE) && e.getIsShow().equals(CoreSval.HIDE)) {
                    continue;
                }
                Map<String, Object> map = Maps.newHashMap();
                map.put(CoreJkey.JK_ID, e.getId());
                map.put("pId", e.getParentId());
                map.put(CoreJkey.JK_NAME, e.getName());
                mapList.add(map);
            }
        }
        return mapList;
    }

    @ResponseBody
    @RequestMapping(value = "/navigation", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    public JSONObject navigation(String href) {
        JSONObject js = new JSONObject();
        if (href.substring(0, 2).equals(CoreUrl.A_ROOT.getUrl())) {
            href = href.substring(2);
        }
        href = href.replace("&amp;", "&");
        CmssMenu menu = entityService.getByHref(href);
        if (menu != null) {
            js.put("secondName", menu.getName());
            CmssMenu parentMenu = menu.getParent();
            if (parentMenu != null) {
                js.put("firstName", parentMenu.getName());
            }
            js.put(CoreJkey.JK_RET, Global.YES);
            return js;
        } else {
            js.put(CoreJkey.JK_RET, Global.NO);
            return js;
        }
    }
}