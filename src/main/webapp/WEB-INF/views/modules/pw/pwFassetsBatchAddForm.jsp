<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
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
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                        error.appendTo(element.parent().parent());
                    } else {
                        switch (element[0].id) {
                            case "category1":
                            case "category2":
                                error.appendTo(element[0].offsetParent);
                                break;
                            case "price":
                                error.appendTo(element[0].offsetParent);
                                break;
                            default:
                                error.insertAfter(element);
                                return false;
                        }
                    }
                }
            });


            /**
             * 根据资产类型查询资产名称
             */
            var $category2 = $("#category2");
            $("#category1").change(function () {
                var categoryId = $(this).children('option:selected').val();
                if (!categoryId) {
                    $category2.val('').find('option:not(:first-child)').remove()
                    return;
                }
                $.ajax({
                    url: '${ctx}/pw/pwCategory/childrenCategory',
                    type: 'GET',
                    dataType: 'json',
                    data: {
                        categoryId: categoryId
                    },
                    complete: function (data) {
                        if (data) {
                            var r = jQuery.parseJSON(data.responseText);
                            $category2 = $("#category2");
                            $category2.empty();
                            $category2.append("<option value='' selected='selected'>---请选择---</option>");
                            $.each(r, function (i, item) {
                                if (item.id == "${pwFassets.pwCategory.id}") {
                                    $category2.append("<option value='" + item.id + "' selected='selected'>" + item.name + "</option>");
                                } else {
                                    $category2.append("<option value='" + item.id + "'>" + item.name + "</option>");
                                }
                            })
                        }
                    }
                })
            });
            $("#category1").trigger('change');

        });
    </script>
    <style>
        .modal-backdrop, .modal-backdrop.fade.in{
            opacity: 0;
            z-index: -1;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>固定资产</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <ul class="nav nav-tabs">
        <li><a href="${ctx}/pw/pwFassets/">固定资产列表</a></li>
        <li class="active"><a href="${ctx}/pw/pwFassets/form?id=${pwFassets.id}">固定资产<shiro:hasPermission
                name="pw:pwFassets:edit">${not empty pwFassets.id?'修改':'批量添加'}</shiro:hasPermission><shiro:lacksPermission
                name="pw:pwFassets:edit">查看</shiro:lacksPermission></a></li>
    </ul>
    <sys:message content="${message}"/>
    <form:form id="inputForm" modelAttribute="pwFassetsModel" action="${ctx}/pw/pwFassets/batchSave" method="post"
               class="form-horizontal">
        <%--<form:hidden path="id"/>--%>
        <%--<form:hidden path="isNewRecord" value="${isNewRecord}"/>--%>
        <input type="hidden" id="secondName" name="secondName"value="${secondName}"/>
        <div class="control-group">
            <label class="control-label"><i>*</i>资产类型：</label>
            <div class="controls">
                <form:select path="pwFassets.pwCategory.parent.id" class="form-control required" id="category1">
                    <form:option value="" label="---请选择---"/>
                    <form:options items="${fns:findChildrenCategorys(null)}" itemLabel="name" itemValue="id"
                                  htmlEscape="false"/>
                </form:select>
                <a href="#pwCategoryTypeFormModal" data-toggle="modal">找不到？添加</a>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><i>*</i>资产名称：</label>
            <div class="controls">
                <form:select path="pwFassets.pwCategory.id" class="form-control required" id="category2">
                    <form:option value="" label="---请选择---"/>
                </form:select>
                <a href="#pwCategoryFormModal" data-toggle="modal">找不到？添加</a>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">品牌：</label>
            <div class="controls">
                <form:input path="pwFassets.brand"  type="text"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">规格：</label>
            <div class="controls">
                <form:input path="pwFassets.specification"  type="text"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">购买人：</label>
            <div class="controls">
                <form:input path="pwFassets.prname"  type="text"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">联系方式：</label>
            <div class="controls">
                <form:input path="pwFassets.phone" class="phone" type="text"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">购买时间：</label>
            <div class="controls">
						<span class="checkbox-inline">
						  <form:input path="pwFassets.time" type="text" class="Wdate" readonly="true"
                                      onfocus="WdatePicker({dateFmt: 'yyyy-MM-dd' })"/>
						</span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">单价：</label>
            <div class="controls">
                <form:input path="pwFassets.price" type="text"
                            class="number input-mini"  maxlength="10" id="price"/>
                <span class="help-inline">元（人民币）</span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">购买数量：</label>
            <div class="controls">
                <form:input path="amount" type="text" class="number digits input-mini" value="1" maxlength="3"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">备注：</label>
            <div class="controls">
                <form:textarea path="remarks" class="form-control input-xxlarge" maxlength="200"
                               rows="4"></form:textarea>
            </div>
        </div>
        <%--<div class="control-group">--%>
        <%--<label class="control-label">使用场地:</label>--%>
        <%--<div class="controls">--%>
        <%--<input type="text">--%>
        <%--<button type="button" class="btn btn-primary">分配</button>--%>
        <%--</div>--%>
        <%--</div>--%>

        <%--<div class="form-actions">--%>
        <%--<button id="sureBtn" type="button" class="btn btn-primary">保存</button>--%>
        <%--<button id="cancleBtn" type="button" class="btn btn-default">取消</button>--%>
        <%--</div>--%>
        <div class="form-actions">
            <shiro:hasPermission name="pw:pwFassets:edit">
                <input class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
            <input class="btn btn-default" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>
    </form:form>
</div>


<div id="pwCategoryFormModal" class="modal hide" data-backdrop="false" tabindex="-1" role="dialog"
     aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <span>资产类别</span>
    </div>
    <div class="modal-body">
        <form id="pwCategoryForm" class="form-horizontal">
            <div class="control-group">
                <label class="control-label">父类别：</label>
                <div class="controls">


                    <select name="parent.id" class="required">
                        <option value="">-请选择-</option>
                    </select>
                    <%--<sys:treeselectCategory id="parentId" name="parent.id" value="${pwCategory.parent.id}"--%>
                    <%--labelName="parent.name" labelValue="${pwCategory.parent.name}"--%>
                    <%--title="父级编号" url="/pw/pwCategory/pwCategoryTree"--%>
                    <%--extId="${pwCategory.id}" cssStyle="width:175px;"--%>
                    <%--allowClear="true"/>--%>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><i>*</i>资产名称：</label>
                <div class="controls">
                    <input type="text" name="name" maxlength="30" class="required"/>
                </div>
            </div>
            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span style="font-size: 14px;">编号规则</span>
                    <i class="line"></i>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><i>*</i>前缀：</label>
                <div class="controls">
                    <input type="text" name="pwFassetsnoRule.prefix" maxlength="24" class="required isLetter"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><i>*</i>开始编号：</label>
                <div class="controls">
                    <input type="text" name="pwFassetsnoRule.startNumber" maxlength="3"
                           class="required number digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><i>*</i>编号位数：</label>
                <div class="controls">
                    <input type="text" name="pwFassetsnoRule.numberLen" maxlength="3" class="required number digits"/>
                    <span class="help-inline gray-color">表示数字最小的位数，不足位数的前面补0</span>
                </div>
            </div>
        </form>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal" aria-hidden="true">关闭</button>
        <button type="button" class="btn btn-primary">保存</button>
    </div>
    <div class="modal-backdrop in"></div>
</div>


<div id="pwCategoryTypeFormModal" class="modal hide" data-backdrop="false" tabindex="-1" role="dialog"
     aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <span>资产类别</span>
    </div>
    <div class="modal-body">
        <form id="pwCategoryTypeForm" class="form-horizontal">
            <input type="hidden" name="parent.id" value="1"/>
            <div class="control-group">
                <label class="control-label"><i>*</i>资产类别：</label>
                <div class="controls">
                    <input type="text" name="name" maxlength="30" class="required"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><i>*</i>前缀(编号规则)：</label>
                <div class="controls">
                    <input type="text" name="pwFassetsnoRule.prefix" maxlength="3" class="required"/>
                </div>
            </div>
        </form>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal" aria-hidden="true">关闭</button>
        <button type="button" class="btn btn-primary">保存</button>
    </div>
    <div class="modal-backdrop in"></div>
</div>
<div id="dialog-message" title="信息">
    <p id="dialog-content"></p>
</div>
<script>


    // 前缀字母验证
    jQuery.validator.addMethod("isLetter", function (value, element) {
        var reg = /^[a-z,0-9]+$/i;
        return this.optional(element) || (reg.test(value));
    }, "只能输入数字或者字母");

    $(function () {


        var $category1 = $('#category1');
        var $category2 = $('#category2');

        var $pwCategoryTypeForm = $('#pwCategoryTypeForm');
        var $pwCategoryTypeFormModal = $('#pwCategoryTypeFormModal');
        var $pwCTFBtnSave = $pwCategoryTypeFormModal.find('.btn-primary');
        var pwCategoryTypeForm = $pwCategoryTypeForm.validate();


        var $pwCategoryForm = $('#pwCategoryForm');
        var $pwCategoryFormModal = $('#pwCategoryFormModal');
        var $btnPwTf = $pwCategoryFormModal.find('.btn-primary');
        var categoryList = JSON.parse('${fns:toJson(fns:findChildrenCategorys(null))}');

        var cateSelect = $pwCategoryForm.find('select[name="parent.id"]')


        $pwCTFBtnSave.on('click', function () {
            var xhr;
            var name = $pwCategoryTypeFormModal.find('input[name="name"]').val();
            if (pwCategoryTypeForm.form()) {
                xhr = $.post('${ctx}/pw/pwCategory/asySave', $pwCategoryTypeForm.serialize());
                xhr.success(function (data) {
                    data = $.parseJSON(data);
                    if (data.success) {
                        resetCateTypeForm();
                        getFassetType(data.id);
                        $('select[name="pwCategory.id"]').val('').find('option:not(:first)').remove();
                        $pwCategoryTypeFormModal.modal('hide');
                        top.$.jBox.tip('添加资产类别' + name + '成功', '系统提示');
                    } else {
                        top.$.jBox.info(data.msg, '系统提示');
                    }
                    top.$('.jbox-body .jbox-icon').css('top', '55px');
                })
                xhr.error(function (error) {
                    top.$.jBox.info(data.msg, '网络错误');
                    top.$('.jbox-body .jbox-icon').css('top', '55px');
                })
            }
        })

        //清空表单
        function resetCateTypeForm() {
            pwCategoryTypeForm.resetForm();
            $pwCategoryTypeForm[0].reset();
        }

        //获取资产类型
        function getFassetType(id) {
            var xhr = $.get('${ctx}/pw/pwCategory/childrenCategory');
            $category1.find('option:not(:first)').remove();
            cateSelect.find('option:not(:first)').remove();
            xhr.success(function (data) {
                data.forEach(function (t) {
                    cateSelect.append('<option ' + (id === t.id ? 'selected' : '') + ' value="' + t.id + '">' + t.name + '</option>')
                    $category1.append('<option ' + (id === t.id ? 'selected' : '') + ' value="' + t.id + '">' + t.name + '</option>');
                })
            });
        }


        //关闭
        $pwCategoryTypeFormModal.on('hide', function () {
            resetCateTypeForm()
        })


        $.each(categoryList, function (i, item) {
            $pwCategoryForm.find('select[name="parent.id"]').append('<option value="' + item.id + '">' + item.name + '</option>')
        })

        var pwCategoryForm = $pwCategoryForm.validate({
            rules: {
                'parent.name': 'required'
            },
            messages: {
                'parent.name': {
                    required: '必填信息'
                }
            },
            errorPlacement: function (error, element) {
                if (element.parent().is(".input-append")) {
                    error.appendTo(element.parent());
                } else {
                    error.insertAfter(element);
                }
            }
        })

        $pwCategoryFormModal.on('show', function () {
            $pwCategoryFormModal.find('select[name="parent.id"]').val($category1.val())
        })

        $btnPwTf.on('click', function () {
            var xhr, name;
            if (pwCategoryForm.form()) {
                name = $pwCategoryForm.find('input[name="name"]').val();
                xhr = $.post('${ctx}/pw/pwCategory/asySave', $pwCategoryForm.serialize());
                xhr.success(function (data) {
                    data = jQuery.parseJSON(data);
                    if (data.success) {
                        $pwCategoryFormModal.modal('hide')
                        resetCateForm();
                        getAssets(data.id);
                        top.$.jBox.tip('添加资产名称' + name + '成功', '系统提示');
                    } else {
                        top.$.jBox.info(data.msg, '系统提示');
                    }
                    top.$('.jbox-body .jbox-icon').css('top', '55px');
                })
                xhr.error(function (error) {
                    top.$.jBox.info(data.msg, '网络错误');
                    top.$('.jbox-body .jbox-icon').css('top', '55px');
                })
            }
        })

        function resetCateForm() {
            $pwCategoryForm[0].reset();
            pwCategoryForm.resetForm();
        }

        $pwCategoryFormModal.on('hide', function () {
            resetCateForm()
        })


        function getAssets(id) {
            var categoryId = $('#category1').val();
            var xhr;
            if (!categoryId) {
                return false;
            }
            xhr = $.get('${ctx}/pw/pwCategory/childrenCategory', {categoryId: categoryId});
            $category2.find('option:not(:first)').remove();
            xhr.success(function (data) {
                if (data.length > 0) {
                    data.forEach(function (t) {
                        $category2.append('<option ' + (id === t.id ? 'selected' : '') + ' value="' + t.id + '">' + t.name + '</option>');
                    })
                }
            });
            xhr.error(function () {

            })
        }

    })
</script>
</body>
</html>