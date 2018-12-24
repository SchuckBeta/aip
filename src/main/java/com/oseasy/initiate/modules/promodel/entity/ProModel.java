package com.oseasy.initiate.modules.promodel.entity;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.validator.constraints.Length;

import com.oseasy.initiate.modules.attachment.entity.SysAttachment;
import com.oseasy.pact.modules.actyw.entity.ActYw;
import com.oseasy.pcore.common.persistence.AttachMentEntity;
import com.oseasy.pcore.common.persistence.DataEntity;
import com.oseasy.pcore.modules.sys.entity.User;

/**
 * proModelEntity.
 *
 * @author zy
 * @version 2017-07-13
 */
public class ProModel extends DataEntity<ProModel>{
//public class ProModel extends WorkFetyPm<ProModel> implements IWorkRes, IWorkFety{

    private static final long serialVersionUID = 1L;
    public static final String JK_PROMODEL = "proModel";
    private String gnodeId;//页面传参
    private String actYwId;        //业务id
    private String pName;        // 项目名称
	private String shortName;        // 项目简称
    private String declareId;        // 申报人ID
    private User deuser;
    private String proType;        //项目 大赛
    private String type;                 // 大创 小创    互联网+ 创青春
    private String proCategory;        //项目类别：创新,创业//项目类别：project_type；大赛类别：competition_net_type
    private String level;                // 大赛级别
    private String introduction;        // 项目简介
    private String projectSource;        // 项目来源
    private String financingStat;        // 融资情况 0 未，1 100w一下 2 100w以上
	private String endGnodeId;        // 最终结果节点id
	private String endGnodeVesion;        // 最终结果节点批次
    private String finalStatus;        // 最终结果
    private String teamId;        // 团队ID
    private String procInsId;        // 流程实例id
    private String proMark;        // 项目标识
    private String source;        // source
    private String competitionNumber;        // 编号
    private String grade;        // 大赛和项目结果
    private String gScore;        // 评分
    private Date subTime;        // 提交时间
    private String subStatus;//提交状态 0-未提交，1-已提交
    private String stage;//项目阶段
    private String impdata;//是否导入的数据1-是，0-否
    private ActYw actYw;

	private String snames;  //项目组成员
	private String tnames;  //指导老师
	private String sourceName;     //来源名称

	private Date beginDate;        //开始时间
	private Date endDate;            //结束时间

	private Map<String,String> auditMap;  //审核参数

//    private String projectLevel;      //项目级别
    private String projectLevelDict;//项目级别对应字典表值

	private String state;      //状态是否结束 1是结束 0是未结束
	private String isAll;//是否所有数据1、是，0、否

    private AttachMentEntity attachMentEntity; //附件

    private List<SysAttachment> fileInfo;
    private String logoUrl;//页面传值项目logo url
    private SysAttachment logo;//logo图片文件
    private List<String> ids;
    private String queryStr;  //模糊查询字段
    private String year; //项目年份
	private String finalResult;  //项目结果
	private String taskAssigns;//指派人名称
	private String hasAssigns;//是否指派
	private String result;        // 大赛和项目结果

	private String toGnodeId;//变更流程到节点id

	//添加模板查询方式
	private List<String> proCategoryList;

	private List<String> projectLevelList;

	private List<String> officeIdList ;


    public ProModel(List<String> ids) {
        super();
        this.ids = ids;
    }

    public ProModel(List<String> ids, String actYwId) {
//        super(ids, actYwId);
        this.actYwId = actYwId;
        this.ids = ids;
    }

	public String getSourceName() {
		return sourceName;
	}

	public void setSourceName(String sourceName) {
		this.sourceName = sourceName;
	}

	public String getSnames() {
		return snames;
	}

	public void setSnames(String snames) {
		this.snames = snames;
	}

	public String getTnames() {
		return tnames;
	}

	public void setTnames(String tnames) {
		this.tnames = tnames;
	}

	public Map<String, String> getAuditMap() {
		return auditMap;
	}

	public void setAuditMap(Map<String, String> auditMap) {
		this.auditMap = auditMap;
	}

	public Date getBeginDate() {
		return beginDate;
	}

	public void setBeginDate(Date beginDate) {
		this.beginDate = beginDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public String getImpdata() {
		return impdata;
	}

	public void setImpdata(String impdata) {
		this.impdata = impdata;
	}

    public String getIsAll() {
        return isAll;
    }

    public void setIsAll(String isAll) {
        this.isAll = isAll;
    }

    public String getStage() {
		return stage;
	}

	public void setStage(String stage) {
		this.stage = stage;
	}

	public String getToGnodeId() {
		return toGnodeId;
	}

	public void setToGnodeId(String toGnodeId) {
		this.toGnodeId = toGnodeId;
	}

	public String getEndGnodeVesion() {
		return endGnodeVesion;
	}

	public void setEndGnodeVesion(String endGnodeVesion) {
		this.endGnodeVesion = endGnodeVesion;
	}

	public String getSubStatus() {
		return subStatus;
	}

	public void setSubStatus(String subStatus) {
		this.subStatus = subStatus;
	}

	public String getHasAssigns() {
		return hasAssigns;
	}

	public void setHasAssigns(String hasAssigns) {
		this.hasAssigns = hasAssigns;
	}

	public String getTaskAssigns() {
		return taskAssigns;
	}

	public void setTaskAssigns(String taskAssigns) {
		this.taskAssigns = taskAssigns;
	}

	public String getEndGnodeId() {
		return endGnodeId;
	}

	public String getShortName() {
		return shortName;
	}

	public void setShortName(String shortName) {
		this.shortName = shortName;
	}

	public void setEndGnodeId(String endGnodeId) {
		this.endGnodeId = endGnodeId;
	}

	public String getGnodeId() {
		return gnodeId;
	}

	public void setGnodeId(String gnodeId) {
		this.gnodeId = gnodeId;
	}

	public HashMap<String,Object> getVars() {
		HashMap<String,Object> vars=new HashMap<String, Object>();
		vars.put("number",competitionNumber);  //编号
//		vars.put("id",id);  //id
		vars.put("name",pName);              //项目名称
		vars.put("type",type);               //项目类型
		vars.put("proCategory",proCategory);               //项类别
		vars.put("level",level);             //项目级别
		vars.put("financingStat",financingStat);  //融资情况
		vars.put("projectSource",projectSource);  //项目来源
		vars.put("teamId",teamId);  //项目来源
		vars.put("finalStatus",finalStatus);             //项目评级
		vars.put("actYwId",actYwId);             //项目评级
		vars.put("declareId",declareId);     //大赛申报人id
		if ((deuser != null) && (deuser.getOffice() != null)) {
	    vars.put("dofficeName",deuser.getOffice().getName());     //
		}
		return vars;
	}

  public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public User getDeuser() {
    return deuser;
  }

  	public void setDeuser(User deuser) {
    this.deuser = deuser;
  }

	public String getFinalStatus() {
		return finalStatus;
	}

	public void setFinalStatus(String finalStatus) {
		this.finalStatus = finalStatus;
	}

	public String getProType() {
		return proType;
	}

	public void setProType(String proType) {
		this.proType = proType;
	}

	public Date getSubTime() {
		return subTime;
	}

	public void setSubTime(Date subTime) {
		this.subTime = subTime;
	}

	public String getProCategory() {
		return proCategory;
	}

	public void setProCategory(String proCategory) {
		this.proCategory = proCategory;
	}

	public AttachMentEntity getAttachMentEntity() {
		return attachMentEntity;
	}

	public void setAttachMentEntity(AttachMentEntity attachMentEntity) {
		this.attachMentEntity = attachMentEntity;
	}

	public ProModel() {
		super();
	}

	public ProModel(String id) {
//		super(id);
	}

	public String getProjectSource() {
		return projectSource;
	}

	public void setProjectSource(String projectSource) {
		this.projectSource = projectSource;
	}

	@Length(min=0, max=128, message="项目名称长度必须介于 0 和 128 之间")
	public String getPName() {
		return pName;
	}

	public void setPName(String pName) {
		this.pName = pName;
	}

	@Length(min=0, max=64, message="申报人ID长度必须介于 0 和 64 之间")
	public String getDeclareId() {
		return declareId;
	}

	public void setDeclareId(String declareId) {
		this.declareId = declareId;
	}

	@Length(min=0, max=20, message="项目类型长度必须介于 0 和 20 之间")
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getgScore() {
		return gScore;
	}

	public void setgScore(String gScore) {
		this.gScore = gScore;
	}

	public String getActYwId() {
		return actYwId;
	}

	public void setActYwId(String actYwId) {
		this.actYwId = actYwId;
	}

	public String getpName() {
		return pName;
	}

	public void setpName(String pName) {
		this.pName = pName;
	}

	@Length(min=0, max=20, message="项目级别长度必须介于 0 和 20 之间")
	public String getLevel() {
		return level;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	public String getIntroduction() {
		return introduction;
	}

	public void setIntroduction(String introduction) {
		this.introduction = introduction;
	}

	@Length(min=0, max=20, message="融资情况 0 未，1 100w一下 2 100w以上长度必须介于 0 和 20 之间")
	public String getFinancingStat() {
		return financingStat;
	}

	public void setFinancingStat(String financingStat) {
		this.financingStat = financingStat;
	}

	@Length(min=0, max=64, message="团队ID长度必须介于 0 和 64 之间")
	public String getTeamId() {
		return teamId;
	}

	public void setTeamId(String teamId) {
		this.teamId = teamId;
	}

	@Length(min=0, max=64, message="流程实例id长度必须介于 0 和 64 之间")
	public String getProcInsId() {
		return procInsId;
	}

	public void setProcInsId(String procInsId) {
		this.procInsId = procInsId;
	}

	@Length(min=0, max=64, message="项目标识长度必须介于 0 和 64 之间")
	public String getProMark() {
		return proMark;
	}

	public void setProMark(String proMark) {
		this.proMark = proMark;
	}

	@Length(min=0, max=64, message="source长度必须介于 0 和 64 之间")
	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	@Length(min=1, max=64, message="大赛编号长度必须介于 1 和 64 之间")
	public String getCompetitionNumber() {
		return competitionNumber;
	}

	public void setCompetitionNumber(String competitionNumber) {
		this.competitionNumber = competitionNumber;
	}

	@Length(min=0, max=20, message="大赛结果长度必须介于 0 和 20 之间")
	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public String getGScore() {
		return gScore;
	}

	public void setGScore(String gScore) {
		this.gScore = gScore;
	}

  public ActYw getActYw() {
    return actYw;
  }

  public void setActYw(ActYw actYw) {
    this.actYw = actYw;
  }

	public List<SysAttachment> getFileInfo() {
		return fileInfo;
	}

    public void setFileInfo(List<SysAttachment> fileInfo) {
        this.fileInfo = fileInfo;
    }

    public String getLogoUrl() {
        return logoUrl;
    }

    public void setLogoUrl(String logoUrl) {
        this.logoUrl = logoUrl;
    }

    public SysAttachment getLogo() {
        return logo;
    }

    public void setLogo(SysAttachment logo) {
        this.logo = logo;
    }

    public List<String> getIds() {
        return ids;
    }

    public void setIds(List<String> ids) {
        this.ids = ids;
    }

    public String getQueryStr() {
        return queryStr;
    }

    public void setQueryStr(String queryStr) {
        this.queryStr = queryStr;
    }

	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public String getFinalResult() {
		return finalResult;
	}

	public void setFinalResult(String finalResult) {
		this.finalResult = finalResult;
	}

//	public String getProjectLevel() {
//		return projectLevel;
//	}
//
//	public void setProjectLevel(String projectLevel) {
//		this.projectLevel = projectLevel;
//	}


	public List<String> getProCategoryList() {
		return proCategoryList;
	}

	public void setProCategoryList(List<String> proCategoryList) {
		this.proCategoryList = proCategoryList;
	}

	public List<String> getProjectLevelList() {
		return projectLevelList;
	}

	public void setProjectLevelList(List<String> projectLevelList) {
		this.projectLevelList = projectLevelList;
	}

	public List<String> getOfficeIdList() {
		return officeIdList;
	}

	public void setOfficeIdList(List<String> officeIdList) {
		this.officeIdList = officeIdList;
	}

	public String getProjectLevelDict() {
		return projectLevelDict;
	}

	public void setProjectLevelDict(String projectLevelDict) {
		this.projectLevelDict = projectLevelDict;
	}

	/* (non-Javadoc)
		 * @see com.oseasy.initiate.modules.workflow.IWorkRes#getOfficeName()
		 */
//    @Override
    public String getOfficeName() {
        if((this.getDeuser() == null) || (this.getDeuser().getOffice() == null)){
            return "";
        }
        return this.getDeuser().getOffice().getName();
    }
}