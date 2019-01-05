package com.oseasy.pcms.modules.cms.entity;

import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;
import org.hibernate.validator.constraints.Length;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.google.common.collect.Lists;
import com.oseasy.pcore.common.config.CoreIds;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.persistence.TreeEntity;
import com.oseasy.pcore.modules.sys.entity.Menu;

/**
 * CMS菜单Entity.
 * @author chenh
 * @version 2019-01-01
 */
public class CmsMenu extends TreeEntity<CmsMenu> {
	private static final long serialVersionUID = 1L;
	private CmsMenu parent;		// 父级编号
	private String parentIds;		// 所有父级编号
	private String name;		// 名称
	private String href;		// 链接
	private String target;		// 目标
	private String icon;		// 图标
	private String isShow;		// 是否在菜单中显示
	private String permission;		// 权限标识
	private String imgUrl;		// 菜单图片
	private List<CmsMenu> children;
    private List<CmsMenu> menuList;

    public CmsMenu() {
        super();
        this.sort = 30;
        this.isShow = CoreSval.YES;
    }

    public CmsMenu(String id) {
        super(id);
    }

    @JsonBackReference
    @NotNull(message = "父级编号不能为空")
    public CmsMenu getParent() {
        return parent;
    }

    public void setParent(CmsMenu parent) {
        this.parent = parent;
    }

    @Length(min = 1, max = 2000, message = "所有父级编号长度必须介于 1 和 2000 之间")
    public String getParentIds() {
        return parentIds;
    }

    public void setParentIds(String parentIds) {
        this.parentIds = parentIds;
    }

    @Length(min = 1, max = 100, message = "名称长度必须介于 1 和 100 之间")
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Length(min = 0, max = 2000, message = "链接长度必须介于 0 和 2000 之间")
    public String getHref() {
        return href;
    }

    public void setHref(String href) {
        this.href = href;
    }

    @Length(min = 0, max = 20, message = "目标长度必须介于 0 和 20 之间")
    public String getTarget() {
        return target;
    }

    public void setTarget(String target) {
        this.target = target;
    }

    @Length(min = 0, max = 100, message = "图标长度必须介于 0 和 100 之间")
    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    @Length(min = 1, max = 1, message = "是否在菜单中显示长度必须介于 1 和 1 之间")
    public String getIsShow() {
        return isShow;
    }

    public void setIsShow(String isShow) {
        this.isShow = isShow;
    }

    @Length(min = 0, max = 200, message = "权限标识长度必须介于 0 和 200 之间")
    public String getPermission() {
        return permission;
    }

    public void setPermission(String permission) {
        this.permission = permission;
    }

    @Length(min = 0, max = 1024, message = "菜单图片长度必须介于 0 和 1024 之间")
    public String getImgUrl() {
        return imgUrl;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    public List<CmsMenu> getChildren() {
        return children;
    }

    public void setChildren(List<CmsMenu> children) {
        this.children = children;
    }

    public List<CmsMenu> getMenuList() {
        return menuList;
    }

    public void setMenuList(List<CmsMenu> menuList) {
        this.menuList = menuList;
    }

    public String getParentId() {
        return parent != null && parent.getId() != null ? parent.getId() : CoreIds.SYS_TREE_PROOT.getId();
    }

    @JsonIgnore
    public static void sortList(List<CmsMenu> list, List<CmsMenu> sourcelist, String parentId, boolean cascade) {
        for (int i = 0; i < sourcelist.size(); i++) {
            CmsMenu e = sourcelist.get(i);
            if (e.getParent() != null && e.getParent().getId() != null && e.getParent().getId().equals(parentId)) {
                list.add(e);
                if (cascade) {
                    // 判断是否还有子节点, 有则继续获取子节点
                    for (int j = 0; j < sourcelist.size(); j++) {
                        CmsMenu child = sourcelist.get(j);
                        if (child.getParent() != null && child.getParent().getId() != null
                                && child.getParent().getId().equals(e.getId())) {
                            sortList(list, sourcelist, e.getId(), true);
                            break;
                        }
                    }
                }
            }
        }
    }

    @JsonIgnore
    public static List<CmsMenu> buildMenuTree(List<CmsMenu> listMenu) {
        List<CmsMenu> list = Lists.newArrayList();
        for (CmsMenu menu : listMenu) {
            if (CmsMenu.getRootId().equals(menu.getParent().getId())) {
                list.add(menu);
            }
            for (CmsMenu childMenu : listMenu) {
                if (childMenu.getParent().getId().equals(menu.getId())) {
                    if (menu.getChildren() == null) {
                        menu.setChildren(new ArrayList<CmsMenu>());
                    }
                    menu.getChildren().add(childMenu);
                }
            }
        }
        return list;
    }

    @JsonIgnore
    public static String getRootId() {
        return CoreIds.SYS_TREE_ROOT.getId();
    }

    @Override
    public String toString() {
        return ReflectionToStringBuilder.toString(this);
    }
}