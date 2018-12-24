package com.oseasy.initiate.modules.seq.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oseasy.initiate.modules.seq.entity.Sequence;
import com.oseasy.initiate.modules.seq.service.SequenceService;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

import java.util.HashMap;
import java.util.Map;

/**
 * 序列表Controller.
 * @author zy
 * @version 2018-10-08
 */
@Controller
@RequestMapping(value = "${adminPath}/seq/sequence")
public class SequenceController extends BaseController {

	@Autowired
	private SequenceService entityService;

	@ModelAttribute
	public Sequence get(@RequestParam(required=false) String id) {
		Sequence entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new Sequence();
		}
		return entity;
	}

	@RequestMapping(value = {"list", ""})
	public String list(Sequence entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<Sequence> page = entityService.findPage(new Page<Sequence>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/seq/sequenceList";
	}

	@RequestMapping(value = "form")
	public String form(Sequence entity, Model model) {
		model.addAttribute("sequence", entity);
		return "modules/seq/sequenceForm";
	}


	@RequestMapping(value = "save")
	public String save(Sequence entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存序列表成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/seq/sequence/?repage";
	}


	@RequestMapping(value = "delete")
	public String delete(Sequence entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除序列表成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/seq/sequence/?repage";
	}

	@ResponseBody
   	@RequestMapping(value = "/addSeq", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
   	public String addSeq(Sequence seq,HttpServletRequest request, HttpServletResponse response, String name ) {
       	String seqName=request.getParameter("seqName");
       	String startNum=request.getParameter("startNum");
       	String updateNum=request.getParameter("updateNum");
       	Map<String,Object> param=new HashMap<String,Object>();
       	param.put("seqName",seqName);
       	param.put("startNum", startNum);
       	param.put("updateNum", updateNum);
		entityService.save(seq);
       	return "modules/test/testSeqPage";
   	}

//   	@ResponseBody
   	@RequestMapping(value = "/getNextSeq", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
   	public String getNextSeq(HttpServletRequest request, HttpServletResponse response, String name ) {
		String num=entityService.nextSequence(name);
       	return CoreSval.REDIRECT+Global.getAdminPath()+"/seq/sequence/?repage";
	}
}