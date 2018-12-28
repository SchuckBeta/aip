package com.oseasy.pcms.modules.cmss.entity;

import java.util.List;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;
import org.hibernate.validator.constraints.Length;

import com.google.common.collect.Lists;
import com.oseasy.initiate.common.config.SysIds;
import com.oseasy.pcms.common.utils.CmsUtil;
import com.oseasy.pcore.common.config.CoreIds;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.TreeEntity;

/**
 * 栏目管理Entity.
 * @author liangjie
 * @version 2018-08-30
 */
public class CmssCategory extends TreeEntity<CmssCategory> {
    public static final String DEFAULT_TEMPLATE = "frontList";
	private static final long serialVersionUID = 1L;
	private String parentId;		// 上级栏目
	private String parentIds;		// 所有父级编号
	private String name;		// 栏目名称
	private String module;		//栏目模块
	private CmsSite site;		// 站点编号
    private String href;    // 访问路径
	private Integer isNewtab;		// 是否打开新窗口（0否1是）
	private Integer isShow;		// 显示（0否1是）
	private Integer sort;		// 排列顺序
	private String showModes;		// 展现方式（默认展现方式，首栏目内容列表，栏目第一条内容）
	private String contenttype;		// 内容类型(0图文1普通)
	private String allowComment;		// 是否允许评论（0否1是）
	private String isAudit;		// 是否需要审核（0否1是）
	private Integer isContentstatic;		// 内容静态化
	private String likes;		// 点赞量
	private String description;		// 描述
    private List<CmssCategory> childList = Lists.newArrayList();    // 拥有子分类列表
//    private List<CmsIndexRegion> childRegionList = Lists.newArrayList();    // 拥有资源列表
    private String publishCategory; //定义栏目类型，以便定位栏目
    private Integer isSys;//系统栏目标识


    public CmssCategory() {
        super();
        this.module = "";
        this.sort = 30;
        this.showModes = "0";
        this.allowComment = Global.NO;
        this.delFlag = DEL_FLAG_NORMAL;
        this.isAudit = Global.NO;
    }

    public CmssCategory(String id){
        super(id);
    }

    public CmssCategory(String id, CmsSite site) {
        this();
        this.id = id;
        this.setCmsSite(site);
    }

    public Integer getIsSys() {
        return isSys;
    }

    public void setIsSys(Integer isSys) {
        this.isSys = isSys;
    }

    public String getPublishCategory() {
        return publishCategory;
    }

    public void setPublishCategory(String publishCategory) {
        this.publishCategory = publishCategory;
    }

    public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	@Length(min=1, max=2000, message="所有父级编号长度必须介于 1 和 2000 之间")
	public String getParentIds() {
		return parentIds;
	}

	public void setParentIds(String parentIds) {
		this.parentIds = parentIds;
	}

	@Length(min=0, max=20, message="栏目名称长度必须介于 0 和 20 之间")
	public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getIsNewtab() {
		return isNewtab;
	}

	public void setIsNewtab(Integer isNewtab) {
		this.isNewtab = isNewtab;
	}

	public Integer getIsShow() {
		return isShow;
	}

	public void setIsShow(Integer isShow) {
		this.isShow = isShow;
	}

	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}

	public String getContenttype() {
		return contenttype;
	}

	public void setContenttype(String contenttype) {
		this.contenttype = contenttype;
	}

	@Length(min=0, max=11, message="内容静态化长度必须介于 0 和 11 之间")
	public Integer getIsContentstatic() {
		return isContentstatic;
	}

	public void setIsContentstatic(Integer isContentstatic) {
		this.isContentstatic = isContentstatic;
	}

	@Length(min=1, max=11, message="点赞量长度必须介于 1 和 11 之间")
	public String getLikes() {
		return likes;
	}

	public void setLikes(String likes) {
		this.likes = likes;
	}

//
//    private static final long serialVersionUID = 1L;
//    private Site site;      // 归属站点
//    private Office office;  // 归属部门
////  private Category parent;// 父级菜单
////  private String parentIds;// 所有父级编号
//    private String module;  // 栏目模型（article：文章；picture：图片；download：下载；link：链接；special：专题）
////  private String name;    // 栏目名称
//    private String image;   // 栏目图片
//    private String target;  // 目标（ _blank、_self、_parent、_top）
//    private String description;     // 描述，填写有助于搜索引擎优化
//    private String keywords;    // 关键字，填写有助于搜索引擎优化
////  private Integer sort;       // 排序（升序）
//    private String inMenu;      // 是否在导航中显示（1：显示；0：不显示）
//    private String inList;      // 是否在分类页中显示列表（1：显示；0：不显示）
//    private String showModes;   // 展现方式（0:有子栏目显示栏目列表，无子栏目显示内容列表;1：首栏目内容列表；2：栏目第一条内容）
//    private String allowComment;// 是否允许评论
//    private String isAudit; // 是否需要审核
//    private String customListView;      // 自定义列表视图
//    private String customContentView;   // 自定义内容视图
//    private String viewConfig;  // 视图参数
//
//    private Date beginDate; // 开始时间
//    private Date endDate;   // 结束时间
//    private String cnt;//信息量
//    private String hits;//点击量

    public CmsSite getCmsSite() {
        return site;
    }

    public String getHref() {
        return href;
    }

    public void setHref(String href) {
        this.href = href;
    }

    public void setCmsSite(CmsSite site) {
        this.site = site;
    }

//  @JsonBackReference
//  @NotNull
    public CmssCategory getParent() {
        return parent;
    }

    public void setParent(CmssCategory parent) {
        this.parent = parent;
    }

//  @Length(min=1, max=255)
//  public String getParentIds() {
//      return parentIds;
//  }
//
//  public void setParentIds(String parentIds) {
//      this.parentIds = parentIds;
//  }

    @Length(min=0, max=20)
    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }

//  @Length(min=0, max=100)
//  public String getName() {
//      return name;
//  }
//
//  public void setName(String name) {
//      this.name = name;
//  }


    @Length(min=0, max=255)
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

//  @NotNull
//  public Integer getSort() {
//      return sort;
//  }
//
//  public void setSort(Integer sort) {
//      this.sort = sort;
//  }

    @Length(min=1, max=1)
    public String getShowModes() {
        return showModes;
    }

    public void setShowModes(String showModes) {
        this.showModes = showModes;
    }

    @Length(min=1, max=1)
    public String getAllowComment() {
        return allowComment;
    }

    public void setAllowComment(String allowComment) {
        this.allowComment = allowComment;
    }

    @Length(min=1, max=1)
    public String getIsAudit() {
        return isAudit;
    }

    public void setIsAudit(String isAudit) {
        this.isAudit = isAudit;
    }

    public List<CmssCategory> getChildList() {
        return childList;
    }

    public void setChildList(List<CmssCategory> childList) {
        this.childList = childList;
    }

//    public List<CmsIndexRegion> getChildRegionList() {
//        return childRegionList;
//    }
//
//    public void setChildRegionList(List<CmsIndexRegion> childRegionList) {
//        this.childRegionList = childRegionList;
//    }

    public static void sortList(List<CmssCategory> list, List<CmssCategory> sourcelist, String parentId) {
        for (int i=0; i<sourcelist.size(); i++) {
            CmssCategory e = sourcelist.get(i);
            if (e.getParentId()!=null && e.getParentId().equals(parentId)) {
                list.add(e);
                // 判断是否还有子节点, 有则继续获取子节点
                for (int j=0; j<sourcelist.size(); j++) {
                    CmssCategory child = sourcelist.get(j);
                    if ( child.getParentId()!=null
                            && child.getParentId().equals(e.getId())) {
                        sortList(list, sourcelist, e.getId());
                        break;
                    }
                }
            }
        }
    }

//  public String getIds() {
//      return (this.getParentIds() !=null ? this.getParentIds().replaceAll(",", " ") : "")
//              + (this.getId() != null ? this.getId() : "");
//  }

    public boolean isRoot() {
        return isRoot(this.id);
    }

    /**
     * 是否栏目根节点
     * @param id
     * @return
     */
    public static boolean isRoot(String id) {
        return id != null && id.equals(SysIds.SITE_CATEGORYS_SYS_ROOT.getId());
    }

    /**
     * 是否网站首页
     * @param id
     * @return
     */
    public static boolean isHome(String id) {
        return id != null && id.equals(CoreIds.SYS_TREE_ROOT.getId());
    }

    public String getUrl() {
        return CmsUtil.getUrlDynamic(this);
    }

    public static CmssCategory initByParentId(String parentId) {
        CmssCategory c = new CmssCategory();
        CmssCategory pc = new CmssCategory();
        pc.setId(parentId);
        c.setParent(pc);
        return c;
    }

	@Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}

}