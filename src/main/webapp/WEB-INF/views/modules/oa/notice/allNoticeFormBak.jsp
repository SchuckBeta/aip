<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script type="text/javascript" src="${ctxStatic}/ueditor/ueditor.config.js"></script>
    <script type="text/javascript" src="${ctxStatic}/ueditor/ueditor.all.js"></script>
    <script type="text/javascript">
        var validate;
        UE.Editor.prototype._bkGetActionUrl = UE.Editor.prototype.getActionUrl;
        UE.Editor.prototype.getActionUrl = function (action) {
            if (action == 'uploadimage' || action == 'uploadscrawl' || action == 'uploadvideo'
                    || action == 'uploadfile' || action == 'catchimage' || action == 'listimage' || action == 'listfile') {
                return $frontOrAdmin+'/ftp/ueditorUpload/uploadTemp?folder=oaNotice';
            } else {
                return this._bkGetActionUrl.call(this, action);
            }
        }
        $(document).ready(function () {
            $('#formKeyword').on('keydown', function (e) {
                var keywordHtml = '';
                var keyword = $(this).val();
                var $next = $("#formKeyword").next();
                if (e.keyCode == 13) {
                    if (hasSameKeyword(keyword)) {
                        if ($next.children().size() < 1) {
                            $next.append('<label class="error">请不要重复添加</label>');
                        } else {
                            $next.find('label').text('请不要重复添加').show();
                        }
                        return false;
                    }
                    keywordHtml += tmpKeyWord(keyword);
                    $('.col-keyword-box').append(keywordHtml);

                    $next.empty();
                    return false;
                }
            });
            validate = $("#inputForm").validate({
                submitHandler: function (form) {
                    if (UE.getEditor('content').getContent() == "") {
                        top.$.jBox.tip('请填写内容', 'warning');
                    } else {
                        loading('正在提交，请稍等...');
                        form.submit();
                    }
                },
                rules: {
                    "title": {
                        remote: {
                            async: true,
                            url: "${ctx}/oa/oaNotify/checkTitle",     //后台处理程序
                            type: "post",               //数据发送方式
                            dataType: "json",           //接受数据格式
                            data: {                     //要传递的数据
                                oldTitle: "${oaNotify.title}",
                                title: function () {
                                    return $("#title").val();
                                }
                            }
                        }
                    }
                },
                messages: {
                    "title": {
                        remote: "该标题已经存在"
                    }
                },
                errorPlacement: function (error, element) {
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                        error.appendTo(element.parent().parent());
                    } else {
                        error.insertAfter(element);
                    }

                }
            });

            if ("${oaNotify.id}" != "" && "${oaNotify.status}" == "1") {
                $('#type').attr("disabled", true);
                $('#title').attr("disabled", true);
                $('#status').attr("disabled", true);
                $('#btnSubmit').hide();
            }


        });
        function hasSameKeyword(keyword) {
            var hasSameKeyword = false;
            $keywords = $('.keyword');
            $keywords.each(function (i, item) {
                var val = $(item).find('span').text();
                if (val == keyword) {
                    hasSameKeyword = true
                    return false;
                }
            })

            return hasSameKeyword;
        }
        function tmpKeyWord(keyword) {
            return '<span class="keyword"><input name="keywords" value="' + keyword + '" type="hidden"/><span>' + keyword + '</span><a class="delete-keyword" href="javascript:void(0);" onclick="delKey(this);">&times;</a></span>'
        }
        function delKey(ob) {
            $(ob).parent().remove();
        }
        function onTypeChange() {
            var type = $("#type").val();
            if (type == "" || type == "3") {
                $(".cmodel").attr("style", "display:none");
            } else {
                $(".cmodel").attr("style", "display:");
            }
        }
    </script>
    <style>
        .row-keyword .keyword {
            display: inline-block;
            position: relative;
            padding: 4px 8px;
            min-width: 24px;
            line-height: 20px;
            border-radius: 13px;
            font-size: 12px;
            color: #fff;
            text-align: center;
            background-color: #df4526;
            border: 1px solid #fff;
            margin-right: 8px;
        }

        .row-keyword .keyword > span {
            display: inline-block;
            max-width: 110px;
            text-overflow: ellipsis;
            white-space: nowrap;
            vertical-align: middle;
            overflow: hidden;
        }

        .row-keyword .delete-keyword {
            display: none;
            position: absolute;
            right: -6px;
            top: -8px;
            font-size: 20px;
            color: #333;
            opacity: .6;
            text-decoration: none;
        }

        .row-keyword .keyword:hover .delete-keyword {
            display: block;
        }

        .row-keyword .keyword .delete-keyword:hover {
            opacity: .8
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="edit-bar clearfix">
        <div class="edit-bar-left">
            <span>通告发布</span>
            <i class="line weight-line"></i>
        </div>
    </div>
    <form:form id="inputForm" modelAttribute="oaNotify" action="${ctx}/oa/oaNotify/saveAllNotice"
               method="post" class="form-horizontal">
        <form:hidden path="id"/>
        <sys:message content="${message}"/>
        <input type="hidden" id="sendType" name="sendType" value="1"/>
        <div class="control-group">
            <label class="control-label"><i>*</i>通知类型：
            </label>
            <div class="controls">
                <form:select path="type" class="required" onchange="onTypeChange()">
                    <form:option value="" label="--请选择--"/>
                    <form:options items="${fns:getDictList('oa_notify_type')}"
                                  itemLabel="label" itemValue="value" htmlEscape="false"/>
                </form:select>
            </div>
        </div>
        <div class="control-group">

            <label class="control-label"><i>*</i>标题：
            </label>
            <div class="controls">
                <form:input path="title" htmlEscape="false" maxlength="200" class="required"/>
                <span id="yzName"></span>
            </div>
        </div>
        <div class="control-group cmodel"
             style="display: ${(oaNotify.type==null or oaNotify.type=='' or  oaNotify.type=='3') ? 'none' : ''}">

            <label class="control-label">来源：</label>
            <div class="controls">
                <form:input path="source" htmlEscape="false" maxlength="200"/>
            </div>
        </div>
        <div class="control-group form-keyword cmodel"
             style="display: ${(oaNotify.type==null or oaNotify.type==' ' or  oaNotify.type=='3') ? 'none' : ''}">
            <label class="control-label">关键字：</label>
            <div class="controls">
                <input type="text" class="form-keyword" id="formKeyword" autocomplete="off"
                       placeholder="输入关键字按回车键添加">
                <span class="col-md-3 col-error"></span>
            </div>
        </div>
        <div class="control-group row-keyword cmodel"
             style="display: ${(oaNotify.type==null or oaNotify.type==' ' or  oaNotify.type=='3') ? 'none' : ''}">
            <label class="control-label"></label>
            <div class="controls col-keyword-box">
                <c:forEach items="${oaNotify.keywords}" var="item">
                    		<span class="keyword">
                    			<input name="keywords" value="${item}" type="hidden"/>
	                    		<span>${item}</span>
	                    		<a class="delete-keyword" href="javascript:void(0);" onclick="delKey(this);">×</a>
                    		</span>
                </c:forEach>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><i>*</i>内容：</label>
            <div class="controls">
                <form:textarea path="content" htmlEscape="false" rows="6" maxlength="2000" class="required"
                               style="width:95%;max-width:1170px;height:300px"/>
                <script type="text/javascript">
                    var ue = UE.getEditor('content');
                    //如果是发布状态
                    ue.addListener('ready', function () {
                        if ("${oaNotify.id}" != "" && "${oaNotify.status}" == "1") {
                            ue.setDisabled();
                        }
                    });
                </script>
            </div>

        </div>

        <div class="control-group">
            <label class="control-label"><i>*</i>状态：</label>
            <div class="controls controls-radio">
                <form:radiobuttons path="status" items="${fns:getDictList('oa_notify_status')}" itemLabel="label"
                                   itemValue="value" htmlEscape="false" class="required"/>
            </div>
        </div>


        <div class="form-actions">
            <button id="btnSubmit" class="btn btn-primary" type="submit">保存</button>
            <button id="btnCancel" class="btn btn-default" type="button" onclick="history.go(-1)">返回</button>
        </div>
    </form:form>
</div>
</body>
</html>