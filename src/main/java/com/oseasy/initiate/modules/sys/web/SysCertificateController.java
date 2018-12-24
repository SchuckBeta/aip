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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.oseasy.initiate.modules.sys.entity.SysCertificate;
import com.oseasy.initiate.modules.sys.service.SysCertificateService;
import com.oseasy.initiate.modules.sys.vo.SysSval.SysCertSval;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.config.ApiTstatus;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.Dict;
import com.oseasy.pcore.modules.sys.utils.DictUtils;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 系统证书表Controller.
 * @author chenh
 * @version 2017-10-23
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sysCertificate")
public class SysCertificateController extends BaseController {

	@Autowired
	private SysCertificateService sysCertificateService;

	@ModelAttribute
	public SysCertificate get(@RequestParam(required=false) String id) {
		SysCertificate entity = null;
		if (StringUtil.isNotBlank(id)) {
			entity = sysCertificateService.get(id);
		}
		if (entity == null) {
			entity = new SysCertificate();
		}
		return entity;
	}

	@RequiresPermissions("sys:sysCertificate:view")
	@RequestMapping(value = {"list", ""})
	public String list(SysCertificate sysCertificate, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<SysCertificate> page = sysCertificateService.findPage(new Page<SysCertificate>(request, response), sysCertificate);
		model.addAttribute("page", page);
		return "modules/sys/sysCertificateList";
	}

	@RequiresPermissions("sys:sysCertificate:view")
	@RequestMapping(value = "form")
	public String form(SysCertificate sysCertificate, Model model) {
		model.addAttribute("sysCertificate", sysCertificate);
    return "modules/sys/sysCertificateForm";
	}

	@RequiresPermissions("sys:sysCertificate:view")
	@RequestMapping(value = "view")
	public String view(SysCertificate sysCertificate, Model model) {
	  model.addAttribute("sysCertificate", sysCertificate);
	  return "modules/sys/sysCertificateView";
	}

	@RequiresPermissions("sys:sysCertificate:view")
	@RequestMapping(value = "design")
	public String design(SysCertificate sysCertificate, Model model) {
	  model.addAttribute("sysCertificate", sysCertificate);
	  return "modules/sys/sysCertificateDesign";
	}

	@RequiresPermissions("sys:sysCertificate:edit")
	@RequestMapping(value = "save")
	public String save(SysCertificate sysCertificate, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sysCertificate)) {
			return form(sysCertificate, model);
		}

    sysCertificateService.save(sysCertificate);
    addMessage(redirectAttributes, "保存系统证书表成功");
//		if (sysCertificate.getIsNewRecord()) {
//	    sysCertificateService.save(sysCertificate);
//	    addMessage(redirectAttributes, "保存系统证书表成功");
//		}else{
//  		if ((sysCertificate.getZsfile() == null) || (sysCertificate.getWaterfile() == null)) {
//  	    addMessage(redirectAttributes, "系统证书文件和证书水印文件不能为空!");
//        return form(sysCertificate, model);
//  		}
//      sysAttachmentService.saveByVo(sysCertificate.getZsfile(), sysCertificate.getId(), FileTypeEnum.S10000, FileStepEnum.S10000);
//      sysAttachmentService.saveByVo(sysCertificate.getWaterfile(), sysCertificate.getId(), FileTypeEnum.S10000, FileStepEnum.S10001);
//      addMessage(redirectAttributes, "更新系统证书表成功");
//    }
		return CoreSval.REDIRECT+Global.getAdminPath()+"/sys/sysCertificate/?repage";
	}

	@RequiresPermissions("sys:sysCertificate:edit")
	@RequestMapping(value = "delete")
	public String delete(SysCertificate sysCertificate, RedirectAttributes redirectAttributes) {
		sysCertificateService.delete(sysCertificate);
		addMessage(redirectAttributes, "删除系统证书表成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/sys/sysCertificate/?repage";
	}

  /**
   * 证书应用中.
   * 每个机构的每个证书类型只能有一个在使用中.
   * @param sysCertificate 实体
   * @param model 模型
   * @param redirectAttributes 重定向
   * @return String
   */
  @RequiresPermissions("sys:sysCertificate:edit")
  @RequestMapping(value = "ajaxUse")
  public String ajaxUse(SysCertificate sysCertificate, Model model, HttpServletRequest request, RedirectAttributes redirectAttributes) {
    if (StringUtil.isNotEmpty(sysCertificate.getId()) && (sysCertificate.getHasUse() != null)) {
      SysCertificate newSysCertificate = sysCertificateService.get(sysCertificate.getId());

      /**
       * 修改使用中的证书,如果为true则修改其他的为false.
       */
		if (sysCertificate.getHasUse()) {
			SysCertificate querySysCertificate = new SysCertificate();
			querySysCertificate.setHasUse(true);
			querySysCertificate.setType(newSysCertificate.getType());
			querySysCertificate.setOffice(newSysCertificate.getOffice());
			List<SysCertificate> sysCertificates = sysCertificateService.findList(querySysCertificate);
			if ((sysCertificates != null) && (sysCertificates.size() > 0)) {
				sysCertificateService.updateHasUsePL(sysCertificates, false);
			}
		}

      newSysCertificate.setHasUse(sysCertificate.getHasUse());
      sysCertificateService.save(newSysCertificate);
      addMessage(redirectAttributes, "更新成功");
    }else{
      addMessage(redirectAttributes, "参数未定义，更新失败");
    }
    return CoreSval.REDIRECT + Global.getAdminPath() + "/sys/sysCertificate/?repage";
  }


  /**
   * 根据证书获取证书资源列表.
   * @param id 证书ID
   * @param type 证书类型
   * @param hasUse 证书使用状态
   * @return ActYwApiStatus
   */
  @ResponseBody
  @RequestMapping(value = "/ajaxCertRes/{id}")
  public ApiTstatus<SysCertificate> ajaxCertRes(@PathVariable String id, @RequestParam(required=false) String type, @RequestParam(required=false) Boolean hasUse) {
    ApiTstatus<SysCertificate> ApiStatus = new ApiTstatus<SysCertificate>();

    SysCertificate psysCert = new SysCertificate();
    psysCert.setId(id);
    if (StringUtil.isNotEmpty(type)) {
      psysCert.setType(type);
    }

    if (hasUse != null) {
      psysCert.setHasUse(hasUse);
    }

    /**
     * 查询证书.
     **/
    SysCertificate sysCertificate = sysCertificateService.get(psysCert);
    ApiStatus.setDatas(sysCertificate);
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

    List<SysCertificate> list = sysCertificateService.findList(psysCert);
    List<Dict> dictlist = DictUtils.getDictList(SysCertSval.SYS_CERTIFICATE_TYPE);
    for (Dict dict : dictlist) {
      Map<String, Object> dictMap = Maps.newHashMap();
      dictMap.put("id", dict.getValue());
      dictMap.put("pId", dict.getParentId());
      dictMap.put("name", dict.getLabel());
      mapList.add(dictMap);
      for (SysCertificate cert : list) {
        Map<String, Object> certRelMap = Maps.newHashMap();
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