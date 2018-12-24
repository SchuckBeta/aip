<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/comment.css">
<script src="/js/interactive/comment.js?v=1" type="text/javascript"></script>
<script src="/static/common/mustache.min.js" type="text/javascript"></script>
<div class="edit-bar edit-bar-sm">
    <div class="edit-bar-left">
        <span>发表评论</span>
        <i class="line"></i>
        <a class="article-like" id="like_a" href="javascript:void (0);" onclick="like()"><i
                class="icon icon-thumbs-up"></i>(<span name="p55c4142a72584313a96a8e38d2d16368_likes">0</span>)</a>
    </div>
</div>
<div class="textarea-module">
    <textarea id="p55c4142a72584313a96a8e38d2d16368_content" placeholder="最多500个字" class="form-control"
              rows="5"></textarea>
    <div class="text-right">
        <button type="button" class="btn btn-primary" onclick="publish()">发表评论</button>
    </div>
</div>
<div class="comment-module">
    <ul class="tab-comment-nav clearfix">
        <li class="active" queryType="1" onclick="changeTab(this)"><a href="javascript:void(0);">全部评论(<span
                name="p55c4142a72584313a96a8e38d2d16368_comments">0</span>)</a></li>
        <li onclick="changeTab(this)" queryType="2"><a href="javascript:void(0);">我的评论(<span
                name="p55c4142a72584313a96a8e38d2d16368_mycomments">0</span>)</a></li>
    </ul>
    <div class="tab-comment">
        <div class="comments" id="comments">
        </div>
    </div>
    <div class="comment-load">
        <a href="javascript:void(0);" id="comment-load-btn" onclick="getNextPage()">加载更多评论</a>
    </div>
</div>
<script type="text/template" id="tpl">
    <div class="comment" comment_id="{{id}}">
        <img class="np-avatar" src="{{photo}}">
        <div class="comment-conent">
            <div class="comment-header">
                <a target="{{a_target}}" href="{{userUrl}}" class="np-user">{{name}}</a><span class="replay-at">{{create_date}}</span>
            </div>
            <div class="comment-body">{{content}}</div>
            <div class="comment-footer">
                <a class="{{comment_a}}" href="javascript:void(0);" onclick="commentlike(this,'{{id}}')"><i
                        class="icon icon-thumbs-up {{comment_i}}"></i>(<span>{{likes}}</span>)</a>
            </div>
        </div>
    </div>
</script>