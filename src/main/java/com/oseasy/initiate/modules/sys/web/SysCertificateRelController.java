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
import com.oseasy.initiate.common.utils.image.WaterRelType;
import com.oseasy.initiate.common.utils.image.WaterResType;
import com.oseasy.initiate.modules.sys.entity.SysCertificate;
import com.oseasy.initiate.modules.sys.entity.SysCertificateRel;
import com.oseasy.initiate.modules.sys.entity.SysCertificateRes;
import com.oseasy.initiate.modules.sys.service.SysCertificateRelService;
import com.oseasy.initiate.modules.sys.vo.SysSval.SysCertSval;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.Dict;
import com.oseasy.pcore.modules.sys.utils.DictUtils;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 系统证书资源关联Controller.
 * @author chenh
 * @version 2017-11-06
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sysCertificateRel")
public class SysCertificateRelController extends BaseController {

	@Autowired
	private SysCertificateRelService sysCertificateRelService;

	@ModelAttribute
	public SysCertificateRel get(@RequestParam(required=false) String id) {
		SysCertificateRel entity = null;
		if (StringUtil.isNotBlank(id)) {
			entity = sysCertificateRelService.get(id);
		}
		if (entity == null) {
			entity = new SysCertificateRel();
		}
		return entity;
	}

	@RequiresPermissions("sys:sysCertificateRel:view")
	@RequestMapping(value = {"list", ""})
	public String list(SysCertificateRel sysCertificateRel, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<SysCertificateRel> page = sysCertificateRelService.findPage(new Page<SysCertificateRel>(request, response), sysCertificateRel);
    model.addAttribute("wresType", WaterResType.values());
    model.addAttribute("wrelType", WaterRelType.values());
		model.addAttribute("page", page);
		return "modules/sys/sysCertificateRelList";
	}

	@RequiresPermissions("sys:sysCertificateRel:view")
	@RequestMapping(value = "form")
	public String form(SysCertificateRel sysCertificateRel, Model model) {
    model.addAttribute("wresType", WaterResType.values());
    model.addAttribute("wrelType", WaterRelType.values());
		model.addAttribute("sysCertificateRel", sysCertificateRel);
		return "modules/sys/sysCertificateRelForm";
	}

	@RequiresPermissions("sys:sysCertificateRel:edit")
	@RequestMapping(value = "save")
	public String save(SysCertificateRel sysCertificateRel, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sysCertificateRel)) {
			return form(sysCertificateRel, model);
		}
		sysCertificateRelService.save(sysCertificateRel);
		addMessage(redirectAttributes, "保存系统证书资源关联成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/sys/sysCertificateRel/?repage";
	}

	@RequiresPermissions("sys:sysCertificateRel:edit")
	@RequestMapping(value = "delete")
	public String delete(SysCertificateRel sysCertificateRel, RedirectAttributes redirectAttributes) {
		sysCertificateRelService.delete(sysCertificateRel);
		addMessage(redirectAttributes, "删除系统证书资源关联成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/sys/sysCertificateRel/?repage";
	}

  /**
   * 获取所有的证书.
   * @param type 类型
   * @param hasUse 使用中
   * @param response
   * @return
   */
  @ResponseBody
  @RequestMapping(value = "treeCert")
  public List<Map<String, Object>> treeCert(@RequestParam(required=false) String type, @RequestParam(required=false) Boolean hasUse, HttpServletResponse response) {
    List<Map<String, Object>> mapList = Lists.newArrayList();
    SysCertificate psysCert = new SysCertificate();
    if (StringUtil.isNotEmpty(type)) {
      psysCert.setType(type);
    }
    if (hasUse != null) {
      psysCert.setHasUse(hasUse);
    }

    List<SysCertificateRel> list = sysCertificateRelService.findList(new SysCertificateRel(psysCert));
    List<Dict> dictlist = DictUtils.getDictList(SysCertSval.SYS_CERTIFICATE_TYPE);
    for (Dict dict : dictlist) {
      Map<String, Object> dictMap = Maps.newHashMap();
      dictMap.put("id", dict.getValue());
      dictMap.put("pId", dict.getParentId());
      dictMap.put("name", dict.getLabel());
      mapList.add(dictMap);
      for (SysCertificateRel sysCertificateRel : list) {
        Map<String, Object> certRelMap = Maps.newHashMap();
        SysCertificate cert = sysCertificateRel.getSysCert();
        if ((cert == null) || StringUtil.isEmpty(cert.getType())) {
          continue;
        }

        if ((dict.getValue()).equals(cert.getType())) {
          certRelMap.put("id", cert.getId());
          certRelMap.put("pId", cert.getType());
          certRelMap.put("name", cert.getName());
          mapList.add(certRelMap);
        }
      }
    }
    return mapList;
  }

  /**
   * 获取所有的证书资源.
   * @param type 类型
   * @param hasUse 使用中
   * @param response
   * @return
   */
  @ResponseBody
  @RequestMapping(value = "treeRes")
  public List<Map<String, Object>> treeRes(@RequestParam(required=false) String ctype, @RequestParam(required=false) Boolean hasUse, @RequestParam(required=false) String rtype, @RequestParam(required=false) String isShow, HttpServletResponse response) {
    List<Map<String, Object>> mapList = Lists.newArrayList();
    SysCertificate psysCert = new SysCertificate();
    if (StringUtil.isNotEmpty(ctype)) {
      psysCert.setType(ctype);
    }
    if (hasUse != null) {
      psysCert.setHasUse(hasUse);
    }

    SysCertificateRes psysCertRes = new SysCertificateRes();
    if (StringUtil.isNotEmpty(rtype)) {
      psysCertRes.setType(rtype);
    }
    if (StringUtil.isNotEmpty(isShow)) {
      psysCertRes.setIsShow(isShow);
    }

    List<SysCertificateRel> list = sysCertificateRelService.findList(new SysCertificateRel(psysCert, psysCertRes));
    List<Dict> dictlist = DictUtils.getDictList(SysCertSval.SYS_CERTIFICATE_TYPE);
    for (Dict dict : dictlist) {
      Map<String, Object> dictMap = Maps.newHashMap();
      dictMap.put("id", dict.getValue());
      dictMap.put("pId", dict.getParentId());
      dictMap.put("name", dict.getLabel());
      mapList.add(dictMap);
      for (SysCertificateRel sysCertificateRel : list) {
        Map<String, Object> certRelMap = Maps.newHashMap();
        SysCertificate cert = sysCertificateRel.getSysCert();
        if ((cert == null) || StringUtil.isEmpty(cert.getType())) {
          continue;
        }

        if ((dict.getValue()).equals(cert.getType())) {
          certRelMap.put("id", cert.getId());
          certRelMap.put("pId", cert.getType());
          certRelMap.put("name", cert.getName());
          mapList.add(certRelMap);
        }
      }
    }
    return mapList;
  }
}