<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>系统证书管理</title>
    <%@include file="/WEB-INF/views/include/backtable.jsp" %>
    <link rel="stylesheet" type="text/css" href="/other/jquery-ui-1.12.1/jquery-ui.css"/>
    <link rel="stylesheet" type="text/css" href="/static/cropper/cropper.min.css">
    <link rel="stylesheet" type="text/css" href="/css/sysCerti/sysCerti.css">
    <script type="text/javascript" src="/static/cropper/cropper.min.js"></script>
    <script src="/other/jquery-ui-1.12.1/jquery-ui.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" src="/js/uploadCutImageZs.js"></script>
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
                        error.insertAfter(element);
                    }
                }
            });
        });
    </script>
</head>
<body>
<div class="mybreadcrumbs">
    <span>系统证书</span>
</div>
<div class="content_panel">
    <ul class="nav nav-tabs">
        <li><a href="${ctx}/sys/sysCertificate/">系统证书设计</a></li>
        <c:if test="${not empty sysCertificate.id}">
            <li class="active">
                <a href="${ctx}/sys/sysCertificate/design?id=${sysCertificate.id}">系统证书设计<shiro:lacksPermission
                        name="sys:sysCertificate:edit">查看</shiro:lacksPermission></a>
            </li>
        </c:if>
    </ul>
    <br/>
    <form:form id="inputForm" modelAttribute="sysCertificate" action="${ctx}/sys/sysCertificate/save" method="post"
               class="form-horizontal">
        <form:hidden path="id"/>
        <sys:message content="${message}"/>
        <div class="control-group">
            <label class="control-label">证书名称：</label>
            <div class="controls">
                    ${sysCertificate.name }
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">证书编号：</label>
            <div class="controls">
                    ${sysCertificate.no }
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">证书类型：</label>
            <div class="controls">
                    ${fns:getDictLabel(sysCertificate.type, 'sys_certificate_type', '-')}
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">所属机构：</label>
            <div class="controls">
                    ${sysCertificate.office.id }
                    ${sysCertificate.office.name }
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">说明：</label>
            <div class="controls">
                    ${sysCertificate.remarks }
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">证书附件：</label>
            <div class="controls">
                <img id="logoText1" src="${empty proProject.imgUrl ? '/images/upload.png' : fns:ftpImgUrl(site.logo)}"
                     style="display:block;max-width: 50px;">
                <button type="button" id="filePickerLesson1" class="btn">上传</button>
                <span class="help-inline">建议Logo大小：300 × 600（像素）</span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">水印附件：</label>
            <div class="controls">
                <img id="logoText2" src="${empty proProject.imgUrl ? '/images/upload.png' : fns:ftpImgUrl(site.logo)}"
                     style="display:block;max-width: 50px;">
                <button type="button" id="filePickerLesson2" class="btn">上传</button>
                <span class="help-inline">建议Logo大小：100 × 100（像素）</span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">水印合成：</label>
            <div class="controls">
                <button type="button" class="btn btn-preview-file">预览证书</button>
            </div>
        </div>
        <div class="form-actions">
            <shiro:hasPermission name="sys:sysCertificate:edit"><input id="btnSubmit" class="btn btn-primary"
                                                                       type="submit"
                                                                       value="保 存"/>&nbsp;</shiro:hasPermission>
            <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>
    </form:form>
    <%--<sys:upLoadCutImageZs width="300" height="600" btnid="filePickerLesson1" column="sysCertificate.zsfile"--%>
    <%--imgId="logoText1" filepath="sysCertificate/10000" className="modal-avatar hide"--%>
    <%--modalId="modalAvatar1" aspectRatio="0.5"></sys:upLoadCutImageZs>--%>
    <%--<sys:upLoadCutImageZs width="50" height="50" btnid="filePickerLesson2" column="sysCertificate.waterfile"--%>
                          <%--imgId="logoText2" filepath="sysCertificate/10001" className="modal-avatar hide"--%>
                          <%--modalId="modalAvatar2" aspectRatio="1"></sys:upLoadCutImageZs>--%>
</div>

<div class="waterMark-cond">
    <div class="container-fluid">
        <div class="row-fluid">
            <div class="span4">
                <form id="waterForm" class="form-horizontal">
                    <div class="control-group">
                        <label class="control-label">宽度：</label>
                        <div class="controls">
                            <input type="text" name="wsizeWidth" class="form-control" value="100">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">高度：</label>
                        <div class="controls">
                            <input type="text" name="wsizeHeight" class="form-control" value="100">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">X轴：</label>
                        <div class="controls">
                            <input type="text" name="rateX" class="form-control" value="50">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Y轴：</label>
                        <div class="controls">
                            <input type="text" name="rateY" class="form-control" value="50">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">角度：</label>
                        <div class="controls">
                            <input type="text" name="angle" class="form-control" value="0">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">透明度：</label>
                        <div class="controls">
                            <input type="text" name="alpha" class="form-control" value="100">
                        </div>
                    </div>
                </form>
            </div>
            <div class="span8">
                <div id="canvasContainer"></div>
            </div>
        </div>
    </div>
</div>


<div id="modalZs" class="modal fade hide">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <p style="margin-bottom: 0">更改图片</p>
            </div>
            <div class="modal-body">
                <div class="avatar-content">
                    <div class="avatar-area">
                        <div style="margin-bottom: 10px;">
                            <input class="avatar-file" type="file" style="display: none">
                            <button type="button" class="btn-upload-image btn btn-primary-oe">上传图片</button>
                            <label class="radio inline">
                                <input type="radio" name="certificate" value="1" checked>原版
                            </label>
                            <label class="radio inline">
                                <input type="radio" name="certificate" value="0.7">竖向证书
                            </label>
                            <label class="radio inline">
                                <input type="radio" name="certificate" value="1.6">横向证书
                            </label>
                        </div>
                        <div class="cut-avatar-area"></div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">取消</button>
                <button class="btn btn-primary-oe btn-modal-upload">上传</button>
            </div>
        </div>
    </div>
</div>

<div id="dialog-message" title="信息">
    <p id="dialog-content"></p>
</div>

<script>

    $(function () {

        var $filePickerLesson = $('#filePickerLesson1');

        $filePickerLesson.uploadAvatar({
            modal: '#modalZs',
            url: $frontOrAdmin+'/ftp/ueditorUpload/cutImg?folder=sysCertificate/10000&x={{x}}&y={{y}}&width={{width}}&height={{height}}',
            avatarPic: '#logoText1',
            fileVal: 'upfile',
            cropperOption: {
//                aspectRatio:aspectRatio || 1,
//                minCropBoxWidth: width,
//                minCropBoxHeight: height,
                crop: function (e) {

                }
            },
            success: function (data) {
                var $logoText = $('#logoText1');
                var $inputPhoto = $('input[name="sysCertificate/10000"]');
                $logoText.attr('src', data.url);
                if ($inputPhoto.size() > 0) {
                    $inputPhoto.val(data.ftpUrl)
                } else {
                    $('<input name="sysCertificate/10000" type="hidden" value="' + data.ftpUrl + '">').insertAfter($logoText);
                }
            }
        });


        var $btnPreviewFile = $('.btn-preview-file');
        var zfCanvas;
        var zfBase64Url = 'http://localhost:8081/images/upload.png';
        var waterBase64Url = 'http://localhost:8081/images/upload.png';
        var $waterForm = $('#waterForm');
        var scaleRatio;
        var zfDefault = {
            width: 150,
            height: 300
        };


        $('#modalZs').on('uploadSuccess', function (e, file, url, imgData) {
            zfBase64Url = url;
            var width = imgData.width;
            var height = imgData.height;
            var ratio = width / height;
            if (ratio < 1) {
                width = width > 300 ? 300 : width;
                height = width == 300 ? 300 / ratio : height;
            } else {
                height = height > 400 ? 400 : height;
                width = height == 400 ? 400 / ratio : width;
            }
            scaleRatio = 1;
            zfDefault.width = width;
            zfDefault.height = height;

        });
        $('#modalAvatar2').on('uploadSuccess', function (e, file, url, imgData) {
            waterBase64Url = url;
        });


        function conData() {
            var data = {};
            $waterForm.find('input').each(function (i, item) {
                data[$(item).attr('name')] = $(item).val()
            });
            return data;
        }


        $btnPreviewFile.on('click', function (e) {
            if (!hasPics()) {
                showModalMessage(0, '请上传水印或者政府文件图片');
                return false
            }
            var zfSrc = zfBase64Url;
            var conDataObj = conData();
            //生产canvas

            $('#canvasContainer').find('canvas').detach();

            zfCanvas = canvas(zfDefault.width, zfDefault.height, 'canvasContainer');
//            clearCanvas(zfCanvas.ctx, zfDefault.width, zfDefault.height);

            //生成原图
            waterImg(conDataObj, function (url) {
                setCanvasImage(zfCanvas, zfSrc, 0, 0, zfDefault.width, zfDefault.height, function () {
                    setCanvasImage(zfCanvas, url, conDataObj.rateX, conDataObj.rateY, conDataObj.wsizeWidth * scaleRatio, conDataObj.wsizeHeight * scaleRatio);
                });
            })
        });


        //水印图片，回调导出图片
        function waterImg(conDataObj, callback) {
            var canvasObj = buildWaterCanvas(conDataObj);
            var waterSrc = waterBase64Url;
            var ctx = canvasObj.ctx;
            var alpha = conDataObj.alpha / 100;
            var width = conDataObj.wsizeWidth;
            var height = conDataObj.wsizeHeight;
            setCtxAlpha(ctx, alpha);
            setCanvasRotateCenter(ctx, conDataObj);
            setCanvasWaterPic(canvasObj, waterSrc, 0, 0, width * scaleRatio, height * scaleRatio, function (canvasObj) {
                callback && callback.call(null, canvasObj.canvas.toDataURL())
            })
        }

        //创建一个制作水印的画布
        function buildWaterCanvas(conDataObj) {
            var width = conDataObj.wsizeWidth;
            var height = conDataObj.wsizeHeight;
            return canvas(width, height);
        }

        //设置水印canvas图片
        function setCanvasWaterPic(canvas, src, x, y, width, height, callback) {
            var img = new Image();
            img.src = src;
            img.onload = function () {
                img.setAttribute('crossOrigin', 'anonymous');
                canvas.ctx.drawImage(img, x, y, width, height);
                callback && callback.call(null, canvas);
            }
        }

        //设置底层画布图片
        function setCanvasImage(canvas, src, x, y, width, height, callback) {
            var img = new Image();
            img.src = src;
            img.onload = function () {
                img.setAttribute('crossOrigin', 'anonymous');
                canvas.ctx.drawImage(img, x, y, width, height);
                callback && callback()
            }
        }

        //设置canvas围绕中心旋转
        function setCanvasRotateCenter(ctx, conDataObj) {
            var width = conDataObj.wsizeWidth;
            var height = conDataObj.wsizeHeight;
            var angle = conDataObj.angle;
            var x = width / 2; //画布宽度的一半
            var y = width / 2;//画布高度的一半
            clearCanvas(ctx, width, height);//先清掉画布上的内容
            ctx.translate(x, y);//将绘图原点移到画布中点
            ctx.rotate((Math.PI / 180) * angle);//旋转角度
            ctx.translate(-x, -y);//将画布原点移动
        }

        //设置透明度
        function setCtxAlpha(ctx, alpha) {
            ctx.globalAlpha = alpha
        }

        //设置canvas width height
        function setCanvasSize(canvas, w, h) {
            canvas.width = w;
            canvas.height = h;
        }

        //创建canvas
        function canvas(w, h, id) {
            var canvas = document.createElement('canvas');
            var ctx = canvas.getContext('2d');
            if (id) {
                $('#' + id).append(canvas);
            }
            setCanvasSize(canvas, w, h);
            return {
                canvas: canvas,
                ctx: ctx
            }
        }

        //清除画布
        function clearCanvas(ctx, w, h) {
            ctx.clearRect(0, 0, w, h);
        }

        //获取图片原始width
        function getZfPicWidth() {
            return $('#logoText1')[0].naturalWidth;
        }

        //获取图片原始height
        function getWaterPicWidth() {
            return $('#logoText2')[0].naturalWidth;
        }

        //判断两张图片是否已经上传
        function hasPics() {
            var $zsFile = $('input[name="sysCertificate.zsfile"]');
            var $waterFile = $('input[name="sysCertificate.waterfile"]');
            return ($zsFile.val() && $waterFile.val())
        }

        //获取参数请求
        function getPreviewXhr() {
            var xhr = $.get('url');
            xhr.error(function (err) {
                showModalMessage(0, err)
            });
            return xhr;
        }


        function showModalMessage(ret, msg, buttons) {
            var html = null;
            //ret 3种状态，0表示操作失败，1表示操作成功，2表示操作出现警告
            switch (parseInt(ret)) {
                case 0 :
                    html = createFailMessage(msg);
                    break;
                case 1 :
                    html = createOkMessage(msg);
                    break;
                case 2 :
                    html = warningMessage(msg);
                    break;
                default:
                    break;

            }
            $("#dialog-content").html(html);
            $("#dialog-message").dialog({
                modal: true,
                buttons: buttons || {
                    确定: function () {
                        $(this).dialog("close");
                    }
                }
            });
        }

    })

</script>
</body>
</html>