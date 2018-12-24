package com.oseasy.pact.modules.actyw.tool.project.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.transaction.annotation.Transactional;

import com.oseasy.initiate.modules.proproject.entity.ProProject;
import com.oseasy.pact.modules.actyw.entity.ActYw;
import com.oseasy.pact.modules.actyw.entity.ActYwGform;
import com.oseasy.pact.modules.actyw.entity.ActYwGnode;
import com.oseasy.pact.modules.actyw.entity.ActYwGroup;
import com.oseasy.pact.modules.actyw.service.ActYwGnodeService;
import com.oseasy.pact.modules.actyw.tool.process.vo.FormClientType;
import com.oseasy.pact.modules.actyw.tool.process.vo.FormStyleType;
import com.oseasy.pact.modules.actyw.tool.process.vo.GnodeType;
import com.oseasy.pact.modules.actyw.tool.project.ActMenuRemarks;
import com.oseasy.pact.modules.actyw.tool.project.ActProParamVo;
import com.oseasy.pact.modules.actyw.tool.project.IActProDeal;
import com.oseasy.pcore.common.config.CoreIds;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.utils.SpringContextHolder;
import com.oseasy.pcore.modules.sys.entity.Menu;
import com.oseasy.pcore.modules.sys.entity.Role;
import com.oseasy.pcore.modules.sys.service.CoreService;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * Created by Administrator on 2017/7/29 0029.
 */

public class ActProProject  implements IActProDeal {
	//@Autowired
	// CategoryService categoryService;

//    CategoryService categoryService = (CategoryService) SpringContextHolder.getBean(CategoryService.class);
	//@Autowired
	//SystemService systemService;
    CoreService coreService = (CoreService) SpringContextHolder.getBean(CoreService.class);
	//@Autowired
	//ActYwGnodeService actYwGnodeService;
	ActYwGnodeService actYwGnodeService = (ActYwGnodeService) SpringContextHolder.getBean(ActYwGnodeService.class);

	@Override
	@Transactional(readOnly = false)
	public Boolean dealMenu(ActProParamVo actProParamVo) {
		ProProject proProject =actProParamVo.getProProject();
		ActYw actYw =actProParamVo.getActYw();
		if (proProject != null) {
			Role sAdminRole = coreService.getRole(CoreIds.SYS_ADMIN_ROLE.getId());
			Menu  menu = new Menu();
			menu.setParent(coreService.getMenu(Menu.getRootId()));
			menu.setName(proProject.getProjectName());
			menu.setImgUrl(proProject.getImgUrl());
			menu.setIsShow(Global.SHOW);
			menu.setRemarks(proProject.getContent());
//			menu.setHref(AuditStandardController.ASD_INDEX + actYw.getId());
			menu.setSort(10);
			menu.setRemarks(ActMenuRemarks.XM.getName());
			coreService.saveMenu(menu);
			proProject.setMenu(menu);
			proProject.setMenuRid(menu.getId());
			actYw.setProProject(proProject);
			if (actYw.getGroupId() != null) {
				ActYwGnode actYwGnode = new ActYwGnode(new ActYwGroup(actYw.getGroupId()));
				List<ActYwGnode> sourcelist = actYwGnodeService.findListBygMenu(actYwGnode);
				Menu menuForm = new Menu();
				menuForm.setParent(menu);
				menuForm.setName(menu.getName());
				menuForm.setIsShow(Global.SHOW);
				//menuForm.setHref("form/" + proProject.getProjectMark() + "/" + sourcelist.get(i).getFormId() + "?id=" + actYw.getId());
				menuForm.setSort(10);
				menuForm.setRemarks(ActMenuRemarks.XM.getName());
				coreService.saveMenu(menuForm);

				if (sourcelist.size() > 0) {
					for (int i = 0; i < sourcelist.size(); i++) {
						ActYwGnode actYwGnodeIndex = sourcelist.get(i);
						if (actYwGnodeIndex != null) {
							//前台节点不生成菜单
							boolean isFront=false;
							if(actYwGnodeIndex.getType().equals(GnodeType.GT_PROCESS.getId())){
								List<ActYwGnode> actYwGnodes = actYwGnodeService.findListBygYwGprocess(actYw.getGroupId(),actYwGnodeIndex.getId());
								if(actYwGnodes!=null && actYwGnodes.size()==1){
									if(actYwGnodes.get(0).getGforms()!=null && FormClientType.FST_FRONT.getKey().equals(actYwGnodes.get(0).getGforms().get(0).getForm().getClientType())){
										isFront=true;
									}
								}
							}else{
								if(actYwGnodeIndex.getGforms()!= null && FormClientType.FST_FRONT.getKey().equals(actYwGnodeIndex.getGforms().get(0).getForm().getClientType())){
									isFront=true;
								}
							}
							if(isFront){
								continue;
							}

							Menu menuNextForm = new Menu();
							menuNextForm.setParent(menuForm);
							menuNextForm.setName(actYwGnodeIndex.getName());
							menuNextForm.setIsShow(Global.SHOW);
							menuNextForm.setSort(10 + i);

							List<ActYwGform> actYwFormList =actYwGnodeIndex.getGforms();
							String formId="";
							if (StringUtil.checkNotEmpty(actYwFormList)) {
								for (ActYwGform actYwGform : actYwFormList) {
									if (FormClientType.FST_ADMIN.getKey().equals(actYwGform.getForm().getClientType())
											&& FormStyleType.FST_LIST.getKey().equals(actYwGform.getForm().getStyleType())
											) {
										formId = actYwGform.getForm().getId();
									}
								}
							}
							menuNextForm.setHref("/cms/form/" + proProject.getProjectMark() + "/" + formId +
									"?actywId=" + actYw.getId() +
									"&gnodeId=" + actYwGnodeIndex.getId()
							);

							/*menuNextForm.setHref("/cms/form/" + proProject.getProjectMark() + "/" + actYwGnodeIndex.getForm().getId() +
									"?actywId=" + actYw.getId() +
									"&gnodeId=" +  sourcelist.get(i).getId()
							);*/
							menuNextForm.setRemarks(ActMenuRemarks.ACT.getName());
							coreService.saveMenu(menuNextForm);
//							ActYwGnode actYwGnodePar = new ActYwGnode();
//							actYwGnodePar.setParentIds(sourcelist.get(i).getId());
							//List<ActYwGnode> actYwGnodes = actYwGnodeService.findListBygYwGprocess(actYw.getGroupId(),sourcelist.get(i).getId());
							List<ActYwGnode> actYwGnodes = new ArrayList<ActYwGnode>();
							if(GnodeType.GT_PROCESS.getId().equals(actYwGnodeIndex.getType())){
								actYwGnodes = actYwGnodeService.findListBygYwGprocess(actYw.getGroupId(),sourcelist.get(i).getId());
							}else{
								actYwGnodes.add(actYwGnodeIndex);
							}
							for (int j = 0; j < actYwGnodes.size(); j++) {
								//给相应角色赋权访问
                                ActYwGnode curGnode = actYwGnodes.get(j);
                                if(curGnode != null){
                                    for (Role curRole : curGnode.getRoles()) {
                                        if ((curRole != null) && StringUtil.isNotEmpty(curRole.getId())) {
                                            Role role = coreService.getRole(curRole.getId());
                                            if (role != null) {
                                                List<Menu> roleMenuList = role.getMenuList();
                                                if (!roleMenuList.contains(menuForm)) {
                                                    roleMenuList.add(menuForm);
                                                }
                                                if (!roleMenuList.contains(menuNextForm)) {
                                                    roleMenuList.add(menuNextForm);
                                                }
                                                role.setMenuList(roleMenuList);
                                                coreService.saveRole(role);
                                            }
                                        }
                                    }
									if (sAdminRole != null) {
										List<Menu> roleMenuList = sAdminRole.getMenuList();
										if (!roleMenuList.contains(menuForm)) {
											roleMenuList.add(menuForm);
										}
										if (!roleMenuList.contains(menuNextForm)) {
											roleMenuList.add(menuNextForm);
										}
										sAdminRole.setMenuList(roleMenuList);
										coreService.saveRole(sAdminRole);
									}
                                }

							}
						}
					}
				}
				//添加查询表单
				Menu menuQueryForm = new Menu();
				menuQueryForm.setParent(menuForm);
				menuQueryForm.setName("项目查询列表");
				menuQueryForm.setIsShow(Global.SHOW);
				menuQueryForm.setSort(30);
				menuQueryForm.setHref("/cms/form/queryMenuList/?actywId=" + actYw.getId());
				menuQueryForm.setRemarks(ActMenuRemarks.XM.getName());
				coreService.saveMenu(menuQueryForm);
//				if (sAdminRole != null) {
//					List<Menu> roleMenuList = sAdminRole.getMenuList();
//					if (!roleMenuList.contains(menuForm)) {
//						roleMenuList.add(menuForm);
//					}
//					if (!roleMenuList.contains(menuQueryForm)) {
//						roleMenuList.add(menuQueryForm);
//					}
//					sAdminRole.setMenuList(roleMenuList);
//					coreService.saveRole(sAdminRole);
//				}


				//给项目流程中所有涉及的角色和学校管理员分配查询菜单
				Set<String> roleIds = actYwGnodeService.getRolesByGroup(actYw.getGroupId());//项目流程所有节点角色IDs
				if(!roleIds.contains(CoreIds.SYS_ADMIN_ROLE.getId())){
					roleIds.add(CoreIds.SYS_ADMIN_ROLE.getId());//学校管理员
				}
				for (String roleId : roleIds) {
					Role role = coreService.getRole(roleId);
					if (role == null) {
						continue;
					}
					List<Menu> menuList = role.getMenuList();
					if(!menuList.contains(menuForm)){
						menuList.add(menuForm);
					}
					if(!menuList.contains(menuQueryForm)){
						menuList.add(menuQueryForm);
					}
					role.setMenuList(menuList);
					coreService.saveRole(role);
				}
			}
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean dealCategory(ActProParamVo actProParamVo) {
		ProProject proProject =actProParamVo.getProProject();
		ActYw actYw =actProParamVo.getActYw();
		//修改栏目为可见
//		Category  category = new Category();
//		Category parent = categoryService.get(SysIds.SITE_CATEGORYS_TOP_ROOT.getId());
//		category.setParent(parent);
//		category.setSite(parent.getSite());
////		category.setOffice(parent.getOffice());
//		category.setName(proProject.getProjectName());
//		category.setDescription(proProject.getContent());
////		category.setInMenu(Global.SHOW);
////		category.setInList(Global.SHOW);
//		category.setIsAudit(Global.NO);
//		category.setSort(10);
//		category.setRemarks(ActMenuRemarks.XM.getName());
//		categoryService.save(category);
//
//		//默认添加申报表单
//		Category categoryapp=new Category();
//		categoryapp.setParent(category);
//		categoryapp.setSite(category.getSite());
////		categoryapp.setOffice(category.getOffice());
//		categoryapp.setName(proProject.getProjectName());
//		categoryapp.setDescription(proProject.getContent());
////		categoryapp.setInMenu(Global.SHOW);
////		categoryapp.setInList(Global.SHOW);
//		categoryapp.setIsAudit(Global.NO);
//		categoryapp.setHref("/cms/form/"+proProject.getProjectMark()+"/applyForm?actywId="+actYw.getId());
//		categoryapp.setSort(10);
//		categoryapp.setRemarks(ActMenuRemarks.XM.getName());
//		categoryService.save(categoryapp);
//		Category categoryNew=categoryService.findByName(categoryapp.getName());
//		proProject.setCategory(categoryNew);
//		proProject.setCategoryRid(categoryNew.getId());
//		actYw.setProProject(proProject);
		return true;
	}

  @Override
  public Boolean dealTime(ActProParamVo actProParamVo) {
    return true;
  }

  @Override
  public Boolean dealIcon(ActProParamVo actProParamVo) {
    return true;
  }

  @Override
  public Boolean dealActYw(ActProParamVo actProParamVo) {
    return true;
  }

  @Override
  public Boolean dealDeploy(ActProParamVo actProParamVo) {
    return true;
  }

  @Override
  public Boolean requireMenu() {
    return true;
  }

  @Override
  public Boolean requireCategory() {
    return true;
  }

  @Override
  public Boolean requireTime() {
    return true;
  }

  @Override
  public Boolean requireIcon() {
    return true;
  }

  @Override
  public Boolean requireActYw() {
    return true;
  }

  @Override
  public Boolean requireDeploy() {
    return true;
  }
}
