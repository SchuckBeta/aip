package com.oseasy.pcore.common.config;

import com.oseasy.putil.common.utils.StringUtil;

/**
 * 系统固定ID.
 * @author Administrator
 */
public enum CoreIds {
    SYS_USER_SUPER("1", "系统超级管理员用户"),
    SYS_ROLE_SUPER("1", "系统超级管理员角色"),
    SYS_ROLE_ADMIN("10", "系统管理员角色"),
    SYS_ADMIN_ROLE("f9c12c05add2409dac0fcdec9387e63c", "学校管理员角色Id"),
    SYS_OFFICE_TOP("1", "系统顶级机构"),
    SYS_TREE_ROOT("1", "系统树根节点"),
    SYS_TREE_PROOT("0", "系统树根节点父节点");

    /**
     * parentIds值  (0,).
     */
    public static final String SYS_TREE_PPIDS = SYS_TREE_PROOT.getId() + StringUtil.DOTH;
    /**
     * parentIds值  (0,1,).
     */
    public static final String SYS_TREE_RPIDS = SYS_TREE_PROOT.getId() + StringUtil.DOTH + SYS_TREE_ROOT.getId() + StringUtil.DOTH;


    private String id;
    private String remark;

    private CoreIds(String id, String remark) {
        this.id = id;
        this.remark = remark;
    }

    public String getId() {
        return id;
    }


    public String getRemark() {
        return remark;
    }

    public static CoreIds getById(String id) {
        CoreIds[] entitys = CoreIds.values();
        for (CoreIds entity : entitys) {
            if ((id).equals(entity.getId())) {
                return entity;
            }
        }
        return null;
    }

    @SuppressWarnings("unused")
    @Override
    public String toString() {
        if(this != null){
            return "{\"id\":\"" + this.id + ",\"remark\":\"" + this.remark + "\"}";
        }
        return super.toString();
    }
}
