/**
 *
 */
package com.oseasy.initiate.modules.sys.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
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
import com.oseasy.initiate.modules.sys.service.SystemService;
import com.oseasy.initiate.modules.sys.utils.UserUtils;
import com.oseasy.pact.modules.act.service.ActTaskService;
import com.oseasy.pcore.common.config.ApiConst;
import com.oseasy.pcore.common.config.ApiResult;
import com.oseasy.pcore.common.config.ApiTstatus;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.utils.FtpUtil;
import com.oseasy.pcore.common.utils.VsftpUtils;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.Menu;
import com.oseasy.pcore.modules.sys.entity.Role;
import com.oseasy.pcore.modules.sys.service.CoreService;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.putil.common.utils.exception.ExceptionUtil;

import net.sf.json.JSONObject;

/**
 * 菜单Controller


 */
@Controller
@RequestMapping(value = "${adminPath}/sys/menu")
public class MenuController extends BaseController {
    @Autowired
    private SystemService systemService;
    @Autowired
    private CoreService coreService;
    @Autowired
    private FtpService ftpService;
    @Autowired
    private ActTaskService actTaskService;

    @ModelAttribute("menu")
    public Menu get(@RequestParam(required=false) String id) {
        if (StringUtil.isNotBlank(id)) {
            return systemService.getMenu(id);
        }else{
            return new Menu();
        }
    }

    @RequiresPermissions("sys:menu:view")
    @RequestMapping(value = {"list", ""})
    public String list(Model model) {
//      List<Menu> list = Lists.newArrayList();
//      List<Menu> sourcelist = systemService.findAllMenu();
//      Menu.sortList(list, sourcelist, Menu.getRootId(), true);
//        model.addAttribute("list", list);
        return "modules/sys/menuList";
    }


    @RequestMapping(value = "getMenuList", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public ApiResult getMenuList(Model model){
        try {
            List<Menu> list = Lists.newArrayList();
            List<Menu> sourcelist = systemService.findAllMenu();
            Menu.sortList(list, sourcelist, Menu.getRootId(), true);
            return ApiResult.success(list);
        }catch (Exception e){
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }

    @RequestMapping(value = "getMenuTree", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public ApiResult getMenuTree (){
        try{
            List<Menu> list = Lists.newArrayList();
            List<Menu> sourcelist = systemService.findAllMenu();
            Menu.sortList(list, sourcelist, Menu.getRootId(), true);
            List<Menu> listMenu = buildMenuTree(list);
            return ApiResult.success(listMenu);
        }catch (Exception e){
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }

    private List<Menu> buildMenuTree(List<Menu> ListMenu){
        List<Menu> list = Lists.newArrayList();
        for(Menu menu : ListMenu){
            if(Menu.getRootId().equals(menu.getParent().getId())){
                list.add(menu);
            }
            for(Menu childMenu : ListMenu){
                if(childMenu.getParent().getId().equals(menu.getId())){
                    if(menu.getChildren() == null){
                        menu.setChildren(new ArrayList<Menu>());
                    }
                    menu.getChildren().add(childMenu);
                }
            }
        }
        return list;
    }

    @RequestMapping(value = "ajaxDeleteMenu", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public ApiResult ajaxDeleteMenu(@RequestBody Menu menu){
        try {
            coreService.deleteMenu(menu);
            return ApiResult.success();
        }catch (Exception e){
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }

    @RequestMapping(value = "ajaxChangeMenuIsShow", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public ApiResult ajaxChangeMenuIsShow(@RequestBody Menu menu){
        try {
            systemService.changeMenuIsShow(menu);
            return ApiResult.success();
        }catch (Exception e){
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }

    @RequestMapping(value="saveMenu", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public ApiResult saveMenu(@RequestBody Menu menu, Model model){
        try {
//          Menu oldMenu = systemService.getMenu(menu.getId());
//          if(oldMenu.getParentId().equals(menu.getParentId())){
//              menu.setParent(oldMenu.getParent());
//          }
            menu.setParentIds(menu.getParent().getParentIds() + menu.getParent().getId() + ",");
//          menu.setParentIds(oldMenu.getParentIds());
            if (!(UserUtils.getUser().getAdmin() || UserUtils.getUser().getSysAdmin())) {
                return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":越权操作，只有超级管理员才能添加或修改数据！");
            }
            if (Global.isDemoMode()) {
                return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":演示模式，不允许操作！");
            }
//            if (!beanValidator(model, menu)) {
//                return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":数据验证失败");
//            }
//          try {
//              String arrUrl= menu.getImgUrl();
//              if (arrUrl!=null&&!"".equals(arrUrl)) {
//                  if (menu.getImgUrl()!=null) {
//                      ftpService.del(menu.getImgUrl());
//                  }
//                  String img= FtpUtil.moveFile(FtpUtil.getftpClient(),arrUrl);
//                  menu.setImgUrl(img);
//              }
//          } catch (Exception e) {
//              logger.error(ExceptionUtil.getStackTrace(e));
//          }
            try {
                if(StringUtil.isNotEmpty(menu.getImgUrl())){
                    String newUrl = VsftpUtils.moveFile(menu.getImgUrl());
                    menu.setImgUrl(newUrl);
                }
            } catch (IOException e) {
                logger.error(e.toString());
            }
            systemService.saveMenu(menu);
            return ApiResult.success(menu);

        }catch (Exception e) {
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }


    @RequestMapping(value="checkMenuName", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public Boolean checkMenuName(Menu menu){
        return systemService.checkMenuName(menu);
    }

    @RequiresPermissions("sys:menu:view")
    @RequestMapping(value = "form")
    public String form(Menu menu, Model model, HttpServletRequest request) {
        if (menu.getParent()==null||menu.getParent().getId()==null) {
            menu.setParent(new Menu(Menu.getRootId()));
        }
        menu.setParent(systemService.getMenu(menu.getParent().getId()));
        // 获取排序号，最末节点排序号+30
        if (StringUtil.isBlank(menu.getId())) {
            List<Menu> list = Lists.newArrayList();
            List<Menu> sourcelist = systemService.findAllMenu();
            Menu.sortList(list, sourcelist, menu.getParentId(), false);
            if (list.size() > 0) {
                menu.setSort(list.get(list.size()-1).getSort() + 30);
            }
        }
        String secondName=request.getParameter("secondName");
        if(StringUtil.isNotEmpty(secondName)){
            model.addAttribute("secondName",secondName);
        }
        model.addAttribute("menu", menu);
        return "modules/sys/menuForm";
    }

    @RequiresPermissions("sys:menu:edit")
    @RequestMapping(value = "save")
    public String save(Menu menu, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        if (!(UserUtils.getUser().getAdmin() || UserUtils.getUser().getSysAdmin())) {
            addMessage(redirectAttributes, "越权操作，只有超级管理员才能添加或修改数据！");
            return CoreSval.REDIRECT + adminPath + "/sys/role/?repage";
        }
        if (Global.isDemoMode()) {
            addMessage(redirectAttributes, "演示模式，不允许操作！");
            return CoreSval.REDIRECT + adminPath + "/sys/menu/";
        }
        if (!beanValidator(model, menu)) {
            return form(menu, model, request);
        }
        try {
            String arrUrl= request.getParameter("arrUrl");
            if (arrUrl!=null&&!"".equals(arrUrl)) {
                if (menu.getImgUrl()!=null) {
                    ftpService.del(menu.getImgUrl());
                }
                    String img= FtpUtil.moveFile(FtpUtil.getftpClient(),arrUrl);
                    menu.setImgUrl(img);
            }
        } catch (Exception e) {
            logger.error(ExceptionUtil.getStackTrace(e));
        }
        systemService.saveMenu(menu);
        addMessage(redirectAttributes, "保存菜单'" + menu.getName() + "'成功");
        return CoreSval.REDIRECT + adminPath + "/sys/menu/";
    }

    @RequiresPermissions("sys:menu:edit")
    @RequestMapping(value = "delete")
    public String delete(Menu menu, RedirectAttributes redirectAttributes) {
        if (Global.isDemoMode()) {
            addMessage(redirectAttributes, "演示模式，不允许操作！");
            return CoreSval.REDIRECT + adminPath + "/sys/menu/";
        }
//      if (Menu.isRoot(id)) {
//          addMessage(redirectAttributes, "删除菜单失败, 不允许删除顶级菜单或编号为空");
//      }else{
            coreService.deleteMenu(menu);
            addMessage(redirectAttributes, "删除菜单成功");
//      }
        return CoreSval.REDIRECT + adminPath + "/sys/menu/";
    }

    @RequiresPermissions("user")
    @RequestMapping(value = "tree")
    public String tree() {
        return "modules/sys/menuTree";
    }

    @RequiresPermissions("user")
    @RequestMapping(value = "treePlus")
    public String treePlus(String parentId,Model model,String href) {
//      if (!authorizeService.checkMenu(parentId)) {
//          return "redirect:/a/authorize";
//      }
        List<Menu> list = Lists.newArrayList();
        List<Menu> sourcelist = systemService.findAllMenu();
        Menu.sortList(list, sourcelist, parentId, true);
        //没有下级菜单
        if (list.size()==0) {
            model.addAttribute("msg","无权限访问该页面");
            return "error/msg";
        }
        Menu firstMenu = systemService.getMenu(parentId);
        List<Menu> secondMenus=Lists.newArrayList();
        List<Menu> threeMenus=Lists.newArrayList();

        for (Menu menu:list) {
            if (menu.getParent().getId().equals(parentId)) {
                if (StringUtil.equals("1",menu.getIsShow())) {
                    secondMenus.add(menu);
                }
            }else{
                threeMenus.add(menu);
            }
        }
        for (Menu menu2:secondMenus) {
            List<Menu> children=Lists.newArrayList();
            for (Menu menu3:threeMenus) {
                if (menu3.getParent().getId().equals(menu2.getId())) {
                    if (StringUtil.equals("1",menu3.getIsShow())) {
                        children.add(menu3);
                    }

                }
            }
            menu2.setChildren(children);
        }

        // 自定义流程菜单待办任务数
        for (Menu menu : threeMenus) {
//          String hreff = menu.getHref();
//          if (StringUtils.isNotBlank(hreff) && hreff.contains("?actywId=") && hreff.contains("&gnodeId=")) {
//              int index1 = hreff.indexOf("?actywId=");
//              int index2 = hreff.indexOf("&gnodeId=");
//              String actywId = hreff.substring(index1 + 9, index2);
//              String gnodeId = hreff.substring(index2 + 9);
//              int count = actTaskService.todoCount(actywId, gnodeId);
//              menu.setTodoCount(count);
//          }

            menu.setTodoCount(systemService.menuTodoCount(menu, actTaskService));
//            menu.setTodoCount(ProjectUtils.assessCount(menu));
        }

        if (StringUtil.isNotEmpty(firstMenu.getHref()) && StringUtil.isNotEmpty((firstMenu.getHref()).replaceAll(" ", ""))) {
          model.addAttribute("hasHome", true);
        }else{
          model.addAttribute("hasHome", false);
        }
        model.addAttribute("firstMenu", firstMenu);
        model.addAttribute("secondMenus",secondMenus);

        model.addAttribute("href",href); //addBy张正，根据href跳转。如果href不为空，跳转到指定href
        return SysIdx.SYSIDX_BACK_V4.getIdxUrl();
    }

    @RequestMapping(value = "/totoReflash/{actywId}", method = RequestMethod.GET)
    @ResponseBody
    public String totoReflash(@PathVariable String actywId) {
        return actTaskService.flashTodoCount(actywId);
    }

    @RequiresPermissions("user")
    @RequestMapping(value = "treeselect")
    public String treeselect(String parentId, Model model) {
        model.addAttribute("parentId", parentId);
        return "modules/sys/menuTreeselect";
    }

    /**
     * 批量修改菜单排序
     */
    @RequiresPermissions("sys:menu:edit")
    @RequestMapping(value = "updateSort")
    public String updateSort(String[] ids, Integer[] sorts, RedirectAttributes redirectAttributes) {
        if (Global.isDemoMode()) {
            addMessage(redirectAttributes, "演示模式，不允许操作！");
            return CoreSval.REDIRECT + adminPath + "/sys/menu/";
        }
        for (int i = 0; i < ids.length; i++) {
            Menu menu = new Menu(ids[i]);
            menu.setSort(sorts[i]);
            coreService.updateMenuSort(menu);
        }
        addMessage(redirectAttributes, "保存菜单排序成功!");
        return CoreSval.REDIRECT + adminPath + "/sys/menu/";
    }

    @RequestMapping(value="ajaxUpdateSort", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public ApiResult ajaxUpdateSort(@RequestBody Menu menu, RedirectAttributes redirectAttributes) {
        if (Global.isDemoMode()) {
            return ApiResult.failed(ApiConst.STATUS_FAIL,ApiConst.getErrMsg(ApiConst.STATUS_FAIL)+"演示模式，不允许操作！");
        }
        for (int i = 0; i < menu.getMenuList().size(); i++) {
            Menu menuIndex = menu.getMenuList().get(i);
            coreService.updateMenuSort(menuIndex);
        }
        addMessage(redirectAttributes, "保存菜单排序成功!");
        return ApiResult.success();
    }

    /**
     * isShowHide是否显示隐藏菜单
     * @param extId
     * @param response
     * @return
     */
    @RequiresPermissions("user")
    @ResponseBody
    @RequestMapping(value = "treeData")
    public List<Map<String, Object>> treeData(@RequestParam(required=false) String extId,@RequestParam(required=false) String isShowHide, HttpServletResponse response) {
        List<Map<String, Object>> mapList = Lists.newArrayList();
        List<Menu> list = systemService.findAllMenu();
        for (int i=0; i<list.size(); i++) {
            Menu e = list.get(i);
            if (StringUtil.isBlank(extId) || (extId!=null && !extId.equals(e.getId()) && e.getParentIds().indexOf(","+extId+",")==-1)) {
                if (isShowHide != null && isShowHide.equals("0") && e.getIsShow().equals("0")) {
                    continue;
                }
                Map<String, Object> map = Maps.newHashMap();
                map.put("id", e.getId());
                map.put("pId", e.getParentId());
                map.put("name", e.getName());
                mapList.add(map);
            }
        }
        return mapList;
    }

    /**
     * 保存所有节点与流程状态
     */
    @ResponseBody
    @RequestMapping(value = "ajaxMenuCount")
    public ApiTstatus<Long> ajaxMenuCount(@RequestParam(required=false) String id) {
        if(StringUtil.isEmpty(id)){
            return new ApiTstatus<Long>(false, "菜单不能为空！");
        }
        List<Role> roles = UserUtils.getUser().getRoleList();
        if(StringUtil.checkEmpty(roles)){
            return new ApiTstatus<Long>(false, "菜单不能为空！");
        }
        List<Menu> sourcelist = coreService.findRoleMenuByParentIdsLike(roles, id);
        long total = 0;
        for (Menu m : sourcelist) {
            total += systemService.menuTodoCount(m, actTaskService);
        }

        if(total != 0){
            return new ApiTstatus<Long>(true, "代办任务有" + total + "条！", total);
        }
        return new ApiTstatus<Long>(false, "代办任务有0条！");
    }

    @RequestMapping(value = "/navigation", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    @ResponseBody
    public JSONObject navigation(String href) {
        JSONObject js=new JSONObject();
        if(href.substring(0,2).equals("/a")){
            href=href.substring(2);
        }
        href=href.replace("&amp;","&");
        Menu menu= coreService.getMenuByHref(href);
        if(menu!=null){
            js.put("secondName",menu.getName());
            Menu parentMenu=menu.getParent();
            if(parentMenu!=null){
                js.put("firstName",parentMenu.getName());
            }
            js.put("ret","1");
            return js;
        }else {
            js.put("ret", "0");
            return js;
        }
    }


//	@Autowired
//	private SystemService systemService;
//	@Autowired
//	private CoreService coreService;
//	@Autowired
//	private FtpService ftpService;
//	@Autowired
//	private ActTaskService actTaskService;
//
//	@ModelAttribute("menu")
//	public Menu get(@RequestParam(required=false) String id) {
//		if (StringUtil.isNotBlank(id)) {
//			return systemService.getMenu(id);
//		}else{
//			return new Menu();
//		}
//	}
//
//	@RequiresPermissions("sys:menu:view")
//	@RequestMapping(value = {"list", ""})
//	public String list(Model model) {
////		List<Menu> list = Lists.newArrayList();
////		List<Menu> sourcelist = systemService.findAllMenu();
////		Menu.sortList(list, sourcelist, Menu.getRootId(), true);
////        model.addAttribute("list", list);
//		return "modules/sys/menuList";
//	}
//
//
//	@RequestMapping(value = "getMenuList", method = RequestMethod.GET, produces = "application/json")
//	@ResponseBody
//	public ApiResult getMenuList(Model model){
//		try {
//			List<Menu> list = Lists.newArrayList();
//			List<Menu> sourcelist = systemService.findAllMenu();
//			Menu.sortList(list, sourcelist, Menu.getRootId(), true);
//			return ApiResult.success(list);
//		}catch (Exception e){
//			logger.error(e.getMessage());
//			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
//		}
//	}
//
//	@RequestMapping(value = "getMenuTree", method = RequestMethod.GET, produces = "application/json")
//    @ResponseBody
//    public ApiResult getMenuTree (){
//        try{
//            List<Menu> list = Lists.newArrayList();
//            List<Menu> sourcelist = systemService.findAllMenu();
//            Menu.sortList(list, sourcelist, Menu.getRootId(), true);
//            List<Menu> listMenu = buildMenuTree(list);
//            return ApiResult.success(listMenu);
//        }catch (Exception e){
//            logger.error(e.getMessage());
//            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
//        }
//    }
//
//    private List<Menu> buildMenuTree(List<Menu> ListMenu){
//        List<Menu> list = Lists.newArrayList();
//        for(Menu menu : ListMenu){
//            if(Menu.getRootId().equals(menu.getParent().getId())){
//                list.add(menu);
//            }
//            for(Menu childMenu : ListMenu){
//                if(childMenu.getParent().getId().equals(menu.getId())){
//                    if(menu.getChildren() == null){
//                        menu.setChildren(new ArrayList<Menu>());
//                    }
//                    menu.getChildren().add(childMenu);
//                }
//            }
//        }
//        return list;
//    }
//
//	@RequestMapping(value = "ajaxDeleteMenu", method = RequestMethod.POST, produces = "application/json")
//	@ResponseBody
//	public ApiResult ajaxDeleteMenu(@RequestBody Menu menu){
//		try {
//		    coreService.deleteMenu(menu);
//			return ApiResult.success();
//		}catch (Exception e){
//			logger.error(e.getMessage());
//			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
//		}
//	}
//
//	@RequestMapping(value = "ajaxChangeMenuIsShow", method = RequestMethod.POST, produces = "application/json")
//	@ResponseBody
//	public ApiResult ajaxChangeMenuIsShow(@RequestBody Menu menu){
//		try {
//			systemService.changeMenuIsShow(menu);
//			return ApiResult.success();
//		}catch (Exception e){
//			logger.error(e.getMessage());
//			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
//		}
//	}
//
//	@RequestMapping(value="saveMenu", method = RequestMethod.POST, produces = "application/json")
//	@ResponseBody
//	public ApiResult saveMenu(@RequestBody Menu menu, Model model){
//		try {
////			Menu oldMenu = systemService.getMenu(menu.getId());
////			if(oldMenu.getParentId().equals(menu.getParentId())){
////			    menu.setParent(oldMenu.getParent());
////			}
//			menu.setParentIds(menu.getParent().getParentIds() + menu.getParent().getId() + ",");
////			menu.setParentIds(oldMenu.getParentIds());
//			if (!(UserUtils.getUser().getAdmin() || UserUtils.getUser().getSysAdmin())) {
//				return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":越权操作，只有超级管理员才能添加或修改数据！");
//			}
//			if (Global.isDemoMode()) {
//				return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":演示模式，不允许操作！");
//			}
////            if (!beanValidator(model, menu)) {
////                return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":数据验证失败");
////            }
////			try {
////				String arrUrl= menu.getImgUrl();
////				if (arrUrl!=null&&!"".equals(arrUrl)) {
////					if (menu.getImgUrl()!=null) {
////						ftpService.del(menu.getImgUrl());
////					}
////					String img= FtpUtil.moveFile(FtpUtil.getftpClient(),arrUrl);
////					menu.setImgUrl(img);
////				}
////			} catch (Exception e) {
////				logger.error(ExceptionUtil.getStackTrace(e));
////			}
//			try {
//				String newUrl = VsftpUtils.moveFile(menu.getImgUrl());
//				menu.setImgUrl(newUrl);
//			} catch (IOException e) {
//				logger.error(e.toString());
//			}
//			systemService.saveMenu(menu);
//			return ApiResult.success(menu);
//
//		}catch (Exception e) {
//			logger.error(e.getMessage());
//			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
//		}
//	}
//
//
//	@RequestMapping(value="checkMenuName", method = RequestMethod.GET, produces = "application/json")
//	@ResponseBody
//	public Boolean checkMenuName(Menu menu){
//		return systemService.checkMenuName(menu);
//	}
//
//	@RequiresPermissions("sys:menu:view")
//	@RequestMapping(value = "form")
//	public String form(Menu menu, Model model, HttpServletRequest request) {
//		if (menu.getParent()==null||menu.getParent().getId()==null) {
//			menu.setParent(new Menu(Menu.getRootId()));
//		}
//		menu.setParent(systemService.getMenu(menu.getParent().getId()));
//		// 获取排序号，最末节点排序号+30
//		if (StringUtil.isBlank(menu.getId())) {
//			List<Menu> list = Lists.newArrayList();
//			List<Menu> sourcelist = systemService.findAllMenu();
//			Menu.sortList(list, sourcelist, menu.getParentId(), false);
//			if (list.size() > 0) {
//				menu.setSort(list.get(list.size()-1).getSort() + 30);
//			}
//		}
//		String secondName=request.getParameter("secondName");
//		if(StringUtil.isNotEmpty(secondName)){
//			model.addAttribute("secondName",secondName);
//		}
//		model.addAttribute("menu", menu);
//		return "modules/sys/menuForm";
//	}
//
//	@RequiresPermissions("sys:menu:edit")
//	@RequestMapping(value = "save")
//	public String save(Menu menu, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
//		if (!(UserUtils.getUser().getAdmin() || UserUtils.getUser().getSysAdmin())) {
//			addMessage(redirectAttributes, "越权操作，只有超级管理员才能添加或修改数据！");
//			return CoreSval.REDIRECT + adminPath + "/sys/role/?repage";
//		}
//		if (Global.isDemoMode()) {
//			addMessage(redirectAttributes, "演示模式，不允许操作！");
//			return CoreSval.REDIRECT + adminPath + "/sys/menu/";
//		}
//		if (!beanValidator(model, menu)) {
//			return form(menu, model, request);
//		}
//		try {
//			String arrUrl= request.getParameter("arrUrl");
//			if (arrUrl!=null&&!"".equals(arrUrl)) {
//				if (menu.getImgUrl()!=null) {
//					ftpService.del(menu.getImgUrl());
//				}
//					String img= FtpUtil.moveFile(FtpUtil.getftpClient(),arrUrl);
//					menu.setImgUrl(img);
//			}
//		} catch (Exception e) {
//			logger.error(ExceptionUtil.getStackTrace(e));
//		}
//		systemService.saveMenu(menu);
//		addMessage(redirectAttributes, "保存菜单'" + menu.getName() + "'成功");
//		return CoreSval.REDIRECT + adminPath + "/sys/menu/";
//	}
//
//	@RequiresPermissions("sys:menu:edit")
//	@RequestMapping(value = "delete")
//	public String delete(Menu menu, RedirectAttributes redirectAttributes) {
//		if (Global.isDemoMode()) {
//			addMessage(redirectAttributes, "演示模式，不允许操作！");
//			return CoreSval.REDIRECT + adminPath + "/sys/menu/";
//		}
////		if (Menu.isRoot(id)) {
////			addMessage(redirectAttributes, "删除菜单失败, 不允许删除顶级菜单或编号为空");
////		}else{
//			coreService.deleteMenu(menu);
//			addMessage(redirectAttributes, "删除菜单成功");
////		}
//		return CoreSval.REDIRECT + adminPath + "/sys/menu/";
//	}
//
//	@RequiresPermissions("user")
//	@RequestMapping(value = "tree")
//	public String tree() {
//		return "modules/sys/menuTree";
//	}
//
//	@RequiresPermissions("user")
//	@RequestMapping(value = "treePlus")
//	public String treePlus(String parentId,Model model,String href) {
////		if (!authorizeService.checkMenu(parentId)) {
////			return "redirect:/a/authorize";
////		}
//		List<Menu> list = Lists.newArrayList();
//		List<Menu> sourcelist = systemService.findAllMenu();
//		Menu.sortList(list, sourcelist, parentId, true);
//		//没有下级菜单
//		if (list.size()==0) {
//			model.addAttribute("msg","无权限访问该页面");
//			return "error/msg";
//		}
//		Menu firstMenu = systemService.getMenu(parentId);
//		List<Menu> secondMenus=Lists.newArrayList();
//		List<Menu> threeMenus=Lists.newArrayList();
//
//		for (Menu menu:list) {
//			if (menu.getParent().getId().equals(parentId)) {
//				if (StringUtil.equals("1",menu.getIsShow())) {
//					secondMenus.add(menu);
//				}
//			}else{
//				threeMenus.add(menu);
//			}
//		}
//		for (Menu menu2:secondMenus) {
//			List<Menu> children=Lists.newArrayList();
//			for (Menu menu3:threeMenus) {
//				if (menu3.getParent().getId().equals(menu2.getId())) {
//					if (StringUtil.equals("1",menu3.getIsShow())) {
//						children.add(menu3);
//					}
//
//				}
//			}
//			menu2.setChildren(children);
//		}
//
//		// 自定义流程菜单待办任务数
//		for (Menu menu : threeMenus) {
////			String hreff = menu.getHref();
////			if (StringUtils.isNotBlank(hreff) && hreff.contains("?actywId=") && hreff.contains("&gnodeId=")) {
////				int index1 = hreff.indexOf("?actywId=");
////				int index2 = hreff.indexOf("&gnodeId=");
////				String actywId = hreff.substring(index1 + 9, index2);
////				String gnodeId = hreff.substring(index2 + 9);
////				int count = actTaskService.todoCount(actywId, gnodeId);
////				menu.setTodoCount(count);
////			}
//
//            menu.setTodoCount(systemService.menuTodoCount(menu, actTaskService));
////            menu.setTodoCount(ProjectUtils.assessCount(menu));
//		}
//
//	    if (StringUtil.isNotEmpty(firstMenu.getHref()) && StringUtil.isNotEmpty((firstMenu.getHref()).replaceAll(" ", ""))) {
//	      model.addAttribute("hasHome", true);
//	    }else{
//	      model.addAttribute("hasHome", false);
//	    }
//	    model.addAttribute("firstMenu", firstMenu);
//		model.addAttribute("secondMenus",secondMenus);
//
//		model.addAttribute("href",href); //addBy张正，根据href跳转。如果href不为空，跳转到指定href
//		return SysIdx.SYSIDX_BACK_V4.getIdxUrl();
//	}
//
//	@RequestMapping(value = "/totoReflash/{actywId}", method = RequestMethod.GET)
//	@ResponseBody
//	public String totoReflash(@PathVariable String actywId) {
//		return actTaskService.flashTodoCount(actywId);
//	}
//
//	@RequiresPermissions("user")
//	@RequestMapping(value = "treeselect")
//	public String treeselect(String parentId, Model model) {
//		model.addAttribute("parentId", parentId);
//		return "modules/sys/menuTreeselect";
//	}
//
//	/**
//	 * 批量修改菜单排序
//	 */
//	@RequiresPermissions("sys:menu:edit")
//	@RequestMapping(value = "updateSort")
//	public String updateSort(String[] ids, Integer[] sorts, RedirectAttributes redirectAttributes) {
//		if (Global.isDemoMode()) {
//			addMessage(redirectAttributes, "演示模式，不允许操作！");
//			return CoreSval.REDIRECT + adminPath + "/sys/menu/";
//		}
//    	for (int i = 0; i < ids.length; i++) {
//    		Menu menu = new Menu(ids[i]);
//    		menu.setSort(sorts[i]);
//    		coreService.updateMenuSort(menu);
//    	}
//    	addMessage(redirectAttributes, "保存菜单排序成功!");
//		return CoreSval.REDIRECT + adminPath + "/sys/menu/";
//	}
//
//	@RequestMapping(value="ajaxUpdateSort", method = RequestMethod.POST, produces = "application/json")
//	@ResponseBody
//	public ApiResult ajaxUpdateSort(@RequestBody Menu menu, RedirectAttributes redirectAttributes) {
//		if (Global.isDemoMode()) {
//			return ApiResult.failed(ApiConst.STATUS_FAIL,ApiConst.getErrMsg(ApiConst.STATUS_FAIL)+"演示模式，不允许操作！");
//		}
//		for (int i = 0; i < menu.getMenuList().size(); i++) {
//			Menu menuIndex = menu.getMenuList().get(i);
//			coreService.updateMenuSort(menuIndex);
//		}
//		addMessage(redirectAttributes, "保存菜单排序成功!");
//		return ApiResult.success();
//	}
//
//	/**
//	 * isShowHide是否显示隐藏菜单
//	 * @param extId
//	 * @param response
//	 * @return
//	 */
//	@RequiresPermissions("user")
//	@ResponseBody
//	@RequestMapping(value = "treeData")
//	public List<Map<String, Object>> treeData(@RequestParam(required=false) String extId,@RequestParam(required=false) String isShowHide, HttpServletResponse response) {
//		List<Map<String, Object>> mapList = Lists.newArrayList();
//		List<Menu> list = systemService.findAllMenu();
//		for (int i=0; i<list.size(); i++) {
//			Menu e = list.get(i);
//			if (StringUtil.isBlank(extId) || (extId!=null && !extId.equals(e.getId()) && e.getParentIds().indexOf(","+extId+",")==-1)) {
//				if (isShowHide != null && isShowHide.equals("0") && e.getIsShow().equals("0")) {
//					continue;
//				}
//				Map<String, Object> map = Maps.newHashMap();
//				map.put("id", e.getId());
//				map.put("pId", e.getParentId());
//				map.put("name", e.getName());
//				mapList.add(map);
//			}
//		}
//		return mapList;
//	}
//
//    /**
//     * 保存所有节点与流程状态
//     */
//    @ResponseBody
//    @RequestMapping(value = "ajaxMenuCount")
//    public ApiTstatus<Long> ajaxMenuCount(@RequestParam(required=false) String id) {
//        if(StringUtil.isEmpty(id)){
//            return new ApiTstatus<Long>(false, "菜单不能为空！");
//        }
//		List<Role> roles = UserUtils.getUser().getRoleList();
//		if(StringUtil.checkEmpty(roles)){
//			return new ApiTstatus<Long>(false, "菜单不能为空！");
//		}
//        List<Menu> sourcelist = coreService.findRoleMenuByParentIdsLike(roles, id);
//		long total = 0;
//        for (Menu m : sourcelist) {
//            total += systemService.menuTodoCount(m, actTaskService);
//        }
//
//        if(total != 0){
//            return new ApiTstatus<Long>(true, "代办任务有" + total + "条！", total);
//        }
//        return new ApiTstatus<Long>(false, "代办任务有0条！");
//    }
//
//	@RequestMapping(value = "/navigation", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
//	@ResponseBody
//	public JSONObject navigation(String href) {
//		JSONObject js=new JSONObject();
//		if(href.substring(0,2).equals("/a")){
//			href=href.substring(2);
//		}
//		href=href.replace("&amp;","&");
//		Menu menu= coreService.getMenuByHref(href);
//		if(menu!=null){
//			js.put("secondName",menu.getName());
//			Menu parentMenu=menu.getParent();
//			if(parentMenu!=null){
//				js.put("firstName",parentMenu.getName());
//			}
//			js.put("ret","1");
//			return js;
//		}else {
//			js.put("ret", "0");
//			return js;
//		}
//	}

}
