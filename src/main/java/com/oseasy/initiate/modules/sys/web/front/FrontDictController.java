/**
 *
 */
package com.oseasy.initiate.modules.sys.web.front;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.Dict;
import com.oseasy.pcore.modules.sys.service.DictService;
import com.oseasy.pcore.modules.sys.utils.DictUtils;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 字典Controller

 * @version 2014-05-16
 */
@Controller
@RequestMapping(value = "${frontPath}/sys/dict")
public class FrontDictController extends BaseController {
	@Autowired
	private DictService dictService;

	@ModelAttribute
	public Dict get(@RequestParam(required=false) String id) {
		if (StringUtil.isNotBlank(id)) {
			return dictService.get(id);
		}else{
			return new Dict();
		}
	}

	@RequestMapping(value="getDictList", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public List<Dict> getDictList(String type){
		return DictUtils.getDictList(type);
	}

//	@RequestMapping(value="getCurJoinProjects", method = RequestMethod.GET, produces = "application/json")
//	@ResponseBody
//	public List<Dict> getCurJoinProjects(){
//		return ScoUtils.getPublishDictList();
//	}


}
