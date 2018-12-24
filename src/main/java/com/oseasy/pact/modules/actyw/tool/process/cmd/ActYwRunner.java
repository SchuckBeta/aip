/**
 * 源代码版权归[[os-easy]]公司所有.
 * @Project: ROOT
 * @Package com.oseasy.initiate.modules.actyw.tool.process.cmd
 * @Description [[_ActYwRunner_]]文件
 * @date 2017年6月18日 上午11:16:08
 *
 */

package com.oseasy.pact.modules.actyw.tool.process.cmd;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.oseasy.pact.modules.actyw.entity.ActYwGnode;
import com.oseasy.pact.modules.actyw.tool.process.cmd.exception.NoInitException;
import com.oseasy.pact.modules.actyw.tool.process.cmd.vo.ActYwPgnode;
import com.oseasy.pact.modules.actyw.tool.process.impl.ActYwEngineImpl;
import com.oseasy.pcore.common.config.ApiTstatus;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 流程引擎执行类.
 *
 * @author chenhao
 * @date 2017年6月18日 上午11:16:08
 *
 */
@Service
@Transactional(readOnly = true)
public class ActYwRunner {
    protected static final Logger logger = Logger.getLogger(ActYwRunner.class);
    private ActYwEngineImpl engine;

    public static List<String> runnerIds = Lists.newArrayList();

    public static Boolean containsId(String id) throws NoInitException {
        if ((ActYwRunner.runnerIds == null) || (ActYwRunner.runnerIds.size() <= 0)) {
            throw new NoInitException("节点参数未初始化异常！");
        }
        return ActYwRunner.runnerIds.contains(id);
    }

    // /**
    // * 执行批量命令.
    // * @param cmd 命令
    // * @param param 参数
    // * @return ActYwApiStatus
    // */
    // public ActYwApiStatus<ActYwGnode> callExecutePL(List<Map<ActYwEcmd,
    // ActYwPgroot>> cmdParams) {
    // ActYwApiStatus<ActYwGnode> ApiStatus = new ActYwApiStatus<ActYwGnode>();
    // if (cmdParams != null) {
    // List<ActYwApiStatus<ActYwGnode>> isFales = Lists.newArrayList();
    //
    // for (Map<ActYwEcmd, ActYwPgroot> cmdParam : cmdParams) {
    // Iterator<ActYwEcmd> itor = cmdParam.keySet().iterator();
    // while (itor.hasNext()) {
    // ActYwEcmd cmd = (ActYwEcmd) itor.next();
    // ActYwPgroot param = cmdParam.get(cmd);
    // if ((cmd == null) || (param == null)) {
    // continue;
    // }
    //
    // ActYwApiStatus<ActYwGnode> isCuApiStatus = null;
    // if ((ActYwEcmd.ECMD_ROOT_ADD).equals(cmd)) {
    // isCuApiStatus = saveRoot(param.getGnode().getGroup());
    // }else if ((ActYwEcmd.ECMD_ROOT_ADD_NODE).equals(cmd)) {
    // isCuApiStatus = saveRootNode(param);
    // }else if ((ActYwEcmd.ECMD_ROOT_ADD_NODEGATE).equals(cmd)) {
    // isCuApiStatus = saveRootNodeGate(param);
    // }else{
    // isCuApiStatus = new ActYwApiStatus<ActYwGnode>(false,
    // "当前命令["+cmd.getKey()+"]未定义！");
    // }
    //
    // if (!isCuApiStatus.getStatus()) {
    // isFales.add(isCuApiStatus);
    // }
    // }
    // }
    //
    // if (!isFales.isEmpty()) {
    // return isFales.get(0);
    // }
    // }else{
    // ApiStatus.setStatus(false);
    // ApiStatus.setMsg("命令执行参数不能为空！");
    // }
    // return ApiStatus;
    // }
    //
    // /**
    // * 执行批量命令.
    // * @param cmd 命令
    // * @param param 参数
    // * @return ActYwApiStatus
    // */
    // public ActYwApiStatus<ActYwGnode> callExecutePL(ActYwEcmd cmd, ActYwPgroot
    // param) {
    // return callExecutePL(addCmdParam(Lists.newArrayList(), cmd, param));
    // }
    //
    // /**
    // * 添加CMD参数到命令列表 .
    // * @author chenhao
    // * @param cmd 命令
    // * @param param 参数
    // * @param cmdParams 集合
    // * @return List
    // */
    // public static List<Map<ActYwEcmd, ActYwPgroot>>
    // addCmdParam(List<Map<ActYwEcmd, ActYwPgroot>> cmdParams, ActYwEcmd cmd,
    // ActYwPgroot param) {
    // Map<ActYwEcmd, ActYwPgroot> cmdParam = new HashMap<ActYwEcmd,
    // ActYwPgroot>();
    // cmdParam.put(cmd, param);
    // cmdParams.add(cmdParam);
    // return cmdParams;
    // }

    /****************************************************************************************************************
     * 新修改的接口.
     ***************************************************************************************************************/
    /**
     * 执行单个命令.
     *
     * @param cmd
     *            命令
     * @param param
     *            参数
     * @return ActYwApiStatus
     */
    @Transactional(readOnly = false)
    public ApiTstatus<ActYwGnode> callExecute(ActYwEcoper oper, ActYwPgnode param) {
        ApiTstatus<ActYwGnode> ApiStatus = new ApiTstatus<ActYwGnode>(false, "执行失败");
        if ((oper == null) || (param == null) || (param.getGnode() == null) || StringUtil.isEmpty(param.getGnode().getType())) {
            ApiStatus.setMsg("执行失败，命令或参数不能为空！");
            return ApiStatus;
        }
        ActYwEcmd cmd = ActYwEcmd.getCmdBygtid(param.getGnode().getType(), oper);
        return ActYwEcmd.exeEngine(cmd, engine, param);
    }

    public ActYwEngineImpl getEngine() {
        return engine;
    }

    public ActYwRunner setEngine(ActYwEngineImpl engine) {
        this.engine = engine;
        return this;
    }
}
