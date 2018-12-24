package com.oseasy.pact.modules.actyw.tool.project.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
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
import com.oseasy.pcore.common.config.CoreIds;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.modules.sys.entity.Menu;
import com.oseasy.pcore.modules.sys.entity.Role;
import com.oseasy.pcore.modules.sys.service.CoreService;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * Created by Administrator on 2017/7/29 0029.
 */
@Service
@Transactional(readOnly = true)
public class ActProUtil {
//	@Autowired
//	CategoryService categoryService ;//= (CategoryService) SpringContextHolder.getBean(CategoryService.class);
	@Autowired
	CoreService coreService;//	= (CoreService) SpringContextHolder.getBean(CoreService.class);
	@Autowired
	ActYwGnodeService actYwGnodeService ;//= (ActYwGnodeService) SpringContextHolder.getBean(ActYwGnodeService.class);

	public Boolean dealMenu(ActProParamVo actProParamVo, String menuId) {
		ProProject proProject = actProParamVo.getProProject();
		ActYw actYw = actProParamVo.getActYw();
		if (proProject != null) {
			Menu menu = coreService.getMenu(menuId);
			if (actYw.getGroupId() != null) {
				Role sAdminRole = coreService.getRole(CoreIds.SYS_ADMIN_ROLE.getId());
				ActYwGnode actYwGnode = new ActYwGnode(new ActYwGroup(actYw.getGroupId()));
				List<ActYwGnode> sourcelist = actYwGnodeService.findListBygMenu(actYwGnode);
				Menu menuForm = new Menu();
				menuForm.setParent(menu);
				menuForm.setName(proProject.getProjectName());
				menuForm.setIsShow(Global.SHOW);
//				menuForm.setHref(AuditStandardController.ASD_INDEX + actYw.getId());
				//menuForm.setHref("form/" + proProject.getProjectMark() + "/" + sourcelist.get(i).getFormId() + "?id=" + actYw.getId());
				menuForm.setSort(10);
				menuForm.setRemarks(ActMenuRemarks.APPOINTMENT.getName());
				coreService.saveMenu(menuForm);

				proProject.setMenu(menuForm);
				proProject.setMenuRid(menuForm.getId());
				actYw.setProProject(proProject);
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
								if(actYwGnode.getGforms()!= null && FormClientType.FST_FRONT.getKey().equals(actYwGnode.getGforms().get(0).getForm().getClientType())){
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

							menuNextForm.setRemarks(ActMenuRemarks.APPOINTMENT.getName());
							coreService.saveMenu(menuNextForm);
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
				//添加查询表单
				Menu menuQueryForm = new Menu();
				menuQueryForm.setParent(menuForm);
				menuQueryForm.setName("查询列表");
				menuQueryForm.setIsShow(Global.SHOW);
				menuQueryForm.setSort(30);
				menuQueryForm.setHref("/cms/form/queryMenuList/?actywId=" + actYw.getId());
				menuQueryForm.setRemarks(ActMenuRemarks.APPOINTMENT.getName());
				coreService.saveMenu(menuQueryForm);
				if (sAdminRole != null) {
					List<Menu> roleMenuList = sAdminRole.getMenuList();
					if (!roleMenuList.contains(menuForm)) {
						roleMenuList.add(menuForm);
					}
					if (!roleMenuList.contains(menuQueryForm)) {
						roleMenuList.add(menuQueryForm);
					}
					sAdminRole.setMenuList(roleMenuList);
					coreService.saveRole(sAdminRole);
				}
			}
		}
		return true;
	}


/**
 * .
 * @param actProParamVo
 * @param menuId
 * @return
 */
	public Boolean dealMenu1(ActProParamVo actProParamVo, String menuId) {
		ProProject proProject = actProParamVo.getProProject();
		ActYw actYw = actProParamVo.getActYw();
		if (proProject != null) {
			if (actYw.getGroupId() != null) {
				Role sAdminRole = coreService.getRole(CoreIds.SYS_ADMIN_ROLE.getId());
				ActYwGnode actYwGnode = new ActYwGnode(new ActYwGroup(actYw.getGroupId()));
				List<ActYwGnode> sourcelist = actYwGnodeService.findListByMenu(actYwGnode);
				Menu menuForm = coreService.getMenu(menuId);

				actYw.setProProject(proProject);
				if (sourcelist.size() > 0) {
					for (int i = 0; i < sourcelist.size(); i++) {
						ActYwGnode actYwGnodeIndex = sourcelist.get(i);
						if (actYwGnodeIndex != null) {
							Menu menuNextForm = new Menu();
							menuNextForm.setParent(menuForm);
							menuNextForm.setName(actYwGnodeIndex.getName());
							menuNextForm.setIsShow(Global.SHOW);
							menuNextForm.setSort(10 + i);

							List<ActYwGform> actYwFormList =actYwGnodeIndex.getGforms();
							String formId="";
							for(ActYwGform actYwGform:actYwFormList){
								if (FormClientType.FST_ADMIN.getKey().equals(actYwGform.getForm().getClientType())
										&& FormStyleType.FST_LIST.getKey().equals(actYwGform.getForm().getStyleType())
										){
									formId=actYwGform.getForm().getId();
								}
							}
							menuNextForm.setHref("/cms/form/" + proProject.getProjectMark() + "/" + formId +
									"?actywId=" + actYw.getId() +
									"&gnodeId=" + actYwGnodeIndex.getId()
							);

							/*menuNextForm.setHref("/cms/form/" + proProject.getProjectMark() + "/" + actYwGnodeIndex.getForm().getId() +
									"?actywId=" + actYw.getId() +
									"&gnodeId=" + sourcelist.get(i).getId()
							);*/
							menuNextForm.setRemarks(ActMenuRemarks.APPOINTMENT.getName());
							coreService.saveMenu(menuNextForm);
							ActYwGnode actYwGnodePar = new ActYwGnode();
							actYwGnodePar.setParentIds(sourcelist.get(i).getId());
							List<ActYwGnode> ActYwGnodes = actYwGnodeService.findList(actYwGnodePar);
							for (int j = 0; j < ActYwGnodes.size(); j++) {
								//给相应角色赋权访问
								ActYwGnode curGnode = ActYwGnodes.get(j);
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
                                }

//								if (sAdminRole != null) {
//                                    List<Menu> roleMenuList = sAdminRole.getMenuList();
//                                    if (!roleMenuList.contains(menuForm)) {
//                                        roleMenuList.add(menuForm);
//                                    }
//                                    if (!roleMenuList.contains(menuNextForm)) {
//                                        roleMenuList.add(menuNextForm);
//                                    }
//                                    sAdminRole.setMenuList(roleMenuList);
//                                    coreService.saveRole(sAdminRole);
//                                }
							}
						}
					}

					//添加查询表单
					Menu menuQueryForm = new Menu();
					menuQueryForm.setParent(menuForm);
					menuQueryForm.setName("查询列表");
					menuQueryForm.setIsShow(Global.SHOW);
					menuQueryForm.setSort(30);
					menuQueryForm.setHref("/cms/form/queryMenuList/?actywId=" + actYw.getId());
					menuQueryForm.setRemarks(ActMenuRemarks.XM.getName());
					coreService.saveMenu(menuQueryForm);
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
		}
		return true;
	}


	public Boolean dealCategory(ActProParamVo actProParamVo, String cateId, String checkName) {
		ProProject proProject = actProParamVo.getProProject();
		ActYw actYw = actProParamVo.getActYw();
		//修改栏目为可见
//		Category category = categoryService.get(cateId);
//		//默认添加申报表单
//		Category categoryapp = new Category();
//		categoryapp.setParent(category);
//		categoryapp.setSite(category.getSite());
////		categoryapp.setOffice(category.getOffice());
//		categoryapp.setName(proProject.getProjectName());
//		categoryapp.setDescription(proProject.getContent());
////		categoryapp.setInMenu(Global.SHOW);
////		categoryapp.setInList(Global.SHOW);
//		categoryapp.setIsAudit(Global.NO);
//		if (StringUtil.isEmpty(checkName)) {
//			categoryapp.setHref("/cms/form/" + proProject.getProjectMark() + "/applyForm?actywId=" + actYw.getId());
//		} else {
//			categoryapp.setHref("javascript:" + checkName + "('/cms/form/" + proProject.getProjectMark() + "/applyForm','" + actYw.getId() + "');");
//		}
//		categoryapp.setSort(10);
//		categoryapp.setRemarks(ActMenuRemarks.APPOINTMENT.getName());
//		categoryService.save(categoryapp);
//		proProject.setCategory(categoryapp);
//		proProject.setCategoryRid(categoryapp.getId());
//		actYw.setProProject(proProject);
		return true;
	}

	public Boolean dealTime(ActProParamVo actProParamVo) {
		return true;
	}

	public Boolean dealIcon(ActProParamVo actProParamVo) {
		return true;
	}

	public Boolean dealActYw(ActProParamVo actProParamVo) {
		return true;
	}

	public Boolean dealDeploy(ActProParamVo actProParamVo) {
		return true;
	}

	public Boolean requireMenu() {
		return false;
	}

	public Boolean requireCategory() {
		return false;
	}

	public Boolean requireTime() {
		return true;
	}

	public Boolean requireIcon() {
		return false;
	}

	public Boolean requireActYw() {
		return true;
	}

	public Boolean requireDeploy() {
		return true;
	}
}
