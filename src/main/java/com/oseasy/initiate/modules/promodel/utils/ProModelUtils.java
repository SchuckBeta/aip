/**
 *
 */
package com.oseasy.initiate.modules.promodel.utils;

import com.oseasy.initiate.modules.proproject.entity.ProProject;
import com.oseasy.initiate.modules.proproject.service.ProProjectService;
import com.oseasy.pact.modules.act.service.ActTaskService;
import com.oseasy.pact.modules.actyw.entity.ActYwGnode;
import com.oseasy.pcore.common.utils.SpringContextHolder;
import com.oseasy.pcore.modules.sys.utils.DictUtils;
import com.oseasy.initiate.modules.promodel.dao.ProModelDao;
import com.oseasy.initiate.modules.promodel.entity.ProModel;

/**
 * 内容管理工具类


 */
public class ProModelUtils {
  	private static ProModelDao proModelDao = SpringContextHolder.getBean(ProModelDao.class);
	private static ProProjectService proProjectService = SpringContextHolder.getBean(ProProjectService.class);
	private static ActTaskService actTaskService = SpringContextHolder.getBean(ActTaskService.class);
  	public static ProModel getProModelById(String id) {
    return proModelDao.get(id);
  }


	/**根据模板类型获取大赛结果html代码*/
	public static String getGrateSelect(String proProjectId) {
		ProProject proProject=proProjectService.get(proProjectId);
		String html="";
		if (proProject!=null) {
			String finalStatus=proProject.getFinalStatus();
			if (finalStatus!=null) {
				String[] finalStatuss=finalStatus.split(",");
				if (finalStatuss.length>0) {
					for(int i=0;i<finalStatuss.length;i++) {
						html +="<option value='"+finalStatuss[i]+"'>"+
								DictUtils.getDictLabel(finalStatuss[i],"competition_college_prise","")
								+"</option>";
					}
				}
			}
		}

		return html;
	}

	/**根据模板类型获取大赛级别html代码*/
	public static String getLevelSelect(String proProjectId) {
		ProProject proProject=proProjectService.get(proProjectId);
		String html="";
		if (proProject!=null) {
			String level=proProject.getLevel();
			if (level!=null) {
				String[] levels=level.split(",");
				if (levels.length>0) {
					for(int i=0;i<levels.length;i++) {
						html +="<option value='"+levels[i]+"'>"+
								DictUtils.getDictLabel(levels[i],"gcontest_level","")
								+"</option>";
					}
				}
			}
		}
		return html;
	}

	/**根据模板类型获取大赛类型html代码*/
	public static String getTypeSelect(String proProjectId) {
		ProProject proProject=proProjectService.get(proProjectId);
		String html="";
		if (proProject!=null) {
			String type=proProject.getType();
			if (type!=null) {
				String[] types=type.split(",");
				if (types.length>0) {
					for(int i=0;i<types.length;i++) {
						html +="<option value='"+types[i]+"'>"+
								DictUtils.getDictLabel(types[i],"competition_type","")
								+"</option>";
					}
				}
			}
		}
		return html;
	}
	public static String getProModelAuditNameById (String proid) {
		ActYwGnode actYwGnode =actTaskService.getNodeByProInsId(proid);
		if (actYwGnode!=null) {
			return actYwGnode.getName();
		}
		return "";
	}

}