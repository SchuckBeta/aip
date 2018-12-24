<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="decorator" content="site-decorator"/>
    <title>${frontTitle}</title>
    <link rel="stylesheet" type="text/css" href="/common/common-css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/bootstrap/2.3.1/awesome/font-awesome.min.css">
    <link href="/css/excellent/lessonProjectEditCommon.css" rel="stylesheet">
    	<!-- 配置文件 -->
    <script type="text/javascript" src="/static/ueditor/ueditor.config.js"></script>
    <!-- 编辑器源码文件 -->
    <script type="text/javascript" src="/static/ueditor/ueditor.all.js"></script>
    <script src="/other/jquery.form.min.js" type="text/javascript" charset="utf-8"></script>
    <style>
        .preview{
            height: auto;
        }
    </style>
</head>

<body>

<div class="container lp-edit-container" style="width: 1270px;padding-top: 60px">
     <form:form id="projectEditForm" modelAttribute="es"  action="save" method="post">
     	<input type="hidden" name="id" value="${es.id }"/>
     	<input type="hidden" name="foreignId" value="${es.foreignId }"/>
     	<input type="hidden" name="type" value="${es.type }"/>
     	<input type="hidden" name="subType" value="${es.subType }"/>
        <input type="hidden" name="managed" value="${es.managed }"/>
        <input type="hidden" id="isRelease" name="isRelease" value="${es.isRelease }"/>
        <div class="title-box">
            <h2 class="title">${projectInfo.name }</h2>
            <c:if test="${es.type=='0000000075' }">
            	<p class="source">项目来源：${fns:getDictLabel(es.subType, 'project_style', '')}</p>
	    	</c:if>
	        <c:if test="${es.type=='0000000076' }">
	    		<p class="source">项目来源：${fns:getDictLabel(es.subType, 'competition_type', '')}</p>
	    	</c:if>
        </div>
        <div class="row form-row" style="margin-top: 30px;">
            <div class="col-md-6" style="width: 360px;">
                <div style="margin-bottom: 15px;">
                    <div class="preview preview-default">
                        <img id="coverImg_show" src="${not empty es.coverImg ? fns:ftpImgUrl(es.coverImg) : '/img/1X1placeholderimg.png'}">
                    </div>
                    <input type="hidden" id="coverImg" name="coverImg" value="${es.coverImg}" />
                    <div class="btns-upload">
                        <a id="upload"  class="btn btn-primary-oe btn-sm">上传封面</a>
                            <%--<sys:coverImgUpload filepath="excellentCoverImg" coverimgshow="coverImg_show" btnid="upload"></sys:coverImgUpload>--%>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="row row-project-info">
                    <div class="col-md-2 col-w92">学院：</div>
                    <div class="col-md-9">
                    	${projectInfo.oname }
                    </div>
                </div>
                <div class="row row-project-info">
                    <div class="col-md-2 col-w92">指导老师：</div>
                    <div class="col-md-6">
                        <ul class="teachers">
	                         <c:forEach items="${projectTeacherInfo}" var="item" >
	                         	<li>
	                                <span>${item.uname }</span><span>${item.oname }</span><span>${item.post_title }</span>
	                            </li>
	                         </c:forEach>
                        </ul>
                    </div>
                </div>
                <div class="form-horizontal form-keyword">
                    <div class="form-group">
                        <label class="control-label col-md-2">关键词：</label>
                        <div class="col-md-5">
                            <input type="text" class="form-control form-keyword" id="formKeyword" autocomplete="off" placeholder="输入关键字按回车键添加">
                        </div>
                        <div class="col-md-3 col-error">
                        </div>
                    </div>
                </div>
                <div class="row row-keyword">
                    <div class="col-md-2 col-w92"></div>
                    <div class="col-md-9 col-offset-md-2 col-offset-w92 col-keyword-box">
                    	<c:forEach items="${es.keywords}" var="item" >
                    		<span class="keyword">
                    			<input name="keywords" value="${item}" type="hidden"/>
	                    		<span>${item}</span>
	                    		<a class="delete-keyword" href="javascript:void(0);" onclick="delKey(this);">×</a>
                    		</span>
                    	</c:forEach>
                    </div>
                </div>
            </div>
        </div>
        <div class="form-horizontal form-bottom">
            <div class="form-group">
                <label class="control-label col-md-1">页面模板：</label>
                <div class="col-md-4">
                    <select id="temp"  class="form-control form-template" onchange="ontempchange()">
						<option tempcontent="" value="" selected="selected">--选择布局模板--</option>
						<c:forEach items="${fns:getExcTemplateList()}" var="item" varStatus="status">
							<option tempcontent="${item.content}" value="${item.value}" >${item.name}</option>
						</c:forEach>
					</select>
                </div>
                <div class="col-md-4 col-error">

                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-1"><i class="icon-require">*</i>页面内容：</label>
                <div class="col-md-8">
                    	<script id="container" name="content" type="text/plain" style="width:800px;height:600px">
        					${es.content}
    					</script>
                </div>
            </div>
        </div>
        <div class="btn-tool">
            <button type="button" class="btn btn-primary-oe" onclick="preview()">预览</button>
            <button id="btnSave" type="button" class="btn btn-primary-oe">保存</button>
            <c:if test="${fromPage=='gcontest'}">
            	<button type="button" class="btn btn-primary-oe" onclick="javascript:location.href='/f/gcontest/gContest/list'">返回</button>
        	</c:if>
        	<c:if test="${fromPage=='project'}">
            	<button type="button" class="btn btn-primary-oe" onclick="javascript:location.href='/f/project/projectDeclare/list'">返回</button>
        	</c:if>
        	<input type="hidden" id="fromPage" value="${fromPage }">
        </div>
    </form:form>
</div>
<sys:frontCutImageCommon btnid="upload" column="coverImg" imgId="coverImg_show" filepath="excellentCoverImg" className="modal-avatar"></sys:frontCutImageCommon>

<script src="/js/excellent/frontLessonProjectEditCommon.js" type="text/javascript"></script>
<div id="dialog-message" title="信息" style="display: none;">
    <p id="dialog-content"></p>
</div>
<script>
    $(function () {
        var cropperPreviewFlag = false;
        var $previews = $('.preview-avatar');
        $(btnid).uploadAvatar({
            cropperOption: {
                aspectRatio: 16 / 9,
                crop: function(e){
                    if(!cropperPreviewFlag){
                        cropperPreviewFlag = true;
                        var $clone = $('img.cropper-hidden').clone().removeClass('cropper-hidden');
                        $clone.css({
                            display: 'block',
                            width: '100%',
                            minWidth: 0,
                            minHeight: 0,
                            maxWidth: 'none',
                            maxHeight: 'none'
                        });
                        $previews.html($clone);
                    }
                    var imageData = $(this).cropper('getImageData');
                    var previewAspectRatio = e.width / e.height;
                    $previews.each(function () {
                        var $preview = $(this);
                        var previewWidth = $preview.width();
                        var previewHeight = previewWidth / previewAspectRatio;
                        var imageScaledRatio = e.width / previewWidth;
                        $preview.height(previewHeight).find('img').css({
                            width: imageData.naturalWidth / imageScaledRatio,
                            height: imageData.naturalHeight / imageScaledRatio,
                            marginLeft: -e.x / imageScaledRatio,
                            marginTop: -e.y / imageScaledRatio
                        });
                    });
                }
            },
            success: function(data){
                var $inputPhoto = $('input[name="' + column + '"]');
                $(imgId).attr('src',data.url);
                if($inputPhoto.size() > 0){
                    $inputPhoto.val(data.ftpUrl)
                }else{
                    $('<input name="' + column + '" type="hidden" value="'+data.ftpUrl+'">').insertAfter($(imgId));
                }
            }
        })
    })
</script>
</body>