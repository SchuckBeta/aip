<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oseasy.pcore.modules.sys.entity.User" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>站点管理</title>
    <!-- <meta name="decorator" content="default"/> -->
	<script type="text/javascript">
    $frontOrAdmin="${frontOrAdmin_2ed8fe6ddd034cffa47a41e42a694948}";
    </script>
    <%@include file="/WEB-INF/views/include/backtable.jsp" %>
    <!-- <link href="/common/common-css/pagenation.css" rel="stylesheet"/>-->

    <link rel="stylesheet" type="text/css" href="/static/common/tablepage.css"/>
    <link rel="stylesheet" type="text/css" href="/static/cropper/cropper.min.css">
    <script type="text/javascript" src="/static/cropper/cropper.min.js"></script>
    <script type="text/javascript" src="/js/uploadCutImage.js?v=2"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $("#name").focus();
            $("#inputForm").validate({
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                errorContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                        error.appendTo(element.parent().parent());
                    } else {
                        error.insertAfter(element);
                    }
                }
            });
        });
    </script>


    <style>

        body {
            font-size: 14px !important;
        }

        input {
            height: 30px !important;
        }

        textarea {
            resize: none;
        }

        .control-group {
            border-bottom: none !important;
        }

        .form-actions {
            border-top: none !important;
        }

        #btnSubmit {
            background: #e9432d !important;
        }

    </style>
</head>
<body>

<script src="/other/jquery-ui-1.12.1/jquery-ui.js" type="text/javascript" charset="utf-8"></script>
<script src="/other/jquery.form.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/common/common-js/jquery.validate.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/common/common-js/messages_zh.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/other/datepicker/My97DatePicker/WdatePicker.js" type="text/javascript" charset="utf-8"></script>
<script src="/js/DSSBvalidate.js" type="text/javascript" charset="utf-8"></script>
<script src="/js/common.js" type="text/javascript"></script>
<script src="/common/common-js/ajaxfileupload.js"></script>

<div class="mybreadcrumbs"><span>站点管理</span></div>
<div class="table-page">

    <ul class="nav nav-tabs">
        <li><a href="${ctx}/cms/site/">站点列表</a></li>
        <li class="active"><a href="${ctx}/cms/site/form?id=${site.id}">站点<shiro:hasPermission
                name="cms:site:edit">${not empty site.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission
                name="cms:site:edit">查看</shiro:lacksPermission></a></li>
    </ul>

    <form:form id="inputForm" modelAttribute="site" action="${ctx}/cms/site/save" method="post" class="form-horizontal">
        <form:hidden path="id"/>
        <sys:message content="${message}"/>
        <c:if test="${fns:getUser().admin}">
            <div class="control-group">
                <label class="control-label">归属机构:</label>
                <div class="controls">
                    <sys:treeselect id="office" name="office.id" value="${office.id}" labelName="office.name"
                                    labelValue="${office.name}" title="机构" url="/sys/office/treeData"
                                    cssClass="required" disabled="disabled"/>
                </div>
            </div>
        </c:if>

        <div class="control-group">
            <label class="control-label"><span class="help-inline"><font color="red">*&nbsp;</font> </span>站点名称:</label>
            <div class="controls">
                <form:input path="name" htmlEscape="false" maxlength="200" class="input-xlarge required"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><span class="help-inline"><font color="red">*&nbsp;</font> </span>站点标题:</label>
            <div class="controls">
                <form:input path="title" htmlEscape="false" maxlength="200" class="input-xlarge required"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">学校Logo1:</label>
            <div class="controls">
                    <%--<div id="image-logo" style="width:76px; height: 76px;"></div>--%>
                <form:hidden path="logo" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                    <%--<sys:fileUpload type="site" postfix="1" seletorItem="#image-logo" seletorHids="input[name=\'logo\']"--%>
                    <%--model="image" fileitem="${fns:ftpImgUrl(site.logo)}" imgWidth="100" imgHeight="100"--%>
                    <%--isshow="true"/>--%>
                <img id="logoImg" src="${(empty site.logo) ? '/images/upload-default-image1.png' : fns:ftpImgUrl(site.logo)}"
                     style="display:block; max-width: 100px;">
                <button type="button" id="uploadLogo" class="btn">上传</button>
                <span class="help-inline">建议Logo大小：100 × 100（像素）</span>
            </div>
                <%-- <div class="controls">
                    <div >
                        <img id="imageLogo" width="76" height="76" src="${empty proProject.imgUrl ? '/images/upload.png' : fns:ftpImgUrl(site.logo)}">
                    </div>
                    <span class="help-inline"><button type="button" id="btnUploadAvatar" class="btn btn-primary btn-small">更改</button> 建议大小：76 × 76（像素）</span>
                </div> --%>
        </div>
        <div class="control-group">
            <label class="control-label">学校Logo2:</label>
            <div class="controls">
                    <%--<div id="image-logoSite" style="width:161px; height: 76px;"></div>--%>
                <form:hidden path="logoSite" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                    <%--<sys:fileUpload type="site" postfix="2" seletorItem="#image-logoSite"--%>
                    <%--seletorHids="input[name=\'logoSite\']" model="image"--%>
                    <%--fileitem="${fns:ftpImgUrl(site.logoSite)}" imgWidth="200" imgHeight="100"--%>
                    <%--isshow="true"/>--%>
                    <%--<img id="image-logoSite" src="${fns:ftpImgUrl(site.logoSite)}" style="display: block;max-width: 100%">--%>
                <img id="logoText" src="${empty site.logoSite ? '/images/upload-default-image1.png' : fns:ftpImgUrl(site.logoSite)}"
                     style="display:block;max-width: 200px;">
                <button type="button" id="uploadXX" class="btn">上传</button>
                <span class="help-inline">建议Logo大小：200 × 100（像素）</span>

            </div>
                <%-- <div class="controls">
                    <div >
                        <img id="imageLogoSite" width="200" height="100" src="${empty proProject.imgUrl ? '/images/upload.png' : fns:ftpImgUrl(site.logoSite)}">
                    </div>
                    <span class="help-inline"><button type="button" id="btnUploadAvatar" class="btn btn-primary btn-small">更改</button> 建议大小：76 × 76（像素）</span>
                </div> --%>
        </div>
        <div class="control-group">
            <label class="control-label">噢易Logo:</label>
            <div class="controls">
                <img src="/img/s-brandx161.png">
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">描述:</label>
            <div class="controls">
                <form:textarea path="description" htmlEscape="false" rows="4" maxlength="200" class="input-xxlarge"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">关键字:</label>
            <div class="controls">
                <form:input path="keywords" htmlEscape="false" maxlength="200"/>
                <span class="help-inline">填写描述及关键字，有助于搜索引擎优化</span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">默认主题:</label>
            <div class="controls">
                <form:select path="theme" class="input-medium">
                    <form:options items="${fns:getDictList('cms_theme')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">版权信息:</label>
            <div class="controls">
                <form:textarea id="copyright" htmlEscape="true" path="copyright" rows="4" maxlength="200"
                               class="input-xxlarge"/>
                <sys:ckeditor replace="copyright" uploadPath="/cms/site"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">自定义首页视图:</label>
            <div class="controls">
                <form:input path="customIndexView" htmlEscape="false" maxlength="200"/>
            </div>
        </div>
        <div class="form-actions">
            <shiro:hasPermission name="cms:site:edit"><input id="btnSubmit" class="btn btn-primary" type="submit"
                                                             value="保 存"/>&nbsp;</shiro:hasPermission>
            <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>
    </form:form>
    <%-- <sys:testCut width="76" height="76" btnid="btnUploadAvatar" imgId="imageLogo" column="logo"  filepath="site"  className="modal-avatar"></sys:testCut>
    <sys:testCut width="200" height="100" btnid="btnUploadAvatar" imgId="imageLogoSite" column="logoSite"  filepath="site"  className="modal-avatar"></sys:testCut> --%>
    <sys:upLoadCutImage width="100" height="50" btnid="uploadXX" column="logoSite" imgId="logoText" filepath="temp/site"
                        className="modal-avatar hide" modalId="modalAvatar1"></sys:upLoadCutImage>
    <sys:upLoadCutImage width="76" height="76" btnid="uploadLogo" column="logo" imgId="logoImg" filepath="temp/site"
                        className="modal-avatar hide" modalId="modalAvatar2" aspectRatio="1"></sys:upLoadCutImage>
</div>
</body>
</html>