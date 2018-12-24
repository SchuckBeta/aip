package com.oseasy.pact.modules.actyw.tool.process.vo;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.collect.Lists;
import com.oseasy.initiate.common.config.SysIds;
import com.oseasy.pact.modules.actyw.entity.ActYwGnode;
import com.oseasy.pcore.common.config.CoreIds;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 流程执行状态实体.
 *
 * @author chenhao
 */
public class GnodeView extends ActYwGnode {
    private static final long serialVersionUID = 1L;
    protected static Logger logger = LoggerFactory.getLogger(GnodeView.class);
    public static final int GV_NO_START = 0;// 0未开始/1执行中/2已执行结束
    public static final int GV_RUNNING = 1;// 0未开始/1执行中/2已执行结束
    public static final int GV_END = 2;// 0未开始/1执行中/2已执行结束
    private Integer ApiStatus; // 0未开始/1执行中/2已执行结束
    private Boolean isFront; // 是否前台节点
    private Boolean isShow; // 是否前台节点
    private List<User> users; // 审核用户

    public GnodeView() {
        super();
    }

    public GnodeView(ActYwGnode gnode) {
        super(gnode);
        this.ApiStatus = GV_NO_START;
        this.isFront = false;
        this.isShow = true;
    }

    public GnodeView(ActYwGnode gnode, Boolean isAll) {
        super(gnode, isAll);
        this.ApiStatus = GV_NO_START;
        this.isFront = false;
        this.isShow = true;
    }

    public GnodeView(ActYwGnode gnode, Integer ApiStatus, Boolean isFront) {
        super(gnode);
        this.ApiStatus = ApiStatus;
        this.isFront = isFront;
    }

    public GnodeView(ActYwGnode gnode, Integer ApiStatus, Boolean isFront, Boolean isShow) {
        super(gnode);
        this.ApiStatus = ApiStatus;
        this.isFront = isFront;
        this.isShow = isShow;
    }

    public Integer getApiStatus() {
        if (ApiStatus == null) {
            ApiStatus = GV_NO_START;
        }
        return ApiStatus;
    }

    public Boolean getIsFront() {
        return isFront;
    }

    public Boolean getIsShow() {
        if (isShow == null) {
            isShow = true;
        }
        return isShow;
    }

    public void setIsShow(Boolean isShow) {
        this.isShow = isShow;
    }

    public void setIsFront(Boolean isFront) {
        this.isFront = isFront;
    }

    public void setApiStatus(Integer ApiStatus) {
        this.ApiStatus = ApiStatus;
    }

    public List<User> getUsers() {
        return users;
    }

    public void setUsers(List<User> users) {
        this.users = users;
    }

    /**
     * gnodes转换为GnodeView对象. 处理前后台属性 isFront 处理前显示属性 isShow 处理状态属性 ApiStatus
     * 注意：gnodes必须有序，没有当前结点定位到开始节点。
     * @param gnodes
     *            节点列表
     * @param curGnode
     *            当前执行节点（id和prentId,level必填）
     * @return List
     */
    public static List<GnodeView> convertsGview(List<ActYwGnode> gnodes, ActYwGnode curGnode) {
        List<GnodeView> gvs = Lists.newArrayList();
        Boolean hasCurGnode = true;

        if ((curGnode == null) || StringUtil.isEmpty(curGnode.getId()) || StringUtil.isEmpty(curGnode.getType())
                || (curGnode.getLevel() == null) || (curGnode.getParent() == null)
                || ((!(curGnode.getParent().getId()).equals(CoreIds.SYS_TREE_ROOT.getId())) && (curGnode.getParent().getLevel() == null))) {
            hasCurGnode = false;
        }
        /**
         * 在列表中找出开始节点的位置.
         */
        for (ActYwGnode gnode : gnodes) {
            GnodeView gview = new GnodeView(gnode, true);
            if (StringUtil.checkNotEmpty(gnode.getGroles())) {
                String roleIds = StringUtil.listIdToStr(gnode.getGroles());
//                if (StringUtil.isNotEmpty(roleIds) && (roleIds).contains(SysIds.SYS_ROLE_USER.getId())) {
//                    gview.setIsFront(true);
//                }
            }

            /**
             * 没有当前结点，定位为开始节点.
             */
            if (!hasCurGnode) {
                if ((GnodeType.GT_ROOT_START.getId()).equals(gview.getType())) {
                    gview.setApiStatus(GV_RUNNING);
                } else {
                    gview.setApiStatus(GV_NO_START);
                }
                gvs.add(gview);
                continue;
            }

            if ((GnodeType.getIdByRoot()).contains(gview.getType()) && (GnodeType.getIdByRoot()).contains(curGnode.getType())) {
                if (curGnode.getLevel() > gview.getLevel()) {
                    gview.setApiStatus(GV_END);
                } else if ((curGnode.getLevel() == gview.getLevel())) {
                    if ((curGnode.getId()).equals(gview.getId())) {
                        gview.setApiStatus(GV_RUNNING);
                    } else {
                        gview.setApiStatus(GV_NO_START);
                        gview.setIsShow(false);
                    }
                } else {
                    gview.setApiStatus(GV_NO_START);
                }
            } else if ((GnodeType.getIdByRoot()).contains(gview.getType()) && (GnodeType.getIdByProcess()).contains(curGnode.getType())) {
                if (curGnode.getParent().getLevel() > gview.getLevel()) {
                    gview.setApiStatus(GV_END);
                } else if (curGnode.getParent().getLevel() == gview.getLevel()) {
                    if ((curGnode.getParent().getId()).equals(gview.getId())) {
                        gview.setApiStatus(GV_RUNNING);//子流程定位去掉
                    } else {
                        gview.setApiStatus(GV_NO_START);
                        gview.setIsShow(false);
                    }
                } else {
                    gview.setApiStatus(GV_NO_START);
                }
            } else if ((GnodeType.getIdByProcess()).contains(gview.getType()) && (GnodeType.getIdByRoot()).contains(curGnode.getType())) {
                if (curGnode.getLevel() > gview.getParent().getLevel()) {
                    gview.setApiStatus(GV_END);
                } else if (curGnode.getLevel() == gview.getParent().getLevel()) {
//                    if ((curGnode.getId()).equals(gview.getId())) {
//                        gview.setApiStatus(GV_RUNNING);//子流程定位去掉
//                    } else {
//                        gview.setApiStatus(GV_NO_START);
//                        gview.setIsShow(false);
//                    }
                } else {
                    gview.setApiStatus(GV_NO_START);
                }
            } else if ((GnodeType.getIdByProcess()).contains(gview.getType()) && (GnodeType.getIdByProcess()).contains(curGnode.getType())) {
                if (curGnode.getLevel() > gview.getLevel()) {
                    gview.setApiStatus(GV_END);
                } else if ((curGnode.getLevel() == gview.getLevel())) {
                    if ((curGnode.getId()).equals(gview.getId())) {
                        gview.setApiStatus(GV_RUNNING);
                    } else {
                        gview.setApiStatus(GV_NO_START);
                        gview.setIsShow(false);
                    }
                } else {
                    gview.setApiStatus(GV_NO_START);
                }
            } else {
                logger.warn("节点类型错误或为空！");
            }
            gvs.add(gview);
        }
        return gvs;
    }
}