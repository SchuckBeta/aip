package com.oseasy.initiate.modules.sys.web;

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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.oseasy.initiate.common.config.SysJkey;
import com.oseasy.initiate.modules.sys.entity.SysCertificate;
import com.oseasy.initiate.modules.sys.entity.SysCertificateIssued;
import com.oseasy.initiate.modules.sys.entity.SysCertificateRel;
import com.oseasy.initiate.modules.sys.service.SysCertificateIssuedService;
import com.oseasy.initiate.modules.sys.vo.SysCertificateIsstype;
import com.oseasy.initiate.modules.sys.vo.SysSval.SysCertSval;
import com.oseasy.pact.modules.actyw.entity.ActYw;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.config.ApiTstatus;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.Dict;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.pcore.modules.sys.utils.DictUtils;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 系统证书执行记录Controller.
 * @author chenh
 * @version 2017-11-07
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sysCertificateIssued")
public class SysCertificateIssuedController extends BaseController {

	@Autowired
	private SysCertificateIssuedService sysCertificateIssuedService;

	@ModelAttribute
	public SysCertificateIssued get(@RequestParam(required=false) String id) {
		SysCertificateIssued entity = null;
		if (StringUtil.isNotBlank(id)) {
			entity = sysCertificateIssuedService.get(id);
		}
		if (entity == null) {
			entity = new SysCertificateIssued();
		}
		return entity;
	}

	@RequiresPermissions("sys:sysCertificateIssued:view")
	@RequestMapping(value = {"list", ""})
	public String list(SysCertificateIssued sysCertificateIssued, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<SysCertificateIssued> page = sysCertificateIssuedService.findPageByCert(new Page<SysCertificateIssued>(request, response), sysCertificateIssued);
		model.addAttribute("page", page);
    model.addAttribute("sysCertIsstypes", SysCertificateIsstype.values());
		return "modules/sys/sysCertificateIssuedList";
	}

	@RequiresPermissions("sys:sysCertificateIssued:view")
	@RequestMapping(value = {"issuedList"})
	public String issuedList(SysCertificateIssued sysCertificateIssued, HttpServletRequest request, HttpServletResponse response, Model model) {
	  Page<SysCertificateIssued> page = sysCertificateIssuedService.findPageByIssued(new Page<SysCertificateIssued>(request, response), sysCertificateIssued);
	  model.addAttribute("page", page);
    model.addAttribute("sysCertIsstypes", SysCertificateIsstype.values());
	  return "modules/sys/sysCertificateIssuedIssuedList";
	}

	@RequiresPermissions("sys:sysCertificateIssued:view")
	@RequestMapping(value = {"acceptList"})
	public String acceptList(SysCertificateIssued sysCertificateIssued, HttpServletRequest request, HttpServletResponse response, Model model) {
	  Page<SysCertificateIssued> page = sysCertificateIssuedService.findPageByAccept(new Page<SysCertificateIssued>(request, response), sysCertificateIssued);
	  model.addAttribute("page", page);
    model.addAttribute("sysCertIsstypes", SysCertificateIsstype.values());
	  return "modules/sys/sysCertificateIssuedAcceptList";
	}

	@RequiresPermissions("sys:sysCertificateIssued:view")
	@RequestMapping(value = {"ywList"})
	public String ywList(SysCertificateIssued sysCertificateIssued, HttpServletRequest request, HttpServletResponse response, Model model) {
	  Page<SysCertificateIssued> page = sysCertificateIssuedService.findPageByYw(new Page<SysCertificateIssued>(request, response), sysCertificateIssued);
	  model.addAttribute("page", page);
    model.addAttribute("sysCertIsstypes", SysCertificateIsstype.values());
	  return "modules/sys/sysCertificateIssuedYwList";
	}

	@RequiresPermissions("sys:sysCertificateIssued:view")
	@RequestMapping(value = "form")
	public String form(SysCertificateIssued sysCertificateIssued, Model model) {
		model.addAttribute("sysCertificateIssued", sysCertificateIssued);
		return "modules/sys/sysCertificateIssuedForm";
	}

	@RequiresPermissions("sys:sysCertificateIssued:edit")
	@RequestMapping(value = "save")
	public String save(SysCertificateIssued sysCertificateIssued, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sysCertificateIssued)) {
			return form(sysCertificateIssued, model);
		}
		sysCertificateIssuedService.save(sysCertificateIssued);
		addMessage(redirectAttributes, "保存系统证书执行记录成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/sys/sysCertificateIssued/?repage";
	}

	@RequiresPermissions("sys:sysCertificateIssued:edit")
	@RequestMapping(value = "delete")
	public String delete(SysCertificateIssued sysCertificateIssued, RedirectAttributes redirectAttributes) {
		sysCertificateIssuedService.delete(sysCertificateIssued);
		addMessage(redirectAttributes, "删除系统证书执行记录成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/sys/sysCertificateIssued/?repage";
	}

  /**
   * 根据证书获取证书列表.
   * @param userId 用户ID
   * @param issuedId 颁布用户ID
   * @param certId 证书ID
   * @param ywId 业务ID
   * @param type 记录类型
   * @return ActYwApiStatus
   */
  @ResponseBody
  @RequestMapping(value = "/ajaxCerts/{certId}")
  public ApiTstatus<Map<String, Object>> ajaxCerts(@PathVariable String certId, @RequestParam(required=false) String issuedId, @RequestParam(required=false) String userId, @RequestParam(required=false) String ywId, @RequestParam(required=false) String type) {
    ApiTstatus<Map<String, Object>> ApiStatus = new ApiTstatus<Map<String, Object>>();
    Map<String, Object> result = new HashMap<String, Object>();

    SysCertificateIssued psysCertificateIssued = new SysCertificateIssued();
    psysCertificateIssued.setSysCert(new SysCertificate(certId));
    if (StringUtil.isNotEmpty(issuedId)) {
      psysCertificateIssued.setIssuedBy(new User(issuedId));
    }
    if (StringUtil.isNotEmpty(userId)) {
      psysCertificateIssued.setAcceptBy(new User(userId));
    }
    if (StringUtil.isNotEmpty(ywId)) {
      psysCertificateIssued.setActYw(new ActYw(ywId));
    }
    if (StringUtil.isNotEmpty(type)) {
      psysCertificateIssued.setType(type);
    }

    /**
     * 查询根节点.
     **/
    List<SysCertificateIssued> lists = sysCertificateIssuedService.findListByCert(psysCertificateIssued);

    if ((lists == null) || (lists.size() <= 0)) {
      lists = Lists.newArrayList();
      ApiStatus.setMsg("没有数据！");
    }

    result.put(SysJkey.JK_LISTS, lists);
    ApiStatus.setDatas(result);
    return ApiStatus;
  }

  /**
   * 根据用户获取证书记录列表.
   * @param userId 用户ID
   * @param issuedId 颁布用户ID
   * @param certId 证书ID
   * @param ywId 业务ID
   * @param type 记录类型
   * @return ActYwApiStatus
   */
  @ResponseBody
  @RequestMapping(value = "/ajaxCertsByAuser/{userId}")
  public ApiTstatus<Map<String, Object>> ajaxCertsByAuser(@PathVariable String userId, @RequestParam(required=false) String issuedId, @RequestParam(required=false) String certId, @RequestParam(required=false) String ywId, @RequestParam(required=false) String type) {
    ApiTstatus<Map<String, Object>> ApiStatus = new ApiTstatus<Map<String, Object>>();
    Map<String, Object> result = new HashMap<String, Object>();

    SysCertificateIssued psysCertificateIssued = new SysCertificateIssued();
    psysCertificateIssued.setAcceptBy(new User(userId));
    if (StringUtil.isNotEmpty(issuedId)) {
      psysCertificateIssued.setIssuedBy(new User(issuedId));
    }
    if (StringUtil.isNotEmpty(certId)) {
      psysCertificateIssued.setSysCert(new SysCertificate(certId));
    }
    if (StringUtil.isNotEmpty(ywId)) {
      psysCertificateIssued.setActYw(new ActYw(ywId));
    }
    if (StringUtil.isNotEmpty(type)) {
      psysCertificateIssued.setType(type);
    }

    /**
     * 查询根节点.
     **/
    List<SysCertificateIssued> lists = sysCertificateIssuedService.findListByAccept(psysCertificateIssued);

    if ((lists == null) || (lists.size() <= 0)) {
      lists = Lists.newArrayList();
      ApiStatus.setMsg("没有数据！");
    }

    result.put(SysJkey.JK_LISTS, lists);
    ApiStatus.setDatas(result);
    return ApiStatus;
  }

  /**
   * 根据颁布人获取证书记录列表.
   * @param userId 用户ID
   * @param issuedId 颁布用户ID
   * @param certId 证书ID
   * @param ywId 业务ID
   * @param type 记录类型
   * @return ActYwApiStatus
   */
  @ResponseBody
  @RequestMapping(value = "/ajaxCertsByIuser/{issuedId}")
  public ApiTstatus<Map<String, Object>> ajaxCertsByIuser(@PathVariable String issuedId, @RequestParam(required=false) String userId, @RequestParam(required=false) String certId, @RequestParam(required=false) String ywId, @RequestParam(required=false) String type) {
    ApiTstatus<Map<String, Object>> ApiStatus = new ApiTstatus<Map<String, Object>>();
    Map<String, Object> result = new HashMap<String, Object>();

    SysCertificateIssued psysCertificateIssued = new SysCertificateIssued();
    psysCertificateIssued.setIssuedBy(new User(issuedId));
    if (StringUtil.isNotEmpty(userId)) {
      psysCertificateIssued.setAcceptBy(new User(userId));
    }
    if (StringUtil.isNotEmpty(certId)) {
      psysCertificateIssued.setSysCert(new SysCertificate(certId));
    }
    if (StringUtil.isNotEmpty(ywId)) {
      psysCertificateIssued.setActYw(new ActYw(ywId));
    }
    if (StringUtil.isNotEmpty(type)) {
      psysCertificateIssued.setType(type);
    }

    /**
     * 查询根节点.
     **/
    List<SysCertificateIssued> lists = sysCertificateIssuedService.findListByIssued(psysCertificateIssued);

    if ((lists == null) || (lists.size() <= 0)) {
      lists = Lists.newArrayList();
      ApiStatus.setMsg("没有数据！");
    }

    result.put(SysJkey.JK_LISTS, lists);
    ApiStatus.setDatas(result);
    return ApiStatus;
  }

  /**
   * 根据业务获取证书记录列表.
   * @param userId 用户ID
   * @param issuedId 颁布用户ID
   * @param certId 证书ID
   * @param ywId 业务ID
   * @param type 记录类型
   * @return ActYwApiStatus
   */
  @ResponseBody
  @RequestMapping(value = "/ajaxCertsByYw/{ywId}")
  public ApiTstatus<Map<String, Object>> ajaxCertsByYw(@PathVariable String ywId, @RequestParam(required=false) String userId, @RequestParam(required=false) String certId, @RequestParam(required=false) String issuedId, @RequestParam(required=false) String type) {
    ApiTstatus<Map<String, Object>> ApiStatus = new ApiTstatus<Map<String, Object>>();
    Map<String, Object> result = new HashMap<String, Object>();

    SysCertificateIssued psysCertificateIssued = new SysCertificateIssued();
    psysCertificateIssued.setActYw(new ActYw(ywId));
    if (StringUtil.isNotEmpty(userId)) {
      psysCertificateIssued.setAcceptBy(new User(userId));
    }
    if (StringUtil.isNotEmpty(certId)) {
      psysCertificateIssued.setSysCert(new SysCertificate(certId));
    }
    if (StringUtil.isNotEmpty(issuedId)) {
      psysCertificateIssued.setIssuedBy(new User(issuedId));
    }
    if (StringUtil.isNotEmpty(type)) {
      psysCertificateIssued.setType(type);
    }

    /**
     * 查询根节点.
     **/
    List<SysCertificateIssued> lists = sysCertificateIssuedService.findListByYw(psysCertificateIssued);

    if ((lists == null) || (lists.size() <= 0)) {
      lists = Lists.newArrayList();
      ApiStatus.setMsg("没有数据！");
    }

    result.put(SysJkey.JK_LISTS, lists);
    ApiStatus.setDatas(result);
    return ApiStatus;
  }

  /**
   * 获取所有的证书.
   * @param type 类型
   * @param hasUse 使用中
   * @param response
   * @return
   */
  @ResponseBody
  @RequestMapping(value = "tree")
  public List<Map<String, Object>> tree(@RequestParam(required=false) String type, @RequestParam(required=false) Boolean hasUse, HttpServletResponse response) {
    List<Map<String, Object>> mapList = Lists.newArrayList();
    SysCertificate psysCert = new SysCertificate();
    if (StringUtil.isNotEmpty(type)) {
      psysCert.setType(type);
    }
    if (hasUse != null) {
      psysCert.setHasUse(hasUse);
    }

    List<SysCertificateIssued> list = sysCertificateIssuedService.findList(new SysCertificateIssued(new SysCertificateRel(psysCert)));
    List<Dict> dictlist = DictUtils.getDictList(SysCertSval.SYS_CERTIFICATE_TYPE);
    for (Dict dict : dictlist) {
      Map<String, Object> dictMap = Maps.newHashMap();
      dictMap.put("id", dict.getValue());
      dictMap.put("pId", dict.getParentId());
      dictMap.put("name", dict.getLabel());
      mapList.add(dictMap);
      for (SysCertificateIssued sysCertIss : list) {
        Map<String, Object> certRelMap = Maps.newHashMap();
        SysCertificateRel certRel = sysCertIss.getSysCertRel();
        if ((certRel == null)) {
          continue;
        }

        SysCertificate cert = certRel.getSysCert();
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