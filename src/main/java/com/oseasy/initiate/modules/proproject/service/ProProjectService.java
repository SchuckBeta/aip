package com.oseasy.initiate.modules.proproject.service;

import java.text.ParseException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.initiate.modules.proproject.dao.ProProjectDao;
import com.oseasy.initiate.modules.proproject.entity.ProProject;
import com.oseasy.initiate.modules.sys.service.SystemService;
import com.oseasy.initiate.modules.sys.tool.SysNoType;
import com.oseasy.initiate.modules.sys.tool.SysNodeTool;
import com.oseasy.pact.modules.actyw.entity.ActYw;
import com.oseasy.pact.modules.actyw.entity.ActYwGtime;
import com.oseasy.pact.modules.actyw.service.ActYwGtimeService;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.pcore.modules.sys.entity.Menu;
import com.oseasy.putil.common.utils.DateUtil;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 创建项目Service.
 * @author zhangyao
 * @version 2017-06-15
 */
@Service
@Transactional(readOnly = true)
public class ProProjectService extends CrudService<ProProjectDao, ProProject> {
//	@Autowired
//	private CategoryService categoryService;

	@Autowired
	private SystemService systemService;
	@Autowired
	ActYwGtimeService actYwGtimeService;


	public ProProject get(String id) {
		return super.get(id);
	}

	public List<ProProject> findList(ProProject proProject) {
		return super.findList(proProject);
	}

	public Page<ProProject> findPage(Page<ProProject> page, ProProject proProject) {
		return super.findPage(page, proProject);
	}

  	@Transactional(readOnly = false)
  	public void save(ProProject proProject) {
		if (StringUtil.isEmpty(proProject.getProjectMark())) {
		  	proProject.setProjectMark(SysNodeTool.genByKeyss(SysNoType.NO_PROJECT));
		}
		//判断是否已经生成过栏目和菜单
		//将生成栏目和菜单隐藏不可见
		/*if (StringUtil.isEmpty(proProject.getId())) {
		  //生成栏目表
		  	Category category=new Category();
		  //category.setParent(new Category(SysIds.SITE_CATEGORYS_SYS_ROOT.getId()));
		  	Category parent = categoryService.get(SysIds.SITE_CATEGORYS_TOP_ROOT.getId());
		  	category.setParent(parent);
		  	category.setSite(parent.getSite());
		  	category.setOffice(parent.getOffice());
		  	category.setName(proProject.getProjectName());
		  	category.setDescription(proProject.getContent());
		  	category.setInMenu(Global.SHOW);
		  	category.setInList(Global.HIDE);
		  	category.setIsAudit(Global.NO);
		  	category.setSort(10);
			category.setRemarks("流程栏目");
		  	categoryService.save(category);
		  	proProject.setCategory(category);
		  //生成后台菜单
		  	Menu menu=new Menu();
		  	menu.setParent(systemService.getMenu(Menu.getRootId()));
		  	menu.setName(proProject.getProjectName());
		  	menu.setIsShow(Global.HIDE);
		  	menu.setImgUrl(proProject.getImgUrl());
		  	menu.setRemarks(proProject.getContent());
		  	menu.setSort(10);
			menu.setRemarks("流程菜单");
		  	systemService.saveMenu(menu);
		  	proProject.setMenu(menu);
		}*/
    try {
      proProject.setStartDate(DateUtil.getStartDate(proProject.getStartDate()));
      proProject.setEndDate(DateUtil.getEndDate(proProject.getEndDate()));
//      proProject.setNodeStartDate(DateUtil.getStartDate(proProject.getNodeStartDate()));
//      proProject.setNodeEndDate(DateUtil.getEndDate(proProject.getNodeEndDate()));
    } catch (ParseException e) {
      logger.error(e.getMessage());
    }
		super.save(proProject);
	}

	@Transactional(readOnly = false)
	public void delete(ProProject proProject) {
		super.delete(proProject);
	}
	public ProProject getProProjectByName(String name) {
		return dao.getProProjectByName(name);
	}

	@Transactional(readOnly = false)
	public void saveProProject(ProProject proProject) {
		//生成栏目表
////		Category category=new Category();
////		Category parent = categoryService.get(SysIds.SITE_CATEGORYS_TOP_ROOT.getId());
//		category.setParent(parent);
//		category.setSite(parent.getSite());
////		category.setOffice(parent.getOffice());
//		category.setName(proProject.getProjectName());
//		category.setDescription(proProject.getContent());
////		category.setInMenu(Global.SHOW);
////		category.setInList(Global.SHOW);
//		category.setIsAudit(Global.NO);
//		category.setSort(10);
//		categoryService.save(category);

		//生成后台菜单
		Menu menu=new Menu();
		menu.setParent(systemService.getMenu(Menu.getRootId()));
		menu.setName(proProject.getProjectName());
		menu.setIsShow(Global.SHOW);
		menu.setRemarks(proProject.getContent());
		menu.setSort(10);
		systemService.saveMenu(menu);

		save(proProject);
	}

	@Transactional(readOnly = false)
	public void changeProProjectModel(ActYw actYw, HttpServletRequest request)  {
		ProProject proProject = actYw.getProProject();

		//根据流程生成子菜单
		if (actYw.getGroupId() != null) {


			String[] gNodeId = request.getParameterValues("nodeId");
			String[] beginDate = request.getParameterValues("beginDate");
			String[] endDate = request.getParameterValues("endDate");
			if (beginDate != null && beginDate.length > 0 && endDate != null && endDate.length > 0) {
				for (int i = 0; i < beginDate.length; i++) {
					String status = request.getParameter("status" + i);
					ActYwGtime actYwGtime = new ActYwGtime();
					actYwGtime.setGrounpId(actYw.getGroupId());
					actYwGtime.setProjectId(actYw.getRelId());
					actYwGtime.setGnodeId(gNodeId[i]);
					actYwGtime.setStatus(status);
					actYwGtime.setBeginDate(DateUtil.parseDate(beginDate[i]));
					actYwGtime.setEndDate(DateUtil.parseDate(endDate[i]));
					actYwGtimeService.save(actYwGtime);
				}
			}
	    save(proProject);
		}
	}

	//创建菜单
	@Transactional(readOnly = false)
	public void createMenu(ProProject proProject) {
		Menu menu=new Menu();
		menu.setParent(systemService.getMenu(Menu.getRootId()));
		menu.setName(proProject.getProjectName());
		menu.setIsShow(Global.SHOW);
		menu.setRemarks(proProject.getContent());
		menu.setSort(10);
		menu.setImgUrl(proProject.getImgUrl());
		systemService.saveMenu(menu);
		proProject.setMenu(menu);
	}

	//创建栏目
	@Transactional(readOnly = false)
	public void createCategory(ProProject proProject,ActYw actYw) {
//		Category category=new Category();
//		Category parent = categoryService.get(SysIds.SITE_CATEGORYS_TOP_ROOT.getId());
//		category.setParent(parent);
//		category.setSite(parent.getSite());
////		category.setOffice(parent.getOffice());
//		category.setName(proProject.getProjectName());
//		category.setDescription(proProject.getContent());
////		category.setInMenu(Global.SHOW);
////		category.setInList(Global.SHOW);
//		category.setIsAudit(Global.NO);
//		category.setSort(40);
//		categoryService.save(category);
//		//默认添加申报表单
//		Category categoryapp=new Category();
//
//		categoryapp.setParent(category);
//		categoryapp.setSite(category.getSite());
////		categoryapp.setOffice(category.getOffice());
//		categoryapp.setName(proProject.getProjectName());
//		categoryapp.setDescription(proProject.getContent());
////		categoryapp.setInMenu(Global.SHOW);
////		categoryapp.setInList(Global.SHOW);
//		categoryapp.setIsAudit(Global.NO);
//		categoryapp.setHref("/form/"+proProject.getProjectMark()+"/applyForm?id="+actYw.getId());
//
//		categoryapp.setSort(40);
//		categoryService.save(categoryapp);
//
//		proProject.setCategory(category);
	}

	//屏蔽以发布流程
	@Transactional(readOnly = false)
	public void savedis(ProProject proProject) {
		Menu menu = proProject.getMenu();
		if (StringUtil.isNotEmpty(proProject.getMenuRid())) {
			menu = systemService.getMenu(proProject.getMenuRid());
		}
//		Category category = proProject.getCategory();
//		if ((category == null) && StringUtil.isNotEmpty(proProject.getCategoryRid())) {
//			category = categoryService.get(proProject.getCategoryRid());
//		}
//		if (category!=null) {
////			category.setInMenu(Global.HIDE);
//			category.setName(proProject.getProjectName());
//			category.setDescription(proProject.getContent());
//			categoryService.save(category);
//			proProject.setCategory(category);
//		}
		if (menu!=null) {
			menu.setIsShow(Global.HIDE);
			menu.setParent(systemService.getMenu(Menu.getRootId()));
			menu.setName(proProject.getProjectName());
			menu.setRemarks(proProject.getContent());
			menu.setImgUrl(proProject.getImgUrl());
			systemService.saveMenu(menu);
			proProject.setMenu(menu);
		}
		save(proProject);
	}


}