<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script type="text/javascript" src="/static/ueditor/ueditor.config.js"></script>
    <script type="text/javascript" src="/static/ueditor/ueditor.all.js"></script>
    <script type="text/javascript">
        var validate;
        UE.Editor.prototype._bkGetActionUrl = UE.Editor.prototype.getActionUrl;
        UE.Editor.prototype.getActionUrl = function (action) {
            if (action == 'uploadimage' || action == 'uploadscrawl' || action == 'uploadvideo' || action == 'uploadfile') {
                return $frontOrAdmin+'/ftp/ueditorUpload/uploadTempFormal?folder=gcontesthots';
            } else {
                return this._bkGetActionUrl.call(this, action);
            }
        }
        $(document).ready(function () {
            var ue = UE.getEditor('content');
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
                        if ($("#inputForm").attr("action") == "save") {
                            loading('正在提交，请稍等...');
                        }
                        form.submit();
                    }
                },
                rules: {},
                messages: {},
                errorPlacement: function (error, element) {
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                        error.appendTo(element.parent().parent());
                    } else {
                        error.insertAfter(element);
                    }

                }
            });

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
        function preview() {
            $("#inputForm").attr("action", $("#front_url").val() + "/gcontesthots/preView");
            $("#inputForm").attr("target", "_blank");
            $("#inputForm").submit();
            $("#inputForm").attr("action", "save");
            $("#inputForm").removeAttr("target");
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
<input type="hidden" id="front_url" value="${front_url}"/>
<div class="container-fluid">
    <div class="edit-bar clearfix">
        <div class="edit-bar-left">
            <span>大赛热点</span>
            <i class="line weight-line"></i>
        </div>
    </div>
    <form:form id="inputForm" modelAttribute="gcontestHots" action="save"
               method="post" class="form-horizontal">
        <form:hidden path="id"/>
        <sys:message content="${message}"/>
        <div class="control-group">
            <label class="control-label"><i>*</i>标题：</label>
            <div class="controls">
                <form:input path="title" htmlEscape="false" maxlength="200" class="input-xxlarge required"/>
                <span id="yzName"></span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">来源：</label>
            <div class="controls">
                <form:input path="source" htmlEscape="false" maxlength="200"/>
            </div>
        </div>
        <div class="control-group form-keyword">
            <label class="control-label">关键字：</label>
            <div class="controls">
                <input type="text" class="form-keyword" id="formKeyword" autocomplete="off"
                       placeholder="输入关键字按回车键添加">
                <span class="col-md-3 col-error"></span>
            </div>
        </div>
        <div class="row-keyword control-group">
            <label class="control-label"></label>
            <div class="controls col-keyword-box">
                <c:forEach items="${gcontestHots.keywords}" var="item">
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
                <form:textarea path="content" htmlEscape="false" rows="6" maxlength="2000" class="required" cssStyle="display: block;width: 100%; max-width: 1200px; min-width: 750px;"/>
            </div>

        </div>
        <div class="control-group">
            <label class="control-label">是否发布：</label>
            <div class="controls">
                <form:select path="isRelease">
                    <form:options items="${fns:getDictList('yes_no')}" itemValue="value" itemLabel="label"
                                  htmlEscape="false"/></form:select>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">是否置顶：</label>
            <div class="controls">
                <form:select path="isTop">
                    <form:options items="${fns:getDictList('yes_no')}" itemValue="value" itemLabel="label"
                                  htmlEscape="false"/></form:select>
            </div>
        </div>
        <div class="form-actions">
            <button class="btn btn-primary" type="button" onclick="preview()">预览</button>
            <button class="btn btn-primary" type="submit">保存</button>
            <button class="btn btn-default" type="button" onclick="history.go(-1)">返回</button>
        </div>
    </form:form>
</div>
</body>
</html>