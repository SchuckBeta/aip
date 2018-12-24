package com.oseasy.initiate.modules.sys.web;

import java.util.List;
import java.util.Map;

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

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.oseasy.initiate.common.utils.image.WaterResFileType;
import com.oseasy.initiate.modules.sys.entity.SysCertificateRes;
import com.oseasy.initiate.modules.sys.service.SysCertificateResService;
import com.oseasy.pcore.common.config.CoreIds;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 系统证书资源Controller.
 * @author chenh
 * @version 2017-11-06
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sysCertificateRes")
public class SysCertificateResController extends BaseController {

	@Autowired
	private SysCertificateResService sysCertificateResService;

	@ModelAttribute
	public SysCertificateRes get(@RequestParam(required=false) String id) {
		SysCertificateRes entity = null;
		if (StringUtil.isNotBlank(id)) {
			entity = sysCertificateResService.get(id);
		}
		if (entity == null) {
			entity = new SysCertificateRes();
		}
		return entity;
	}

	@RequiresPermissions("sys:sysCertificateRes:view")
	@RequestMapping(value = {"list", ""})
	public String list(SysCertificateRes sysCertificateRes, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<SysCertificateRes> page = sysCertificateResService.findPage(new Page<SysCertificateRes>(request, response), sysCertificateRes);
    model.addAttribute("wresFtype", WaterResFileType.values());
		model.addAttribute("page", page);
		return "modules/sys/sysCertificateResList";
	}

	@RequiresPermissions("sys:sysCertificateRes:view")
	@RequestMapping(value = "form")
	public String form(SysCertificateRes sysCertificateRes, Model model) {
		model.addAttribute("sysCertificateRes", sysCertificateRes);
		model.addAttribute("wresFtype", WaterResFileType.values());
		return "modules/sys/sysCertificateResForm";
	}

	@RequiresPermissions("sys:sysCertificateRes:edit")
	@RequestMapping(value = "save")
	public String save(SysCertificateRes sysCertificateRes, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sysCertificateRes)) {
			return form(sysCertificateRes, model);
		}
		sysCertificateResService.save(sysCertificateRes);
		addMessage(redirectAttributes, "保存系统证书资源成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/sys/sysCertificateRes/?repage";
	}

	@RequiresPermissions("sys:sysCertificateRes:edit")
	@RequestMapping(value = "delete")
	public String delete(SysCertificateRes sysCertificateRes, RedirectAttributes redirectAttributes) {
		sysCertificateResService.delete(sysCertificateRes);
		addMessage(redirectAttributes, "删除系统证书资源成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/sys/sysCertificateRes/?repage";
	}

  /**
   * 获取所有的资源.
   * @param type 类型
   * @param hasUse 使用中
   * @param response
   * @return
   */
  @ResponseBody
  @RequestMapping(value = "tree")
  public List<Map<String, Object>> tree(@RequestParam(required=false) String type, @RequestParam(required=false) String isShow, HttpServletResponse response) {
    List<Map<String, Object>> mapList = Lists.newArrayList();
    SysCertificateRes psysCertRes = new SysCertificateRes();
    if (StringUtil.isNotEmpty(type)) {
      psysCertRes.setType(type);
    }
    if (StringUtil.isNotEmpty(isShow)) {
      psysCertRes.setIsShow(isShow);
    }

    List<SysCertificateRes> list = sysCertificateResService.findList(psysCertRes);
    List<WaterResFileType> wlist = WaterResFileType.getList();
    for (WaterResFileType wtype : wlist) {
      Map<String, Object> dictMap = Maps.newHashMap();
      dictMap.put("id", wtype.getKey());
      dictMap.put("pId", CoreIds.SYS_TREE_PROOT.getId());
      dictMap.put("name", wtype.getName());
      mapList.add(dictMap);

      for (SysCertificateRes sysCertRes : list) {
        if ((wtype.getKey()).equals(sysCertRes.getType())) {
          Map<String, Object> certResMap = Maps.newHashMap();
          certResMap.put("id", sysCertRes.getId());
          certResMap.put("pId", sysCertRes.getType());
          certResMap.put("name", sysCertRes.getName());
          mapList.add(certResMap);
        }
      }
    }
    return mapList;
  }
}