<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>导师信息管理</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
        $(document).ready(function () {
            //$("#name").focus();
            $("#inputForm").validate({
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                errorContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if (element.is(":checkbox")
                            || element.is(":radio")
                            || element.parent().is(
                                    ".input-append")) {
                        error.appendTo(element.parent()
                                .parent());
                    } else {
                        error.insertAfter(element);
                    }
                }
            });
        });
    </script>
</head>
<body>
<ul class="nav nav-tabs">
    <li><a href="${ctx}/sys/backTeacherExpansion/">导师库列表</a></li>
    <li class="active"><a
            href="${ctx}/sys/backTeacherExpansion/form?id=${backTeacherExpansion.id}">导师库<shiro:hasPermission
            name="sys:backTeacherExpansion:edit">${not empty backTeacherExpansion.id?'修改':'添加'}</shiro:hasPermission>
        <shiro:lacksPermission name="sys:backTeacherExpansion:edit">查看</shiro:lacksPermission></a></li>
</ul>
<br/>
<form:form id="inputForm" modelAttribute="backTeacherExpansion"
           action="${ctx}/sys/backTeacherExpansion/save" method="post"
           class="form-horizontal">
    <form:hidden path="id"/>
    <sys:message content="${message}"/>
    <table>
        <tr>
            <td><label class="control-label">职工号：</label> <form:input
                    path="user.no" htmlEscape="false" maxlength="30" size="10"/></td>
            <td>
                <div class="control-group">
                    <label class="control-label">姓名：</label>
                    <div class="controls">
                        <form:input path="user.name" htmlEscape="false" maxlength="11"/>
                    </div>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">导师来源：</label>
                    <div class="controls">
                        <form:select path="teachertype" class="input-xlarge ">
                            <form:options items="${fns:getDictList('master_type')}"
                                          itemLabel="label" itemValue="value" htmlEscape="false"/>
                        </form:select>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td><label class="control-label">性别：</label>
                <div class="controls">
                    <form:select path="user.sex" class="input-xlarge ">
                        <form:options items="${fns:getDictList('sex')}"
                                      itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">出生年月：</label>
                    <div class="controls">
                        <input name="user.birthday" type="text" maxlength="20"
                               class="input-medium Wdate "
                               value="<fmt:formatDate value="${backTeacherExpansion.user.birthday}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                               onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
                    </div>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">国家/地区：</label>
                    <div class="controls">
                        <form:input path="user.area" htmlEscape="false" maxlength="128"
                                    class="input-xlarge "/>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="control-group">
                    <label class="control-label">民族：</label>
                    <div class="controls">
                        <form:select path="user.national" class="input-xlarge ">
                            <form:option value="" label="--请选择--"/>
                            <form:options items="${fns:getDictList('national_type')}"
                                          itemLabel="label" itemValue="value" htmlEscape="false"/>
                        </form:select>
                    </div>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">政治面貌：</label>
                    <div class="controls">
                        <form:select path="user.political" class="input-xlarge ">
                            <form:option value="" label="--请选择--"/>
                            <form:options items="${fns:getDictList('poli_type')}"
                                          itemLabel="label" itemValue="value" htmlEscape="false"/>
                        </form:select>
                    </div>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">服务意向：</label>
                    <div class="controls">
                        <form:select path="serviceIntention" class="input-xlarge ">
                            <form:option value="" label="--请选择--"/>
                            <form:options items="${fns:getDictList('master_help')}"
                                          itemLabel="label" itemValue="value" htmlEscape="false"/>
                        </form:select>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="control-group">
                    <label class="control-label">证件号：</label>
                    <div class="controls">
                        <form:input path="user.idNumber" htmlEscape="false"
                                    maxlength="128" class="input-xlarge "/>
                    </div>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">学历类别：</label>
                    <div class="controls">
                        <form:input path="educationType" htmlEscape="false"
                                    maxlength="128" class="input-xlarge "/>
                    </div>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">学历：</label>
                    <div class="controls">
                        <form:input path="arrangement" htmlEscape="false" maxlength="128"
                                    class="input-xlarge "/>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="control-group">
                    <label class="control-label">学科门类：</label>
                    <div class="controls">
                        <form:select path="discipline" class="input-xlarge ">
                            <form:option value="" label="--请选择--"/>
                            <form:options items="${fns:getDictList('0000000111')}"
                                          itemLabel="label" itemValue="value" htmlEscape="false"/>
                        </form:select>
                    </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">学位：</label>
                    <form:select path="user.degree" class="input-xlarge ">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('degree_type')}"
                                      itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">院系名称：</label>
                    <div class="controls">
                        <select name="user.office.id">
                            <c:forEach items="${offices }" var="office">
                                <option value="${office.id }"
                                        <c:if test="${backTeacherExpansion.user.sex==0}">selected="selected"</c:if>>${office.name }</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="control-group">
                    <label class="control-label">专业名称：</label>
                    <div class="controls">
                        <form:input path="user.professional" htmlEscape="false"
                                    maxlength="128" class="input-xlarge "/>
                    </div>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">行业：</label>
                    <div class="controls">
                        <form:input path="industry" htmlEscape="false" maxlength="128"
                                    class="input-xlarge "/>
                    </div>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">职务/职称：</label>
                    <div class="controls">
                        <form:input path="technicalTitle" htmlEscape="false"
                                    maxlength="128" class="input-xlarge "/>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="control-group">
                    <label class="control-label">推荐单位：</label>
                    <div class="controls">
                        <form:input path="recommendedUnits" htmlEscape="false"
                                    maxlength="128" class="input-xlarge "/>
                    </div>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">工作简历：</label>
                    <div class="controls">
                        <form:input path="resume" htmlEscape="false" maxlength="128"
                                    class="input-xlarge "/>
                    </div>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">技术领域：</label>
                    <div class="controls">
                        <form:input path="user.domain" htmlEscape="false" maxlength="128"
                                    class="input-xlarge "/>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="control-group">
                    <label class="control-label">证件类型：</label>
                    <div class="controls">
                        <form:input path="user.idType" htmlEscape="false" maxlength="128"
                                    class="input-xlarge "/>
                    </div>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">成果名称：</label>
                    <div class="controls">
                        <form:select path="result" class="input-xlarge ">
                            <form:option value="" label="--请选择--"/>
                            <form:options
                                    items="${fns:getDictList('competition_net_prise')}"
                                    itemLabel="label" itemValue="value" htmlEscape="false"/>
                        </form:select>
                    </div>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">学历：</label>
                    <div class="controls">
                        <form:input path="user.education" htmlEscape="false" maxlength="128"
                                    class="input-xlarge "/>
                    </div>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">获奖名称：</label>
                    <div class="controls">
                        <form:input path="award" htmlEscape="false" class="input-xlarge "/>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="control-group">
                    <label class="control-label">评审项目名称：</label>
                    <div class="controls">
                        <form:input path="reviewName" htmlEscape="false" maxlength="128"
                                    class="input-xlarge "/>
                    </div>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">是否公开：</label>
                    <form:select path="isOpen" class="input-xlarge ">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('open_Type')}"
                                      itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <label class="control-label">级别：</label>
                    <div class="controls">
                        <form:input path="level" htmlEscape="false" maxlength="11"
                                    class="input-xlarge  digits"/>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="form-actions">
                    <shiro:hasPermission name="sys:backTeacherExpansion:edit">
                        <input id="btnSubmit" class="btn btn-primary" type="submit"
                               value="保 存"/>&nbsp;</shiro:hasPermission>
                    <input id="btnCancel" class="btn" type="button" value="返 回"
                           onclick="history.go(-1)"/>
                </div>
            </td>
        </tr>
    </table>
</form:form>
</body>
</html>