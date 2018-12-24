<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%--<%@include file="/WEB-INF/views/include/backtable.jsp" %>--%>
<!DOCTYPE html>
<html lange="zh-CN">
<head>
    <meta charset="utf-8">
    <title>基础数据定义</title>
    <link rel="stylesheet" type="text/css" href="/css/bootstrap.min.css">
    <%--<%@include file="/WEB-INF/views/include/backcyjd.jsp" %>--%>
    <link href="${ctxStatic}/bootstrap/2.3.1/awesome/font-awesome.min.css" type="text/css" rel="stylesheet"/>
    <link rel="stylesheet" type="text/css" href="/css/dict/baseDataDefined.css">
    <script src="${ctxStatic}/jquery/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="/js/actYwDesign/vue.min.js"></script>
    <script type="text/javascript" src="/js/dict/components.js"></script>
    <style>
        .dropdown-dict {
            position: absolute;
            left: 15px;
            right: 15px;
            top: 34px;
            z-index: 100;
        }

        .dropdown-dict .list-group-item {
            padding: 4px 15px;
        }

        .edit-bar{
            margin-top:15px;
            margin-bottom:15px;
        }

        .edit-bar_new .edit-bar-left span{
            padding-left:10px;
            color:#333;
            font-size:14px;
            border-left:2px solid #e9432d;
        }
        .edit-bar-left>span{

        }
    </style>
</head>
<body>
<div id="baseData" class="container-fluid">
    <div class="edit-bar edit-bar-tag edit-bar_new clearfix">
        <div class="edit-bar-left">
            <span>基础数据维护</span>
        </div>
    </div>
    <%--<%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>--%>
    <p v-if="!dictjson" style="text-align: center">数据加载中...</p>
    <div class="tab-content tab-content-base-data" style="display: none" v-show="dictjson.length > 0">
        <b-alert :variant="variantType" dismissible :show="showDismissibleAlert" @dismissed="showDismissibleAlert==0"
                 @dismiss-count-down="countDownChanged">{{alertTitle}}
        </b-alert>
        <%--<ul class="nav nav-tabs" role="tablist">--%>
        <%--<li role="presentation" :class="{active:tablePage}"><a href="javascript:void (0)" aria-controls="baseData" role="tab" @click="tablePage=true">基础数据</a></li>--%>
        <%--<li role="presentation"><a href="javascript:void (0)" aria-controls="baseDataAdd" role="tab" @click="addDictTypeTop">添加字典类型</a></li>--%>
        <%--</ul>--%>
        <div class="tab-content" style="border: none">
            <div role="tabpanel" class="tab-pane active">
                <div class="row">
                    <div class="left-menu" role="complementary">
                        <div style="padding-right: 15px; border-right: solid 1px #ddd">
                            <div class="form-inline" style="padding: 0 0 0 15px;margin-bottom: 15px;">
                                <div class="form-group form-group-sm form-append" style="width: 211px">
                                    <input class="form-control" v-model="dictName" :placeholder="dictNamePlaceholder"
                                           @change="changeDictName" style="width: 211px;">
                                    <%--<button type="button" class="btn btn-oe-primary btn-sm" @click="clearDictName">清空</button>--%>
                                    <a class="icon-close" href="javascript:void (0);" @click="clearDictName"
                                       v-show="dictName">&times;</a>
                                </div>
                                <button type="button" class="btn btn-oe-primary btn-sm" @click="addDictName"
                                        :disabled="filterDicts.length > 0">添加
                                </button>
                            </div>
                            <p v-if="filterDicts.length < 1" style="padding: 0 15px;">抱歉！数据不存在，可点击添加按钮添加</p>
                            <ul class="bd-nav" v-show="filterDicts.length > 0" style="position: relative">
                                <li :class="{active:currentDictIndex===index}" v-for="(item, index) in filterDicts" :key="index" :ref="item.id + index">
                                    <div class="btn-box">
                                        <%--<button type="button" class="btn btn-xs btn-oe-primary" @click="addDictType(item)">添加</button>--%>
                                        <button type="button" class="btn btn-xs btn-oe-primary"
                                                @click="edtDictType(item)">编辑
                                        </button>
                                        <button type="button" class="btn btn-xs btn-default" @click="delDictType(item)"
                                                :disabled="item.is_sys == 1">删除
                                        </button>
                                    </div>
                                    <a :title="item.label" href="javascript:void (0);"
                                       @click="changeDictJson(item, index)">{{item.label}}</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="center-content">
                        <div class="wrap">
                            <div class="form-container">
                                <form class="form-inline">
                                    <div class="form-group form-group-sm form-append">
                                        <input id="metaKey" v-model="metaKey" type="text" class="form-control"
                                               placeholder="关键字搜索">
                                        <i class="icon icon-search"></i>
                                    </div>
                                    <%--<button type="button" class="btn btn-sm btn-oe-primary" @click="formSearch">查询</button>--%>
                                    <%--<button type="button" class="btn btn-oe-primary" @click="formCreate">创建类别</button>--%>
                                    <button type="button" class="btn btn-sm btn-oe-primary" @click="formAdd">添加</button>
                                    <%--<button type="button" :disabled="(!metaKey && currentDictIndex < 0)" class="btn btn-oe-primary" @click="formCancel">清除</button>--%>
                                </form>
                            </div>
                            <div class="table-content">
                                <table class="table table-bordered table-hover table-condensed table-base-data">
                                    <thead>
                                    <tr>
                                        <th>字典名称</th>
                                        <th>字典类型</th>
                                        <th width="85">排序编号</th>
                                        <th width="120">操作</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr v-for="(pt, index) in projectTypes">
                                        <td>{{pt.label}}</td>
                                        <td>{{pt.type_name}}</td>
                                        <td style="text-align: center">{{pt.sort}}</td>
                                        <td>
                                            <button type="button" class="btn btn-xs btn-oe-primary"
                                                    @click=editPtType(index,pt)>编辑
                                            </button>
                                            <button type="button" class="btn btn-xs btn-default"
                                                    @click=deletePtType(index,pt) :disabled="pt.is_sys == 1">删除
                                            </button>
                                        </td>
                                    </tr>
                                    <tr v-if="!projectTypes">
                                        <td colspan="4" class="text-center">抱歉没有数据，请重新查找</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <my-pagination :page-size="pageSize" :total="total" :current-page="currentPage"
                                           @handle-change="pChange" @select-change="pSelect"></my-pagination>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div style="display: none" v-show="dataLoad">
        <my-modal :title="modalAddEdit.title" :show.sync="modalAddEdit.show" @ok="modalAddEditOk"
                  @cancel="modalAddEditCancel" ok-text="确认" cancel-text="取消" ok-class="btn btn-oe-primary"
                  cancel-class="btn btn-default">
            <div class="modal-body" slot="body">
                <form class="form-horizontal" :form="modalChangeDict.form">
                    <div class="form-group">
                        <label for="ptType1" class="col-sm-2 control-label">字典类型</label>
                        <div class="col-sm-10">
                            <select type="text" id="ptType1" class="form-control" @change="pTypeChange" placeholder=""
                                    v-model="modalChangeDict.form.pId"
                                    :disabled="!!modalChangeDict.form.pId && changeType != 'addDict'">
                                <option value="0">-请选择-</option>
                                <option v-for="dType in dictjson" :value="dType.id">
                                    {{dType.label}}
                                </option>
                            </select>

                        </div>
                    </div>
                    <div class="form-group">
                        <label for="ptTypeName" class="col-sm-2 control-label">字典名称</label>
                        <div class="col-sm-10">
                            <input id="ptTypeName" type="text" class="form-control" @change="ptTagChange"
                                   v-model="modalChangeDict.form.name" placeholder="">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="ptTypeSort" class="col-sm-2 control-label">排序编号</label>
                        <div class="col-sm-10">
                            <input id="ptTypeSort" type="text" class="form-control" v-model="modalChangeDict.form.sort"
                                   placeholder="" @change="sortChange">
                        </div>
                    </div>
                </form>
            </div>
        </my-modal>
        <my-modal :title="modalDelete.title" :show.sync="modalDelete.show" @ok="modalDeleteOk"
                  @cancel="modalDeleteCancel" ok-text="确认" cancel-text="取消" ok-class="btn btn-oe-primary"
                  cancel-class="btn btn-default">
            <p slot="body">{{delText}}</p>
        </my-modal>
        <my-modal title="添加" :show.sync="modalAdd.show" @ok="modalAddOk" @cancel="modalAddCancel" ok-text="确认"
                  cancel-text="取消" ok-class="btn btn-oe-primary" cancel-class="btn btn-default">
            <div class="modal-body" slot="body">
                <form class="form-horizontal" :form="modalChangeDict.form">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">字典类型</label>
                        <div class="col-sm-10">
                            <input class="form-control" v-model="dictFormName" @focus="addDictFocus" @blur="addDictBlur" placeholder="-请输入或者选择需要添加的字典类型-"
                                   @change="dictFormChange">
                            <div class="dropdown-dict" v-show="dictNameShow">
                                <div class="list-group">
                                    <a href="javascript:void(0);" v-for="dType in filterDictsAdd"
                                       :data-type-id="dType.id" :key="dType.id" class="list-group-item"
                                       @click="selectDict(dType)">{{dType.label}}</a>
                                </div>
                            </div>
                            <label style="color: red;" class="error" v-if="!dTypeId">请选择存在的字典类型</label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="ptTag" class="col-sm-2 control-label">字典名称</label>
                        <div class="col-sm-10">
                            <input type="text" id="ptTag" @change="ptTagChange" class="form-control" placeholder=""
                                   v-model="modalChangeDict.form.name"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="ptDesc" class="col-sm-2 control-label">排序编号</label>
                        <div class="col-sm-10">
                            <input type="text" id="ptDesc" class="form-control" placeholder=""
                                   v-model="modalChangeDict.form.sort" @change="sortChange"/>
                        </div>
                    </div>
                </form>
            </div>
        </my-modal>
        <my-modal :title="modalChangeDictTypeTitle" :show.sync="modalChangeDictType.show" @cancel="modalChangeCancel"
                  @ok="modalChangeDictOk" ok-text="确认" cancel-text="取消" ok-class="btn btn-oe-primary"
                  cancel-class="btn btn-default">
            <div class="modal-body" slot="body">
                <form class="form-horizontal" :form="modalChangeDictType.form">
                    <div class="form-group" v-show="edtDictTypeAble">
                        <label for="modalChangeDictTypeName" class="col-sm-2 control-label">id</label>
                        <div class="col-sm-10">
                            <input type="text" id="modalChangeDictTypeName" readonly
                                   v-model="modalChangeDictType.form.id" class="form-control" placeholder=""/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="modalChangeDictTypeId" class="col-sm-2 control-label">类型名称</label>
                        <div class="col-sm-10">
                            <input type="text" id="modalChangeDictTypeId" @change="dictTypeInputChange"
                                   class="form-control" v-model="modalChangeDictType.form.name" placeholder=""/>
                        </div>
                    </div>
                </form>
            </div>
        </my-modal>
    </div>
</div>
<script type="text/javascript" src="/js/dict/baseDataDefinedNew.js"></script>
</body>
<script src="/js/goback.js" type="text/javascript" charset="UTF-8"></script>
</html>