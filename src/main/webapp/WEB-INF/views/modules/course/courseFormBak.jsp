<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <link rel="stylesheet" type="text/css" href="/css/course/jquery.typeahead.css"/>
    <%--<link rel="stylesheet" type="text/css" href="/css/course/lessonProjectEditCommon.css"/>--%>
    <%--<link rel="stylesheet" type="text/css" href="${ctxStatic}/webuploader/webuploader.css">--%>
    <link rel="stylesheet" type="text/css" href="/css/course/webuploadLesson.css?v=1">
    <%--<script type="text/javascript" src="${ctxStatic}/webuploader/webuploader.min.js"></script>--%>
    <script type="text/javascript" src="/js/course/jquery.typeahead.js"></script>
    <script type="text/javascript" src="/js/frontCyjd/uploaderFile.js"></script>
    <style>
        .table-layout{
            table-layout: fixed;
        }
        .typeahead__result .table th, .typeahead__result .table td{
            border: none;
            padding: 0;
        }
        #uploadCover .filelist .info {
            position: absolute;
            left: 4px;
            bottom: 4px;
            right: 4px;
            height: 20px;
            line-height: 20px;
            text-indent: 5px;
            background: rgba(0, 0, 0, 0.6);
            color: white;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
            font-size: 12px;
            z-index: 10;
        }
        #uploadCover .file-item{
            position: relative;
        }

    </style>
    <script>
        var video = "${course.video}";
        $(function () {
            if (video != "") {
                $("#previewVideo").show();
            }

            var validator = $("#inputForm").validate({
                ignore: "",
                errorPlacement: function (error, element) {
                    if (element.is(":checkbox") || element.is(":radio")) {
                        error.appendTo(element.parent().parent());
                    } else {
                        error.insertAfter(element);
                    }
                }
            });


            $("#btnSubmit").click(function () {

                var formData = $("#inputForm").serialize();
                var teacherFlag = true;
                //增加授课老师数据
                $("#teacherSearchResult tbody tr").each(function (i, tr) {
                    var $tr = $(tr);
                    if (!$tr.find('>td').eq(0).hasClass("teacher-empty")) {
                        var $td0 = $tr.find('>td').eq(0);
                        var $td1 = $tr.find('>td').eq(1);
                        var $td2 = $tr.find('>td').eq(2);
                        var teacherId = $td0.attr('data-id');
                        var teacherName = $td0.text();
                        var collegeName = $td1.text();
                        var postName = $td2.text();
                        var teacherList = "teacherList[" + i + "]";
                        formData = formData + "&" + teacherList + ".teacherId=" + teacherId
                                + "&" + teacherList + ".teacherName=" + teacherName
                                + "&" + teacherList + ".collegeName=" + collegeName
                                + "&" + teacherList + ".postName=" + postName;
                    } else {
                        teacherFlag = false;
                    }

                });

//                //增加课件数据
//                $("#fileLessonList a").each(function(i,a){
//                    var $a= $(a);
//                    var attachmentList =  "attachmentList["+i+"]";
//                    var url = $a.attr('data-ftp-url');
//                    var name = $a.attr('data-original');
//                    var size = $a.attr('data-size');
//                    var suffix = $a.attr('data-type');
//                    formData = formData+"&"+attachmentList+".url="+url
//                            +"&"+attachmentList+".name="+name
//                            +"&"+attachmentList+".size="+size
//                            +"&"+attachmentList+".suffix="+suffix ;
//                });

                if (validator.form()) {
                    if (!teacherFlag) {
                        top.$.jBox.tip('请至少选择一位授课教师', 'warning');
                        $("#btnSearchTeacher").focus();
                        return false;
                    }
                    $("#btnSubmit").prop("disabled", true);
                    $.ajax({
                        type: 'post',
                        url: '/a/course/saveJson',
                        dataType: 'json',
                        data: formData,
                        success: function (data) {
                            if (data) {
                                if ("${course.id}" == "") {
                                    confirmx("添加课程成功,是否继续添加课程", "/a/course/form", "/a/course");
                                } else {
                                    alertx("修改课程成功", "/a/course");
                                }
                            }
                        }
                    });
                }
            })
        })

        //        function downFile(obj){
        //            var url=$(obj).attr("data-ftp-url");
        //            var fileName=$(obj).attr("data-original")+"."+$(obj).attr('data-type');
        //            console.log("/ftp/loadUrl?url="+url+"&fileName="+encodeURI(encodeURI(fileName)));
        //            location.href="/ftp/loadUrl?url="+url+"&fileName="+encodeURI(encodeURI(fileName));
        //        }

    </script>
</head>
<body>


<div class="container-fluid">
    <div class="edit-bar edit-bar-tag clearfix">
        <div class="edit-bar-left">
            <span>课程管理</span>
            <i class="line weight-line"></i>
        </div>
    </div>
    <form:form id="inputForm" modelAttribute="course" action="${ctx}/course/save" method="post" class="form-horizontal">
        <form:hidden path="id"/>
        <div class="control-group">
            <label class="control-label"><i>*</i>名称：
            </label>
            <div class="controls">
                <form:input path="name" htmlEscape="false" maxlength="200" class="required input-xlarge"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">封面：</label>
            <div class="controls" style="width: 120px;">
                <div id="uploadCover">
                    <form:hidden path="coverImg" htmlEscape="false" maxlength="255"/>
                    <ul id="fileListCover" class="filelist" style="margin: 0;padding: 0">
                        <c:if test="${ not empty  course.coverImg}">
                            <li class="file-item thumbnail">
                                <img src="${fns:ftpImgUrl(course.coverImg)}"/>
                            </li>
                        </c:if>
                    </ul>
                    <div id="filePicker" class="upload-content">上传封面</div>
                </div>
            </div>

        </div>
        <div class="control-group">
            <label class="control-label">视频：</label>
            <div class="controls">
                <div class="clearfix">
                    <div id="uploadVideo">
                        <form:hidden path="video" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                        <ul id="fileVideoList" class="filelist" style="margin:0;padding: 0"></ul>
                        <div id="filePickerVideo" class="upload-content">
                        </div>
                    </div>
                    <div id="previewVideo" class="preview-video">
                        <c:if test="${ not empty  course.video}">
                            <video controls="" src="${fns:ftpImgUrl(course.video)}"></video>
                        </c:if>
                        <c:if test="${ empty  course.video}">
                            <video controls="" src=""></video>
                        </c:if>
                    </div>

                </div>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="description">
                <i>*</i>课程描述：
            </label>
            <div class="controls">
                <form:textarea path="description" htmlEscape="false" rows="5" maxlength="2000"
                               class="input-xxlarge required"/>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="btnSearchTeacher">
                添加授课教师：
            </label>
            <div class="controls" style="width: 544px;">
                <div class="typeahead__container">
                    <div class="typeahead__field">
			            <span class="typeahead__query">
			                <input type="text" id="btnSearchTeacher" class="typeahead form-control" autocomplete="off"
                                   placeholder="输入教师名字" data-provide="typeahead">

			            </span>
                    </div>
                </div>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">
                <i>*</i>授课教师列表：
            </label>
            <div class="controls" style="width: 544px;">
                <table id="teacherSearchResult"
                       class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
                    <thead>
                    <tr>
                        <td>姓名</td>
                        <td>学院名</td>
                        <td>职位</td>
                        <td>操作</td>
                    </tr>
                    </thead>
                    <tbody>
                    <c:if test="${not empty course.teacherList}">
                        <c:forEach items="${course.teacherList}" var="teacher">
                            <tr>
                                <td data-id="${teacher.teacherId}">${teacher.teacherName}</td>
                                <td>${teacher.collegeName}</td>
                                <td>${teacher.postName}</td>
                                <td>
                                    <button type="button" class="btn btn-small btn-default btn-delete-teacher">删除
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty course.teacherList}">
                        <tr>
                            <td colspan="4" class="text-center teacher-empty">暂无授课老师,请添加</td>
                        </tr>
                    </c:if>

                    </tbody>
                </table>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="categoryValueList">
                <i>*</i>专业课程分类：
            </label>
            <div class="controls controls-checkbox">
                <form:checkboxes path="categoryValueList" items="${fns:getDictList('0000000086')}"
                                 itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="type">
                <i>*</i>课程类型分类：
            </label>
            <div class="controls controls-radio">
                <form:radiobuttons path="type" items="${fns:getDictList('0000000078')}"
                                   itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="status">
                <i>*</i>状态分类：
            </label>
            <div class="controls controls-radio">
                <form:radiobuttons path="status" items="${fns:getDictList('0000000082')}"
                                   itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="courseSummary">
                <i>*</i>课程介绍：
            </label>
            <div class="controls">
                <form:textarea path="courseSummary" htmlEscape="false" rows="5" maxlength="2000"
                               class="input-xxlarge required"/>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="teacherSummary">
                <i>*</i>教师简介：
            </label>
            <div class="controls">
                <form:textarea path="teacherSummary" htmlEscape="false" rows="5" maxlength="2000"
                               class="input-xxlarge required"/>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="teacherSummary">
                课件：
            </label>
            <div class="controls">
                <sys:frontFileUpload fileitems="${course.attachmentList}" className="accessories-h30" filepath="course" tip1="支持上传word、pdf、excel、txt、rar、ppt图片类型等课件"></sys:frontFileUpload>
                    <%--<div id="uploadLesson" class="upload-lesson">--%>
                    <%--&lt;%&ndash;<sys:frontFileUpload fileitems="${course.attachmentList}" filepath="course" btnid="filePickerLesson"></sys:frontFileUpload>&ndash;%&gt;--%>
                    <%--<div id="filePickerLesson">上传课件</div>--%>
                    <%--</div>--%>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="publishFlag">
                是否发布：
            </label>
            <div class="controls">
                <form:select path="publishFlag" class="input-medium">
                    <form:option value="" label="--请选择--"/>
                    <form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="topFlag">
                是否置顶：
            </label>
            <div class="controls">
                <form:select path="topFlag" class="input-medium">
                    <form:option value="" label="--请选择--"/>
                    <form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="commentFlag">
                是否评论：
            </label>
            <div class="controls">
                <form:select path="commentFlag" class="input-medium">
                    <form:option value="" label="--请选择--"/>
                    <form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="recommendFlag">
                是否推荐：
            </label>
            <div class="controls">
                <form:select path="recommendFlag" class="input-medium">
                    <form:option value="" label="--请选择--"/>
                    <form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
            </div>
        </div>

        <div class="form-actions">
                <%--<input id="btnSubmit" class="btn btn-primary" type="button" value="保 存"/>&nbsp;--%>
                <%--<input id="btnCancel" class="btn" type="button" value="返 回" />--%>
            <button id="btnSubmit" data-control="uploader" type="button" class="btn btn-primary">保存</button>
            <button type="button" data-control="uploader" class="btn btn-default" onclick="history.go(-1)">返回</button>
        </div>


    </form:form>
</div>
<div id="dialogCyjd" class="dialog-cyjd"></div>
<script type="text/javascript" src="/js/course/uploadCover.js"></script>
<script type="text/javascript" src="/js/course/uploadVideo.js?v=1"></script>
<script type="text/javascript">
    $(function () {
        var $btnSearchTeacher = $('#btnSearchTeacher');
        var $teacherSearchResult = $('#teacherSearchResult');
        var teachers =${fns:toJson(teachers)};

      var typeheadTest =  $.typeahead({
            input: '#btnSearchTeacher',
            minLength: 0,
            maxItem: 8,
//            hint: true,
            accent: true,
            emptyTemplate: '<table class="table table-center table-layout" style="margin: 0"><tr><td  class="text-center">没有结果</td></tr></table>',
            template: '<table class="table table-center table-layout" style="margin: 0"><tr><td>{{teacherName}}</td><td>{{collegeName}}</td><td>{{postName}}</td></tr></table>',
            display: ['teacherName', 'collegeName', 'postName'],
            source: teachers,
            searchOnFocus: true,
            templateValue: '{{teacherName}}',
            callback: {
                onLayoutBuiltAfter: function () {
                    if ($('.typeahead__item_head').size() < 1) {
                        $('<li class="typeahead__item typeahead__group-group typeahead__item_head"><div class="typeahead__item_head_box"><table class="table table-center table-layout" style="margin: 0"><tr><td>姓名</td><td>学院名</td><td>职位</td></tr></table></div></li>').insertBefore('.typeahead__list>li:first')
                    }
                },
                onClickAfter: function (node, query, result, resultCount) {
                    var isEmptyTeacher = $teacherSearchResult.find('.teacher-empty').size() < 1;
                    var isSameTeacher = hasSameTeacher(result.teacherId);
                    if (isEmptyTeacher) {
                        if (!isSameTeacher) {
                            $teacherSearchResult.find('tbody').append(templateTd(result));
                            $btnSearchTeacher.val('');
                            typeheadTest.query = '';
                            typeheadTest.rawQuery = '';
                            $btnSearchTeacher.blur()
//                            $btnSearchTeacher.blur()
                        }
                    } else {
                        $teacherSearchResult.find('tbody').empty().append(templateTd(result));
                        $btnSearchTeacher.val('');
                        typeheadTest.query = '';
                        typeheadTest.rawQuery = '';
                        $btnSearchTeacher.blur()
                    }
                }
            },
            debug: false
        });

        $(document).on('click', '.btn-delete-teacher', function (e) {
            var isEmptyTr;
            $(this).parent().parent().detach();
            isEmptyTr = $teacherSearchResult.find('tbody>tr').size() < 1;
            if (isEmptyTr) {
                $teacherSearchResult.find('tbody').append('<tr><td colspan="4" class="text-center teacher-empty">暂无授课老师,请添加</td></tr>')
            }
        });


        function templateTd(result) {
            return ('<tr><td data-id="' + result.teacherId + '">' + result.teacherName + '</td><td>' + result.collegeName + '</td><td>' + result.postName + '</td><td><button type="button" class="btn btn-small btn-default btn-delete-teacher">删除</button></td></tr>')
        }

        function hasSameTeacher(id) {
            var $tds = $('#teacherSearchResult>tbody>tr>td');
            var sameTeacher = false;
            $tds.each(function (i, td) {
                var tdId = $(td).attr('data-id');
                if (tdId == id) {
                    sameTeacher = true;
                    return false;
                }
            });
            return sameTeacher;
        }

        $('#uploadLesson').on('click', '.file-item-created .icon-remove-sign', function () {
            $(this).parents('.file-item').detach()
        })
    })
</script>
</body>

</html>