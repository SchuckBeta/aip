/**
 *
 */
package com.oseasy.pact.modules.act.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oseasy.pact.modules.act.service.ActModelService;
import com.oseasy.pact.modules.act.vo.ActApiStatus;
import com.oseasy.pact.modules.actyw.entity.ActYw;
import com.oseasy.pact.modules.actyw.service.ActYwService;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 流程模型相关Controller


 */
@Controller
@RequestMapping(value = "${adminPath}/act/model")
public class ActModelController extends BaseController {

  @Autowired
  private ActModelService actModelService;
  @Autowired
  private ActYwService actYwService;

	/**
	 * 流程模型列表
	 */
	@RequiresPermissions("act:model:edit")
	@RequestMapping(value = { "list", "" })
	public String modelList(String category, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<org.activiti.engine.repository.Model> page = actModelService.modelList(new Page<org.activiti.engine.repository.Model>(request, response), category);
		model.addAttribute(Page.PAGE, page);
		model.addAttribute("category", category);

		return "modules/act/actModelList";
	}

	/**
	 * 创建模型
	 */
	@RequiresPermissions("act:model:edit")
	@RequestMapping(value = "create", method = RequestMethod.GET)
	public String create(Model model) {
		return "modules/act/actModelCreate";
	}

	/**
	 * 创建模型
	 */
	@RequiresPermissions("act:model:edit")
	@RequestMapping(value = "create", method = RequestMethod.POST)
	public void create(String name, String key, String description, String category,
			HttpServletRequest request, HttpServletResponse response) {
		try {
			org.activiti.engine.repository.Model modelData = actModelService.create(name, key, description, category);
			response.sendRedirect(request.getContextPath() + "/act/process-editor/modeler.jsp?modelId=" + modelData.getId());
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("创建模型失败：", e);
		}
	}

	/**
	 * 根据Model部署流程
	 */
	@RequiresPermissions("act:model:edit")
	@RequestMapping(value = "deploy")
	public String deploy(String id, Boolean isUpdateYw, RedirectAttributes redirectAttributes) {
	  ActApiStatus result = actModelService.deploy(id);
    /**
     * 流程发布，流程ID回填到业务表.
     */
    if ((isUpdateYw == null)) {
      isUpdateYw = false;
    }

    if (isUpdateYw && (StringUtil.isNotEmpty(result.getKey()))) {
      List<ActYw> actYws = actYwService.getByKeyss(ActYw.pkeySplitKeyss(result.getKey()));
      if ((actYws != null) && (actYws.size() == 1)) {
        ActYw actYw = actYws.get(0);
        actYw.setFlowId(result.getId());
        actYw.setDeploymentId(result.getDeploymentId());
        actYwService.save(actYw);
      }else{
        result.setStatus(false);
        result.setMsg("业务不存在，流程部署执行回滚！");
      }
    }

		redirectAttributes.addFlashAttribute("actApiStatus", result);
		redirectAttributes.addFlashAttribute("message", result.getMsg());
		return CoreSval.REDIRECT + adminPath + "/act/process";
	}

	/**
	 * 导出model的xml文件
	 */
	@RequiresPermissions("act:model:edit")
	@RequestMapping(value = "export")
	public void export(String id, HttpServletResponse response) {
		actModelService.export(id, response);
	}

	/**
	 * 更新Model分类
	 */
	@RequiresPermissions("act:model:edit")
	@RequestMapping(value = "updateCategory")
	public String updateCategory(String id, String category, RedirectAttributes redirectAttributes) {
		actModelService.updateCategory(id, category);
		redirectAttributes.addFlashAttribute("message", "设置成功，模块ID=" + id);
		return CoreSval.REDIRECT + adminPath + "/act/model";
	}

	/**
	 * 删除Model
	 * @param id
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("act:model:edit")
	@RequestMapping(value = "delete")
	public String delete(String id, RedirectAttributes redirectAttributes) {
		actModelService.delete(id);
		redirectAttributes.addFlashAttribute("message", "删除成功，模型ID=" + id);
		return CoreSval.REDIRECT + adminPath + "/act/model";
	}
}
