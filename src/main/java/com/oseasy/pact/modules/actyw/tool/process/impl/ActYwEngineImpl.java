/**
 * 源代码版权归[[os-easy]]公司所有.
 * @Project: ROOT
 * @Package com.oseasy.initiate.modules.actyw.tool.process.impl
 * @Description [[_ActYwEngineImpl_]]文件
 * @date 2017年6月19日 上午11:52:00
 *
 */

package com.oseasy.pact.modules.actyw.tool.process.impl;

import org.springframework.beans.factory.annotation.Autowired;

import com.oseasy.pact.modules.actyw.service.ActYwFormService;
import com.oseasy.pact.modules.actyw.service.ActYwGclazzService;
import com.oseasy.pact.modules.actyw.service.ActYwGformService;
import com.oseasy.pact.modules.actyw.service.ActYwGnodeService;
import com.oseasy.pact.modules.actyw.service.ActYwGroleService;
import com.oseasy.pact.modules.actyw.service.ActYwGstatusService;
import com.oseasy.pact.modules.actyw.service.ActYwGtimeService;
import com.oseasy.pact.modules.actyw.service.ActYwGuserService;
import com.oseasy.pact.modules.actyw.service.ActYwNodeService;
import com.oseasy.pact.modules.actyw.tool.process.ActYwEngine;

/**
 * 流程生成器数据库操作引擎实现.
 * @author chenhao
 * @date 2017年6月19日 上午11:52:00
 *
 */
public class ActYwEngineImpl implements ActYwEngine<ActYwGnodeService, ActYwNodeService, ActYwFormService, ActYwGformService, ActYwGstatusService, ActYwGroleService, ActYwGuserService, ActYwGclazzService, ActYwGtimeService> {

    @Autowired
    ActYwGnodeService gnode;
    @Autowired
    ActYwNodeService node;
    @Autowired
    ActYwFormService form;
    @Autowired
    ActYwGstatusService gstatus;
    @Autowired
    ActYwGroleService grole;
    @Autowired
    ActYwGformService gform;
    @Autowired
    ActYwGuserService guser;
    @Autowired
    ActYwGclazzService gclazz;
    @Autowired
    ActYwGtimeService gtime;

    public ActYwEngineImpl(ActYwGnodeService gnode, ActYwNodeService node) {
        super();
        this.gnode = gnode;
        this.node = node;
    }

    public ActYwEngineImpl(ActYwGnodeService gnode, ActYwNodeService node, ActYwGstatusService gstatus,
            ActYwGroleService grole, ActYwGformService gform) {
        super();
        this.gnode = gnode;
        this.node = node;
        this.gstatus = gstatus;
        this.grole = grole;
        this.gform = gform;
    }

    public ActYwEngineImpl(ActYwGnodeService gnode, ActYwNodeService node, ActYwFormService form,
            ActYwGstatusService gstatus, ActYwGroleService grole, ActYwGformService gform, ActYwGuserService guser) {
        super();
        this.gnode = gnode;
        this.node = node;
        this.form = form;
        this.gstatus = gstatus;
        this.grole = grole;
        this.gform = gform;
        this.guser = guser;
    }

    public ActYwEngineImpl(ActYwGnodeService gnode, ActYwNodeService node, ActYwFormService form,
            ActYwGstatusService gstatus, ActYwGroleService grole, ActYwGformService gform, ActYwGuserService guser,
            ActYwGtimeService gtime) {
        super();
        this.gnode = gnode;
        this.node = node;
        this.form = form;
        this.gstatus = gstatus;
        this.grole = grole;
        this.gform = gform;
        this.guser = guser;
        this.gtime = gtime;
    }

    public ActYwEngineImpl(ActYwGnodeService gnode, ActYwNodeService node, ActYwFormService form,
            ActYwGstatusService gstatus, ActYwGroleService grole, ActYwGformService gform, ActYwGuserService guser,
            ActYwGclazzService gclazz, ActYwGtimeService gtime) {
        super();
        this.gnode = gnode;
        this.node = node;
        this.form = form;
        this.gstatus = gstatus;
        this.grole = grole;
        this.gform = gform;
        this.guser = guser;
        this.gclazz = gclazz;
        this.gtime = gtime;
    }

    @Override
    public ActYwGnodeService gnode() {
        return gnode;
    }

    @Override
    public ActYwNodeService node() {
        return node;
    }

    @Override
    public ActYwFormService form() {
        return form;
    }

    @Override
    public ActYwGstatusService gstatus() {
        return gstatus;
    }

    @Override
    public ActYwGformService gform() {
        return gform;
    }

    @Override
    public ActYwGroleService grole() {
        return grole;
    }

    @Override
    public ActYwGuserService guser() {
        return guser;
    }

    public ActYwGclazzService gclazz() {
        return gclazz;
    }

    @Override
    public ActYwGtimeService gtime() {
        return gtime;
    }
}
