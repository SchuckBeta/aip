package com.oseasy.pact.modules.actyw.entity;

import org.hibernate.validator.constraints.Length;

import com.oseasy.pcore.common.persistence.DataEntity;

/**
 * 业务配置项Entity.
 * @author chenh
 * @version 2017-11-09
 */
public class ActYwConfig extends DataEntity<ActYwConfig> {

	private static final long serialVersionUID = 1L;
	private String ywId;		// 项目流程id
	private String hasFlowDeploy;		// 是否有流程部署：0,默认是;1,否
	private String flowDeployWay;		// 流程部署方式：0,默认全覆盖;1,部分更新(不用重新部署);
	private String flowGd;		// 是否固定流程：0,默认否;1,是固定流程
	private String flowXml;		// 固定流程XML文件地址;
	private String hasScore;		// 是否有学分流程：0,默认否;1,是;
	private String scoreFid;		// 学分流程ID
	private String hasMenu;		// 是否有菜单：0,默认否;
	private String menuReset;		// 重新发布时是否重置菜单：0,默认否;
	private String menuTheme;		// 菜单主题：0,默认;
	private String hasGlobalAudit;		// 是否有开启全局审核：1,默认是;0,否;
	private String auditType;		// 审核类型（全局审核为否是启用）：0,学院自审;1,指定学院审核;
	private String auditOfficeId;		// 指定审核的学院或部门
	private String hasCategpry;		// 是否有栏目：0,默认否;
	private String categpryReset;		// 重新发布时是否重置栏目：0,默认否;
	private String categpryTheme;		// 栏目主题：0,默认;
	private String hasNotice;		// 是否有站内信通知：1,默认,是;0,否;
	private String hasMsg;		// 是否有站内信消息通知：1,默认,是;0,否;
	private String hasEmail;		// 是否有站内信邮件通知：1,默认,是;0,否;
	private String hasCert;		// 是否有证书：0,默认否;
	private String certWay;		// 证书下发方式：0,默认;
	private String certShowType;		// 证书显示位置：默认所有;
	private String certNotice;		// 证书开启站内信通知：1,默认,是;0,否;
	private String certMsg;		// 证书开启消息通知：1,默认,是;0,否;
	private String certEmail;		// 证书开启邮件通知：1,默认,是;0,否;
	private String hasAssign;		// 是否支持指派：0,默认否;
	private String assignWay;		// 指派方式：0,默认;
	private String assignShowType;		// 指派显示位置：默认所有;
	private String hasTime;		// 是否显示时间(0否、1是)
	private String hasApypage;		// 是否有申报节点：0,默认否（流程没有申报，申报页固定写死）;1,是（申报节点必须为顶一个节点-校验）
	private String apypageAsStart;		// 是否申报作为开始节点：0,默认否（项目开始时间以申报节点后一个节点开始时间作为开始）;
	private String apypageId;		// 申报节点ID
	private String apypageUrl;		// 申报页URL(自定义申报也可不填)
	private String hasApplylt;		// 是否有申报限制：0,默认否（没有任何申报条件限制，如果有全局配置，则使用全局配置）;1,是
	private String applyltWay;		// 申报处理方式：0,默认,1人1次; 1,指定次数; 2,指定次数;
	private String applyltNum;		// 申报次数：默认1
	private String hasPrate;		// 是否开启通过率：0,默认否;
	private String prateWay;		// 通过率处理方式：0,默认;
	private String prateShowType;		// 通过率显示位置：默认所有;
	private String hasNrule;		// 是否定制编号规则：0,默认否,系统生成;
	private String nruleId;		// 编号规则ID
	private String hasRename;		// 是否支持取别名：0,默认否,根据类型生成;1,是;
	private String renameWay;		// 别名方式:0,自定义;1,动态维护;
	private String hasAxis;		// 是否有时间轴：0,否;1,默认是;
	private String hasKey;		// 是否有通用标识：0,默认否;1,是;
	private String keyType;		// 通用标识
	private String hasTeamlt;		// 是否有限制团队人数：0,默认否,使用全局配置;1,是;
	private String teamltMin;		// 团队最少人数
	private String teamltMax;		// 团队最多人数
	private String allowEnjoy;		// 是否允许入驻孵化器：0,默认否;1,是;
	private String hasIncubator;		// 是否有孵化器流程：0,默认否;1,是;
	private String incubatorFid;		// 孵化器流程ID

	public ActYwConfig() {
		super();
	}

	public ActYwConfig(String id) {
		super(id);
	}

	@Length(min=0, max=64, message="项目流程id长度必须介于 0 和 64 之间")
	public String getYwId() {
		return ywId;
	}

	public void setYwId(String ywId) {
		this.ywId = ywId;
	}

	@Length(min=0, max=1, message="是否有流程部署：0,默认是;1,否长度必须介于 0 和 1 之间")
	public String getHasFlowDeploy() {
		return hasFlowDeploy;
	}

	public void setHasFlowDeploy(String hasFlowDeploy) {
		this.hasFlowDeploy = hasFlowDeploy;
	}

	@Length(min=0, max=1, message="流程部署方式：0,默认全覆盖;1,部分更新(不用重新部署);长度必须介于 0 和 1 之间")
	public String getFlowDeployWay() {
		return flowDeployWay;
	}

	public void setFlowDeployWay(String flowDeployWay) {
		this.flowDeployWay = flowDeployWay;
	}

	@Length(min=0, max=1, message="是否固定流程：0,默认否;1,是固定流程长度必须介于 0 和 1 之间")
	public String getFlowGd() {
		return flowGd;
	}

	public void setFlowGd(String flowGd) {
		this.flowGd = flowGd;
	}

	@Length(min=0, max=1, message="固定流程XML文件地址;长度必须介于 0 和 1 之间")
	public String getFlowXml() {
		return flowXml;
	}

	public void setFlowXml(String flowXml) {
		this.flowXml = flowXml;
	}

	@Length(min=0, max=1, message="是否有学分流程：0,默认否;1,是;长度必须介于 0 和 1 之间")
	public String getHasScore() {
		return hasScore;
	}

	public void setHasScore(String hasScore) {
		this.hasScore = hasScore;
	}

	@Length(min=1, max=64, message="学分流程ID长度必须介于 1 和 64 之间")
	public String getScoreFid() {
		return scoreFid;
	}

	public void setScoreFid(String scoreFid) {
		this.scoreFid = scoreFid;
	}

	@Length(min=0, max=1, message="是否有菜单：0,默认否;长度必须介于 0 和 1 之间")
	public String getHasMenu() {
		return hasMenu;
	}

	public void setHasMenu(String hasMenu) {
		this.hasMenu = hasMenu;
	}

	@Length(min=0, max=1, message="重新发布时是否重置菜单：0,默认否;长度必须介于 0 和 1 之间")
	public String getMenuReset() {
		return menuReset;
	}

	public void setMenuReset(String menuReset) {
		this.menuReset = menuReset;
	}

	@Length(min=1, max=11, message="菜单主题：0,默认;长度必须介于 1 和 11 之间")
	public String getMenuTheme() {
		return menuTheme;
	}

	public void setMenuTheme(String menuTheme) {
		this.menuTheme = menuTheme;
	}

	@Length(min=0, max=1, message="是否有开启全局审核：1,默认是;0,否;长度必须介于 0 和 1 之间")
	public String getHasGlobalAudit() {
		return hasGlobalAudit;
	}

	public void setHasGlobalAudit(String hasGlobalAudit) {
		this.hasGlobalAudit = hasGlobalAudit;
	}

	@Length(min=1, max=11, message="审核类型（全局审核为否是启用）：0,学院自审;1,指定学院审核;长度必须介于 1 和 11 之间")
	public String getAuditType() {
		return auditType;
	}

	public void setAuditType(String auditType) {
		this.auditType = auditType;
	}

	@Length(min=0, max=64, message="指定审核的学院或部门长度必须介于 0 和 64 之间")
	public String getAuditOfficeId() {
		return auditOfficeId;
	}

	public void setAuditOfficeId(String auditOfficeId) {
		this.auditOfficeId = auditOfficeId;
	}

	@Length(min=0, max=1, message="是否有栏目：0,默认否;长度必须介于 0 和 1 之间")
	public String getHasCategpry() {
		return hasCategpry;
	}

	public void setHasCategpry(String hasCategpry) {
		this.hasCategpry = hasCategpry;
	}

	@Length(min=0, max=1, message="重新发布时是否重置栏目：0,默认否;长度必须介于 0 和 1 之间")
	public String getCategpryReset() {
		return categpryReset;
	}

	public void setCategpryReset(String categpryReset) {
		this.categpryReset = categpryReset;
	}

	@Length(min=1, max=11, message="栏目主题：0,默认;长度必须介于 1 和 11 之间")
	public String getCategpryTheme() {
		return categpryTheme;
	}

	public void setCategpryTheme(String categpryTheme) {
		this.categpryTheme = categpryTheme;
	}

	@Length(min=0, max=1, message="是否有站内信通知：1,默认,是;0,否;长度必须介于 0 和 1 之间")
	public String getHasNotice() {
		return hasNotice;
	}

	public void setHasNotice(String hasNotice) {
		this.hasNotice = hasNotice;
	}

	@Length(min=1, max=11, message="是否有站内信消息通知：1,默认,是;0,否;长度必须介于 1 和 11 之间")
	public String getHasMsg() {
		return hasMsg;
	}

	public void setHasMsg(String hasMsg) {
		this.hasMsg = hasMsg;
	}

	@Length(min=1, max=11, message="是否有站内信邮件通知：1,默认,是;0,否;长度必须介于 1 和 11 之间")
	public String getHasEmail() {
		return hasEmail;
	}

	public void setHasEmail(String hasEmail) {
		this.hasEmail = hasEmail;
	}

	@Length(min=0, max=1, message="是否有证书：0,默认否;长度必须介于 0 和 1 之间")
	public String getHasCert() {
		return hasCert;
	}

	public void setHasCert(String hasCert) {
		this.hasCert = hasCert;
	}

	@Length(min=1, max=11, message="证书下发方式：0,默认;长度必须介于 1 和 11 之间")
	public String getCertWay() {
		return certWay;
	}

	public void setCertWay(String certWay) {
		this.certWay = certWay;
	}

	@Length(min=0, max=255, message="证书显示位置：默认所有;长度必须介于 0 和 255 之间")
	public String getCertShowType() {
		return certShowType;
	}

	public void setCertShowType(String certShowType) {
		this.certShowType = certShowType;
	}

	@Length(min=1, max=11, message="证书开启站内信通知：1,默认,是;0,否;长度必须介于 1 和 11 之间")
	public String getCertNotice() {
		return certNotice;
	}

	public void setCertNotice(String certNotice) {
		this.certNotice = certNotice;
	}

	@Length(min=1, max=11, message="证书开启消息通知：1,默认,是;0,否;长度必须介于 1 和 11 之间")
	public String getCertMsg() {
		return certMsg;
	}

	public void setCertMsg(String certMsg) {
		this.certMsg = certMsg;
	}

	@Length(min=1, max=11, message="证书开启邮件通知：1,默认,是;0,否;长度必须介于 1 和 11 之间")
	public String getCertEmail() {
		return certEmail;
	}

	public void setCertEmail(String certEmail) {
		this.certEmail = certEmail;
	}

	@Length(min=0, max=1, message="是否支持指派：0,默认否;长度必须介于 0 和 1 之间")
	public String getHasAssign() {
		return hasAssign;
	}

	public void setHasAssign(String hasAssign) {
		this.hasAssign = hasAssign;
	}

	@Length(min=1, max=11, message="指派方式：0,默认;长度必须介于 1 和 11 之间")
	public String getAssignWay() {
		return assignWay;
	}

	public void setAssignWay(String assignWay) {
		this.assignWay = assignWay;
	}

	@Length(min=0, max=255, message="指派显示位置：默认所有;长度必须介于 0 和 255 之间")
	public String getAssignShowType() {
		return assignShowType;
	}

	public void setAssignShowType(String assignShowType) {
		this.assignShowType = assignShowType;
	}

	@Length(min=0, max=1, message="是否显示时间(0否、1是)长度必须介于 0 和 1 之间")
	public String getHasTime() {
		return hasTime;
	}

	public void setHasTime(String hasTime) {
		this.hasTime = hasTime;
	}

	@Length(min=0, max=1, message="是否有申报节点：0,默认否（流程没有申报，申报页固定写死）;1,是（申报节点必须为顶一个节点-校验）长度必须介于 0 和 1 之间")
	public String getHasApypage() {
		return hasApypage;
	}

	public void setHasApypage(String hasApypage) {
		this.hasApypage = hasApypage;
	}

	@Length(min=0, max=1, message="是否申报作为开始节点：0,默认否（项目开始时间以申报节点后一个节点开始时间作为开始）;长度必须介于 0 和 1 之间")
	public String getApypageAsStart() {
		return apypageAsStart;
	}

	public void setApypageAsStart(String apypageAsStart) {
		this.apypageAsStart = apypageAsStart;
	}

	@Length(min=1, max=64, message="申报节点ID长度必须介于 1 和 64 之间")
	public String getApypageId() {
		return apypageId;
	}

	public void setApypageId(String apypageId) {
		this.apypageId = apypageId;
	}

	@Length(min=1, max=64, message="申报页URL(自定义申报也可不填)长度必须介于 1 和 64 之间")
	public String getApypageUrl() {
		return apypageUrl;
	}

	public void setApypageUrl(String apypageUrl) {
		this.apypageUrl = apypageUrl;
	}

	@Length(min=0, max=1, message="是否有申报限制：0,默认否（没有任何申报条件限制，如果有全局配置，则使用全局配置）;1,是长度必须介于 0 和 1 之间")
	public String getHasApplylt() {
		return hasApplylt;
	}

	public void setHasApplylt(String hasApplylt) {
		this.hasApplylt = hasApplylt;
	}

	@Length(min=1, max=11, message="申报处理方式：0,默认,1人1次; 1,指定次数; 2,指定次数;长度必须介于 1 和 11 之间")
	public String getApplyltWay() {
		return applyltWay;
	}

	public void setApplyltWay(String applyltWay) {
		this.applyltWay = applyltWay;
	}

	@Length(min=1, max=11, message="申报次数：默认1长度必须介于 1 和 11 之间")
	public String getApplyltNum() {
		return applyltNum;
	}

	public void setApplyltNum(String applyltNum) {
		this.applyltNum = applyltNum;
	}

	@Length(min=0, max=1, message="是否开启通过率：0,默认否;长度必须介于 0 和 1 之间")
	public String getHasPrate() {
		return hasPrate;
	}

	public void setHasPrate(String hasPrate) {
		this.hasPrate = hasPrate;
	}

	@Length(min=1, max=11, message="通过率处理方式：0,默认;长度必须介于 1 和 11 之间")
	public String getPrateWay() {
		return prateWay;
	}

	public void setPrateWay(String prateWay) {
		this.prateWay = prateWay;
	}

	@Length(min=0, max=255, message="通过率显示位置：默认所有;长度必须介于 0 和 255 之间")
	public String getPrateShowType() {
		return prateShowType;
	}

	public void setPrateShowType(String prateShowType) {
		this.prateShowType = prateShowType;
	}

	@Length(min=0, max=1, message="是否定制编号规则：0,默认否,系统生成;长度必须介于 0 和 1 之间")
	public String getHasNrule() {
		return hasNrule;
	}

	public void setHasNrule(String hasNrule) {
		this.hasNrule = hasNrule;
	}

	@Length(min=1, max=64, message="编号规则ID长度必须介于 1 和 64 之间")
	public String getNruleId() {
		return nruleId;
	}

	public void setNruleId(String nruleId) {
		this.nruleId = nruleId;
	}

	@Length(min=0, max=1, message="是否支持取别名：0,默认否,根据类型生成;1,是;长度必须介于 0 和 1 之间")
	public String getHasRename() {
		return hasRename;
	}

	public void setHasRename(String hasRename) {
		this.hasRename = hasRename;
	}

	@Length(min=1, max=64, message="别名方式:0,自定义;1,动态维护;长度必须介于 1 和 64 之间")
	public String getRenameWay() {
		return renameWay;
	}

	public void setRenameWay(String renameWay) {
		this.renameWay = renameWay;
	}

	@Length(min=0, max=1, message="是否有时间轴：0,否;1,默认是;长度必须介于 0 和 1 之间")
	public String getHasAxis() {
		return hasAxis;
	}

	public void setHasAxis(String hasAxis) {
		this.hasAxis = hasAxis;
	}

	@Length(min=0, max=1, message="是否有通用标识：0,默认否;1,是;长度必须介于 0 和 1 之间")
	public String getHasKey() {
		return hasKey;
	}

	public void setHasKey(String hasKey) {
		this.hasKey = hasKey;
	}

	@Length(min=0, max=255, message="通用标识长度必须介于 0 和 255 之间")
	public String getKeyType() {
		return keyType;
	}

	public void setKeyType(String keyType) {
		this.keyType = keyType;
	}

	@Length(min=0, max=1, message="是否有限制团队人数：0,默认否,使用全局配置;1,是;长度必须介于 0 和 1 之间")
	public String getHasTeamlt() {
		return hasTeamlt;
	}

	public void setHasTeamlt(String hasTeamlt) {
		this.hasTeamlt = hasTeamlt;
	}

	@Length(min=0, max=255, message="团队最少人数长度必须介于 0 和 255 之间")
	public String getTeamltMin() {
		return teamltMin;
	}

	public void setTeamltMin(String teamltMin) {
		this.teamltMin = teamltMin;
	}

	@Length(min=0, max=255, message="团队最多人数长度必须介于 0 和 255 之间")
	public String getTeamltMax() {
		return teamltMax;
	}

	public void setTeamltMax(String teamltMax) {
		this.teamltMax = teamltMax;
	}

	@Length(min=0, max=1, message="是否允许入驻孵化器：0,默认否;1,是;长度必须介于 0 和 1 之间")
	public String getAllowEnjoy() {
		return allowEnjoy;
	}

	public void setAllowEnjoy(String allowEnjoy) {
		this.allowEnjoy = allowEnjoy;
	}

	@Length(min=0, max=1, message="是否有孵化器流程：0,默认否;1,是;长度必须介于 0 和 1 之间")
	public String getHasIncubator() {
		return hasIncubator;
	}

	public void setHasIncubator(String hasIncubator) {
		this.hasIncubator = hasIncubator;
	}

	@Length(min=1, max=64, message="孵化器流程ID长度必须介于 1 和 64 之间")
	public String getIncubatorFid() {
		return incubatorFid;
	}

	public void setIncubatorFid(String incubatorFid) {
		this.incubatorFid = incubatorFid;
	}

}