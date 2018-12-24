<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${frontTitle}</title>
    <meta charset="UTF-8">
    <meta name="decorator" content="creative"/>
    <script src="/js/cityData/citydataNew.js"></script>


    <script src="/js/components/cityDropDown/cityDropDown.js"></script>
    <script src="/js/components/cityDropDown/cityPicker.js"></script>

    <style>
        .el-button+.el-button{
            margin-left: 0;
        }
    </style>

</head>
<body>

<div id="app" v-show="pageLoad" style="display: none;" class="container page-container mgb-60">
    <el-breadcrumb class="mgb-20" separator-class="el-icon-arrow-right">
        <el-breadcrumb-item><a href="${ctxFront}"><i class="iconfont icon-ai-home"></i>首页</a></el-breadcrumb-item>
        <el-breadcrumb-item>双创简历</el-breadcrumb-item>
    </el-breadcrumb>
    <div class="user_avatar-sidebar">
        <div class="user-avatar">
            <div class="avatar-pic">
                <img :src="userPhoto | ftpHttpFilter(ftpHttp) | studentPicFilter">
            </div>
            <el-button type="primary" size="mini" @click.stop.prevent="handleChangeUserPicOpen">更换图像
            </el-button>
        </div>
        <ul class="user-info_menu">
            <li class="active"><a href="javascript: void(0);"><i class="iconfont icon-user"></i>双创简历</a></li>
            <li><a href="${ctxFront}/sys/frontStudentExpansion/frontUserPassword"><i class="iconfont icon-14"></i>修改密码</a></li>
            <li><a href="${ctxFront}/sys/frontStudentExpansion/frontUserMobile"><i class="iconfont icon-unie64f"></i>手机信息</a></li>
        </ul>
    </div>
    <div class="user_detail-container">
        <%--<div class="print-page">--%>
            <%--<a href="javascript: void(0);"><i class="iconfont icon-dayin"></i>打印</a>--%>
        <%--</div>--%>
        <div class="user_detail-title">
            <i class="iconfont icon-user"></i><span class="text">双创简历</span>
        </div>
        <div class="user_detail-wrap">
            <div class="user_detail-inner">
                <div class="user_detail-title-handler">
                    <div class="ud-row-handler">
                        <el-button type="text" title="编辑" size="mini" v-show="!isEditBaseInfo" :disabled="isUpdating || isEditBaseInfo"
                                   @click.prevent="showEditForm('userBaseForm')"><i
                                class="iconfont icon-bianji"></i></el-button>
                        <el-button type="text" title="取消" size="mini" v-show="isEditBaseInfo" :disabled="isUpdating || !isEditBaseInfo"
                                   @click.prevent="isEditBaseInfo = false"><i
                                class="iconfont icon-mianfeiquxiao"></i></el-button>
                        <el-button type="text" title="保存" size="mini" :disabled="isUpdating || !isEditBaseInfo"
                                   @click.prevent="updateForm('userBaseForm')"><i
                                class="iconfont icon-iconset0237"></i></el-button>
                    </div>
                    <div class="ud-row-title"><span class="name">基本信息</span></div>
                </div>
                <el-row v-show="!isEditBaseInfo" :gutter="10" label-width="90px">
                    <el-col :span="8">
                        <e-col-item label="姓名：" align="right">{{userBaseInfo.userName}}</e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item label="性别：" align="right">{{userBaseInfo.userSex === '1' ? '男': '女'}}</e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item label="出生时间：" align="right">{{userBaseInfo.userBirthday}}
                        </e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item label="登录名：" align="right">{{userBaseInfo.userLoginName}}</e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item label="电子邮箱：" align="right">{{userBaseInfo.userEmail}}</e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item label="手机号：" align="right">{{userBaseInfo.userMobile}}
                            <span :class="{'empty-color empty': !userBaseInfo.userMobile}" v-show="!userBaseInfo.userMobile">请添加手机号</span>
                            <el-button type="text" size="mini" @click.stop.prevent="handleChangeMobile">{{userBaseInfo.userMobile ? '修改' : '添加'}}</el-button>
                        </e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item label="国家/地区：" align="right">{{userBaseInfo.userCountry |
                            userCountryName(cityIdKeyData)}}
                        </e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item label="民族：" align="right">{{userBaseInfo.userNational}}</e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item label="政治面貌：" align="right">{{userBaseInfo.userPolitical}}</e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item label="证件号：" align="right">
                            {{userBaseInfo.userIdType | selectedFilter(idTypesEntries)}}
                            {{userBaseInfo.userIdNumber}}
                        </e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item label="QQ：" align="right">{{userBaseInfo.userQq}}</e-col-item>
                    </el-col>
                    <el-col :span="24">
                        <e-col-item label="联系地址：" align="right">{{userBaseInfo.address}}</e-col-item>
                    </el-col>
                </el-row>
                <el-form v-show="isEditBaseInfo" :model="userBaseForm" ref="userBaseForm" label-width="80px" size="mini"
                         :rules="userBaseFormRule"
                         class="form-label-font12 user-form">
                    <el-row :gutter="10">
                        <el-col :span="8">
                            <el-form-item label="姓名" prop="userName">
                                <el-input name="name" v-model="userBaseForm.userName"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8">
                            <el-form-item label="性别" prop="userSex">
                                <el-radio-group v-model="userBaseForm.userSex">
                                    <el-radio-button label="1">男</el-radio-button>
                                    <el-radio-button label="0">女</el-radio-button>
                                </el-radio-group>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8">
                            <el-form-item label="出生时间" prop="userBirthday">
                                <el-date-picker
                                        v-model="userBaseForm.userBirthday"
                                        type="month"
                                        :editable="false"
                                        value-format="yyyy-MM"
                                        :default-value="defaultBirthdayDate"
                                        :picker-options="userBirthdayPickerOptions"
                                        placeholder="选择出生时间">
                                </el-date-picker>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8">
                            <el-form-item label="登录名" prop="userLoginName">
                                <el-input name="email" v-model="userBaseForm.userLoginName"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8">
                            <el-form-item label="电子邮箱" prop="userEmail">
                                <el-input name="email" v-model="userBaseForm.userEmail"></el-input>
                            </el-form-item>
                        </el-col>

                        <el-col :span="8">
                            <el-form-item label="手机号">
                                <span style="font-size: 12px;" :class="{'empty-color empty': !userBaseInfo.userMobile}">{{userBaseInfo.userMobile || '请保存后添加手机号' }}</span>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8">
                            <el-form-item label="国家/地区" prop="userCountry"
                                          class="el-input--mini">
                                <city-dropdown v-model="userBaseForm.userCountry" class-name="el-input__inner"
                                               placeholder="填写/选择"
                                               :city-data="cityIdKeyData">
                                    <a slot="rightSelected" href="javascript:void (0)"
                                       @click="dialogVisibleCityPicker=true">选择</a>
                                </city-dropdown>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8">
                            <el-form-item label="民族" prop="userNational">
                                <el-input v-model="userBaseForm.userNational"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8">
                            <el-form-item label="政治面貌" prop="userPolitical">
                                <el-select v-model="userBaseForm.userPolitical" placeholder="请选择">
                                    <el-option
                                            v-for="item in politicsStatuses"
                                            :key="item"
                                            :label="item"
                                            :value="item">
                                    </el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                        <el-col :span="16">
                            <el-form-item label="证件号" prop="userIdNumber"
                                          :rules="userBaseFormRule[userBaseForm.userIdType == 1 ? 'idNumberIdentity' : 'idNumberPassport']"
                                          >
                                <el-input placeholder="请输入证件号" v-model="userBaseForm.userIdNumber"
                                          class="input-with-select_identity">
                                    <el-form-item prop="idType" slot="prepend" style="margin-bottom: 0;height: 26px;">
                                        <el-select v-model="userBaseForm.userIdType" placeholder="请选择证件类型">
                                            <el-option v-for="idType in idTypes" :label="idType.label"
                                                       :value="idType.value" :key="idType.id"></el-option>
                                        </el-select>
                                    </el-form-item>
                                </el-input>
                            </el-form-item>
                        </el-col>


                        <el-col :span="8">
                            <el-form-item label="QQ" prop="userQq">
                                <el-input placeholder="请输入QQ号码" v-model="userBaseForm.userQq"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="24">
                            <el-form-item label="联系地址" prop="address">
                                <el-input placeholder="请输入内容" v-model="userBaseForm.address"></el-input>
                            </el-form-item>
                        </el-col>
                    </el-row>
                </el-form>
            </div>
            <div class="user_detail-inner">
                <div class="user_detail-title-handler">
                    <div class="ud-row-handler">
                        <el-button type="text" size="mini" title="编辑" v-show="!isEditEducationInfo" :disabled="isUpdating || isEditEducationInfo"
                                   @click.prevent="showEditForm('userEducationForm')">
                            <i class="iconfont icon-bianji"></i></el-button>
                        <el-button type="text" title="取消" size="mini" v-show="isEditEducationInfo" :disabled="isUpdating || !isEditEducationInfo"
                                   @click.prevent="isEditEducationInfo = false"><i
                                class="iconfont icon-mianfeiquxiao"></i></el-button>
                        <el-button type="text" size="mini" title="保存" :disabled="isUpdating || !isEditEducationInfo"
                                   @click.prevent="updateForm('userEducationForm')"><i
                                class="iconfont icon-iconset0237"></i>
                        </el-button>
                    </div>
                    <div class="ud-row-title"><span class="name">学历信息</span></div>
                </div>
                <el-row v-show="!isEditEducationInfo" :gutter="10" label-width="90px">
                    <el-col :span="8">
                        <e-col-item label="入学年月：" align="right">{{userEducationInfo.enterdate}}</e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item label="学年制：" align="right">{{userEducationInfo.cycle |
                            selectedFilter(cyclesEntries)}}年
                        </e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item label="现状：" align="right">{{userEducationInfo.currState |
                            selectedFilter(currStateEntries)}}
                        </e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item label="学号：" align="right">{{userEducationInfo.userNo}}</e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item label="院系/专业：" align="right">{{userEducationForm.userProfessional |
                            cascaderCollegeFilter(collegeEntries)}}
                        </e-col-item>
                    </el-col>
                    <el-col :span="8" v-show="isInCurStates('tClass')">
                        <e-col-item label="班级：" align="right">{{userEducationInfo.tClass}}</e-col-item>
                    </el-col>
                    <el-col :span="8" v-show="isInCurStates('userEducation')">
                        <e-col-item label="学历：" align="right">{{userEducationInfo.userEducation |
                            selectedFilter(enducationLevelsEntries)}}
                        </e-col-item>
                    </el-col>
                    <el-col :span="8" v-show="isInCurStates('userDegree')">
                        <e-col-item label="学位：" align="right">{{userEducationInfo.userDegree |
                            selectedFilter(degreeTypesEntries)}}
                        </e-col-item>
                    </el-col>
                    <el-col :span="8" v-show="isInCurStates('instudy')">
                        <e-col-item label="在读学位：" align="right">{{userEducationInfo.instudy |
                            selectedFilter(degreeTypesEntries)}}
                        </e-col-item>
                    </el-col>
                    <el-col :span="8" v-show="isInCurStates('temporaryDate')">
                        <e-col-item label="休学时间：" align="right">{{userEducationInfo.temporaryDate}}
                        </e-col-item>
                    </el-col>
                    <el-col :span="8" v-show="isInCurStates('graduation')">
                        <e-col-item label="毕业时间：" align="right">{{userEducationInfo.graduation}}</e-col-item>
                    </el-col>
                    <el-col :span="24">
                        <e-col-item label="技术领域：" align="right">{{userEducationInfo.userDomainIdList |
                            checkboxFilter(technologyFieldsEntries)}}
                        </e-col-item>
                    </el-col>
                </el-row>
                <el-form v-show="isEditEducationInfo" :model="userEducationForm" ref="userEducationForm" size="mini" :rules="userEducationFormRule"
                         label-width="80px"
                         class="form-label-font12 user-form">
                    <el-row :gutter="10">
                        <el-col :span="8">
                            <el-form-item label="入学年月" prop="enterdate">
                                <el-date-picker
                                        v-model="userEducationForm.enterdate"
                                        value-format="yyyy-MM"
                                        :default-value="defaultEnterDate"
                                        type="month"
                                        :editable="false"
                                        :picker-options="enterdatePickerOptions"
                                        @change="userEducationForm.currState = ''"
                                        placeholder="选择入学年月">
                                </el-date-picker>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8">
                            <el-form-item label="学年制" prop="cycle">
                                <el-select v-model="userEducationForm.cycle" @change="userEducationForm.currState = ''" placeholder="-请选择-">
                                    <el-option v-for="cycle in cycles" :value="cycle.value" :label="cycle.label+'年'"
                                               :key="cycle.id"></el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8">
                            <el-form-item label="现状" prop="currState">
                                <el-select v-model="userEducationForm.currState" placeholder="-请选择-">
                                    <el-option v-for="currState in currStatesCp" :value="currState.value"
                                               :disabled="currState.disabled"
                                               :label="currState.label" :key="currState.id"></el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                    </el-row>
                    <el-row :gutter="10">
                        <el-col :span="8">
                            <el-form-item label="学号" prop="userNo" :rules="userEducationForm.currState != '2' ? userEducationFormRule.userNo: []">
                                <el-input placeholder="请输入学号" v-model="userEducationForm.userNo"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8">
                            <el-form-item label="院系/专业"
                                          prop="userProfessional"
                                          >
                                <el-cascader
                                        style="width: 100%"
                                        ref="cascader"
                                        :options="collegesTree"
                                        :clearable="true"
                                        v-model="userEducationForm.userProfessional"
                                        :props="{
                                            label: 'name',
                                            value: 'id',
                                            children: 'children'
                                        }"
                                        >
                                </el-cascader>
                            </el-form-item>
                        </el-col>
                        <el-col v-if="isInCurStates('tClass')" :span="8">
                            <el-form-item label="班级" prop="tClass">
                                <el-input v-model="userEducationForm.tClass"></el-input>
                            </el-form-item>
                        </el-col>
                    </el-row>
                    <el-row :gutter="10">
                        <el-col v-if="isInCurStates('userEducation')" :span="8">
                            <el-form-item label="学历"  prop="userEducation"
                                         >
                                <el-select v-model="userEducationForm.userEducation" placeholder="-请选择-">
                                    <el-option v-for="enducationLevel in enducationLevels"
                                               :value="enducationLevel.value" :label="enducationLevel.label"
                                               :key="enducationLevel.id"></el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                        <el-col v-if="isInCurStates('userDegree')" :span="8">
                            <el-form-item label="学位" prop="userDegree"
                                          >
                                <el-select v-model="userEducationForm.userDegree" placeholder="-请选择-">
                                    <el-option v-for="degreeType in degreeTypes" :value="degreeType.value"
                                               :label="degreeType.label" :key="degreeType.id"></el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                        <el-col v-if="isInCurStates('instudy')" :span="8">
                            <el-form-item label="在读学位" prop="instudy"
                                          >
                                <el-select v-model="userEducationForm.instudy" placeholder="-请选择-">
                                    <el-option v-for="degreeType in degreeTypes" :value="degreeType.value"
                                               :label="degreeType.label" :key="degreeType.id"></el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8" v-if="isInCurStates('temporaryDate')">
                            <el-form-item label="休学时间" prop="temporaryDate"
                                          >
                                <el-date-picker
                                        v-model="userEducationForm.temporaryDate"
                                        type="date"
                                        value-format="yyyy-MM-dd"
                                        :editable="false"
                                        :picker-options="temporaryDatePickerOption"
                                        placeholder="选择休学时间">
                                </el-date-picker>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8" v-if="isInCurStates('graduation')">
                            <el-form-item label="毕业时间" prop="graduation"
                                          >
                                <el-date-picker
                                        v-model="userEducationForm.graduation"
                                        type="date"
                                        value-format="yyyy-MM-dd"
                                        :editable="false"
                                        :picker-options="graduationDatePickerOption"
                                        placeholder="选择毕业时间">
                                </el-date-picker>
                            </el-form-item>
                        </el-col>
                    </el-row>
                    <el-row>
                        <el-col :span="24">
                            <el-form-item label="技术领域" prop="userDomainIdList"
                                           >
                                <el-select v-model="userEducationForm.userDomainIdList" name multiple placeholder="请选择" style="width: 100%">
                                    <el-option
                                            v-for="item in technologyFields"
                                            :key="item.value"
                                            :label="item.label"
                                            :value="item.value">
                                    </el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                    </el-row>
                </el-form>
            </div>
            <div class="user_detail-inner user_detail-inner-experience">
                <div class="user_detail-title-handler">
                    <div class="ud-row-title"><span class="name">项目经历</span></div>
                </div>
                <el-row :gutter="10">
                    <el-col :span="12" v-for="project in projectList" :key="project.id">
                        <div class="experience-card">
                            <div class="experience-card-header">
                                <h4 class="experience-card-title">{{project.name}}</h4>
                            </div>
                            <div class="experience-card-body">
                                <div class="exp-pic">
                                    <a href="javascript: void(0);"><img src="/img/video-default.jpg"></a>
                                </div>
                                <div class="exp-info">
                                    <e-col-item label="担任角色：" label-width="72px">{{ getRoleName(project) }}</e-col-item>
                                    <e-col-item label="项目级别：" label-width="72px">{{project.level}}</e-col-item>
                                    <e-col-item label="项目结果：" label-width="72px">{{project.result}}</e-col-item>
                                    <e-col-item label="项目周期：" label-width="72px">{{getProjectRange(project)}}
                                    </e-col-item>
                                </div>
                                <div class="exp-intro">
                                    <e-col-item label="项目简介：" label-width="72px">
                                        {{project.introduction}}
                                    </e-col-item>
                                </div>
                            </div>
                            <div class="experience-card-footer">
                                <div class="text-right">
                                    <el-tag v-show="project.proName" type="info" size="mini">{{project.proName}}
                                    </el-tag>
                                    <el-tag v-show="project.year" type="info" size="mini">{{project.year}}</el-tag>
                                </div>
                            </div>
                        </div>
                    </el-col>
                    <div v-show="!projectList" class="text-center">
                        <div class="user_experience-title none">
                            <span>暂无项目经历</span>
                        </div>
                    </div>
                </el-row>
            </div>

            <div class="user_detail-inner user_detail-inner-experience" style="margin-bottom: 60px;">
                <div class="user_detail-title-handler">
                    <div class="ud-row-title"><span class="name">大赛经历</span></div>
                </div>
                <el-row :gutter="10">
                    <el-col :span="12" v-for="contest in contestList" :key="contest.id">
                        <div class="experience-card">
                            <div class="experience-card-header">
                                <h4 class="experience-card-title">{{contest.pName}}</h4>
                            </div>
                            <div class="experience-card-body">
                                <div class="exp-pic">
                                    <a href="javascript: void(0);"><img src="/img/video-default.jpg"></a>
                                </div>
                                <div class="exp-info">
                                    <e-col-item label="担任角色：" label-width="72px">{{ getRoleName(contest) }}</e-col-item>
                                    <e-col-item label="大赛级别：" label-width="72px">{{contest.level}}</e-col-item>
                                    <e-col-item label="大赛获奖：" label-width="72px">{{contest.award}}</e-col-item>
                                    <e-col-item label="大赛周期：" label-width="72px">{{getProjectRange(contest)}}
                                    </e-col-item>
                                </div>
                                <div class="exp-intro">
                                    <e-col-item label="大赛简介：" label-width="72px">
                                        {{contest.introduction}}
                                    </e-col-item>
                                </div>
                            </div>
                            <div class="experience-card-footer">
                                <div class="text-right">
                                    <el-tag v-show="contest.type" type="info" size="mini">{{contest.type}}</el-tag>
                                    <el-tag v-show="contest.year" type="info" size="mini">{{contest.year}}</el-tag>
                                </div>
                            </div>
                        </div>
                    </el-col>
                    <div v-show="!contestList" class="text-center">
                        <div class="user_experience-title none">
                            <span>暂无大赛经历</span>
                        </div>
                    </div>
                </el-row>
            </div>
            <div v-show="false" class="user_detail-inner">
                <div class="user_detail-title-handler">
                    <div class="ud-row-title"><span class="name">双创活动</span><span class="tip-num">（12）</span></div>
                </div>
                <div class="text-center">
                    <div class="user_experience-title none">
                        <span>暂无</span>
                    </div>
                </div>
            </div>
            <div v-show="false" class="user_detail-inner">
                <div class="user_detail-title-handler">
                    <div class="ud-row-title"><span class="name">技能证书</span><span class="tip-num">（12）</span></div>
                </div>
                <div class="text-center">
                    <div class="user_experience-title none">
                        <span>暂无</span>
                    </div>
                </div>
            </div>
            <div v-show="false" class="user_detail-inner">
                <div class="user_detail-title-handler">
                    <div class="ud-row-title"><span class="name">双创学分</span><span class="tip-num">（12）</span></div>
                </div>
                <div class="text-center">
                    <div class="user_experience-title none">
                        <span>暂无</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <el-dialog
            title="选择城市"
            :visible.sync="dialogVisibleCityPicker"
            :before-close="handleCityPickerClose">
        <city-picker v-model="userBaseForm.userCountry" :city-data="city" :tab-active-key.sync="cityTab"
                     @selected="cityHandleSelected"></city-picker>
    </el-dialog>


    <el-dialog
            title="修改手机"
            width="500px"
            :visible.sync="dialogVisibleChangeMobile"
            :before-close="handleChangeMobileClose">
        <mobile-form ref="dialogMobileForm" :mobile.sync="newMobile" :old-mobile="userBaseInfo.userMobile"
                     @update-user-mobile="updateUserMobile"
                     :is-add="!userBaseInfo.userMobile"></mobile-form>
        <div slot="footer" class="dialog-footer">
            <el-button size="mini" :disabled="isUpdating" @click.stop.prevent="handleChangeMobileClose">取消</el-button>
            <el-button size="mini" :disabled="isUpdating" type="primary" @click.stop.prevent="handleUpdateMobile">确定
            </el-button>
        </div>
    </el-dialog>


    <el-dialog title="上传图像"
               width="440px"
               :visible.sync="dialogVisibleChangeUserPic"
               :before-close="handleChangeUserPicClose">
        <e-pic-file v-model="userAvatar" :disabled="isUpdating" @get-file="getUserPicFile"></e-pic-file>
        <cropper-pic :img-src="userAvatar" :disabled="isUpdating" ref="cropperPic"></cropper-pic>
        <div slot="footer" class="dialog-footer">
            <el-button size="mini" :disabled="isUpdating" @click="handleChangeUserPicClose">取消</el-button>
            <el-button size="mini" :disabled="!userPicFile || isUpdating" type="primary" @click="updateUserPic">上传
            </el-button>
        </div>
    </el-dialog>
</div>





<script>

    ;+function (Vue) {
        'use strict';


        var app = new Vue({
            el: '#app',
            mixins: [Vue.userBaseFormMixin, Vue.verifyExpressionMixin, Vue.collegesMixin],
            data: function () {
                var idTypes = JSON.parse('${fns:toJson(fns:getDictList('id_type'))}') || [];
                var cycles = JSON.parse('${fns: toJson(fns:getDictList('0000000262'))}') || [];
                var currStates = JSON.parse('${fns: toJson(fns:getDictList('current_sate'))}') || [];
                var enducationLevels = JSON.parse('${fns: toJson(fns:getDictList('enducation_level'))}') || [];
                var degreeTypes = JSON.parse('${fns: toJson(fns:getDictList('degree_type'))}') || [];
                var technologyFields = JSON.parse('${fns: toJson(fns: getDictList("technology_field"))}') || [];
                var colleges = JSON.parse('${fns: toJson(fns: getOfficeList())}') || [];
                var self = this;
                var isEdit = globalUtils.getQueryString('isEdit');
                var tenYearsMilliseconds = moment.duration(10, 'years').asMilliseconds();

                colleges = colleges.filter(function (item) {
                    return item.id !== '1';
                });

                return {
                    id: '',
                    userId: '${cuser}',
                    userPhoto: '',
                    userAvatar: '',
                    idTypes: idTypes,
                    politicsStatuses: ['中共党员', '共青团员', '民主党派人士', '无党派民主人士', '普通公民'],
                    cycles: cycles,
                    currStates: currStates,
                    enducationLevels: enducationLevels,
                    degreeTypes: degreeTypes,
                    technologyFields: technologyFields,
                    userBaseInfo: {},
                    userEducationInfo: {},
                    originUserInfo: {},
                    educationInfoForm: {},
                    userPicFile: null,
                    isUpdating: false,
                    colleges: colleges,
                    isDefaultCollegeRootId: false, //去掉学院;

                    dialogVisibleChangeUserPic: false,//修改用户图像
                    dialogVisibleChangeMobile: false, //修改手机号

                    dialogVisibleCityPicker: false,

                    projectList: [],
                    contestList: [],

                    newMobile: '',

                    city: cityData,

                    userBirthdayPickerOptions: {
                        disabledDate: function (time) {
                            var maxDate = self.userEducationForm.enterdate || new Date().toString();
                            if (maxDate) {
                                return time.getTime() >= new Date(maxDate).getTime() - tenYearsMilliseconds;
                            }
                            return false;
                        }
                    },

                    enterdatePickerOptions: {
                        disabledDate: function (time) {
                            var minDate, maxDate;
                            var timeM = time.getTime();
                            if (self.userBaseForm.userBirthday) {
                                minDate = new Date(self.userBaseForm.userBirthday).getTime();
                            }
                            maxDate = new Date().getTime();
                            if (minDate && maxDate) {
                                return timeM <= minDate || timeM >= maxDate
                            } else {
                                if (minDate) {
                                    return timeM < minDate
                                }
                                if (maxDate) {
                                    return timeM > maxDate
                                }
                            }

                            return false;
                        }
                    },

                    temporaryDatePickerOption: {
                        disabledDate: function (time) {
                            var minDate = self.userEducationForm.enterdate;
                            var cycle = self.userEducationForm.cycle;
                            var cycleMilliseconds = cycle ? moment.duration(parseInt(self.cyclesEntries[cycle]), 'years').asMilliseconds() : 0;
                            var tTime = time.getTime();
                            var minTime;
                            if (minDate) {
                                minTime = new Date(minDate).getTime()
                                return time.getTime() < minTime || tTime > cycleMilliseconds + minTime;
                            }
                            return false;
                        }
                    },

                    graduationDatePickerOption: {
                        disabledDate: function (time) {
                            var minDate = self.userEducationForm.enterdate;
                            var cycle = self.userEducationForm.cycle;
                            var cycleMilliseconds = cycle ? moment.duration(parseInt(self.cyclesEntries[cycle]), 'years').asMilliseconds() : 0;
                            if (minDate) {
                                return time.getTime() < new Date(minDate).getTime() + cycleMilliseconds;
                            }
                            return false;
                        }
                    },

                    cityDropdownVisible: false,
                    cityTab: 'hotCities',
                    isEditBaseInfo: isEdit == '1',
                    isEditEducationInfo:  isEdit == '1',


                    educationCurStateEntries: {
                        '1': ['tClass', 'instudy'],
                        '2': ['graduation', 'userEducation', 'userDegree'],
                        '3': ['temporaryDate']
                    },
                }
            },
            filters: {
                userCountryName: function (value, cityIdKeyData) {
                    if (!value) {
                        return '';
                    }
                    if (cityIdKeyData[value]) {
                        return cityIdKeyData[value].shortName
                    }
                    return value
                }
            },
            computed: {
                defaultEnterDate: function () {
                    return moment(new Date().setMonth(8)).subtract(4, 'year').format('YYYY-MM');
                },
                defaultBirthdayDate: function () {
                    return moment(new Date()).subtract(10, 'year').format('YYYY-MM');
                },



                currStatesCp: function () {
                    var enterDate = this.userEducationForm.enterdate;
                    var cycle = this.userEducationForm.cycle;
                    var cycleLabel = cycle ? this.cyclesEntries[cycle] : 0;
                    var now = Date.now();
                    var currStates = [];
                    var disabledValue = '';
                    if (!enterDate || !cycleLabel) {
                        disabledValue = '';
                    } else if (now > moment.duration(parseInt(cycleLabel), 'years').asMilliseconds() + new Date(enterDate).getTime()) {
                        disabledValue = '1,3';
                    } else {
                        disabledValue = '2';
                    }

                    this.currStates.forEach(function (item, i) {
                        currStates.push({
                            id: item.id,
                            label: item.label,
                            value: item.value,
                            disabled: disabledValue.indexOf(item.value) > -1
                        })
                    });
                    return currStates
                },

                technologyFieldsEntries: {
                    get: function () {
                        return this.getEntries(this.technologyFields)
                    }
                },

                idTypesEntries: {
                    get: function () {
                        return this.getEntries(this.idTypes)
                    }
                },
                cyclesEntries: {
                    get: function () {
                        return this.getEntries(this.cycles)
                    }
                },

                currStateEntries: {
                    get: function () {
                        return this.getEntries(this.currStates)
                    }
                },

                enducationLevelsEntries: {
                    get: function () {
                        return this.getEntries(this.enducationLevels)
                    }
                },

                degreeTypesEntries: {
                    get: function () {
                        return this.getEntries(this.degreeTypes)
                    }
                },

                cityIdKeyData: function () {
                    var data = {};
                    for (var i = 0; i < this.city.length; i++) {
                        var city = this.city[i];
                        data[city.id] = city;
                    }
                    return data;
                }
            },
            methods: {


                handleChangeUserPicClose: function () {
                    this.userPicFile = null;
                    this.dialogVisibleChangeUserPic = false;
                },

                handleChangeUserPicOpen: function () {
                    var userPhoto = this.userPhoto;
                    this.dialogVisibleChangeUserPic = true;
                    this.$nextTick(function () {
                        this.userAvatar = userPhoto.indexOf('/tool') > -1 ? this.addFtpHttp(userPhoto) : '';
                    })
                },

                handleCityPickerClose: function () {
                    this.dialogVisibleCityPicker = false;
                    this.cityTab = 'hotCities'
                },



                isInCurStates: function (k) {
                    var currState = this.userEducationForm.currState;
                    if (!currState) {
                        return false;
                    }
                    return this.educationCurStateEntries[currState].indexOf(k) > -1;
                },

                cityHandleSelected: function () {
                    this.dialogVisibleCityPicker = false;
                },


                handleChangeMobileClose: function () {
                    this.$refs.dialogMobileForm.clearMobileForm();
                    this.dialogVisibleChangeMobile = false;
                },

                handleChangeMobile: function () {
                    this.dialogVisibleChangeMobile = true;
                },


                handleUpdateMobile: function () {
                    this.$refs.dialogMobileForm.mobileFormValidate()
                },

                updateUserMobile: function (mobileForm) {
                    var self = this;
                    this.isUpdating = true;
                    this.$axios.post('/sys/frontStudentExpansion/updateUserMobile?mobile=' + mobileForm.mobile + '&userId=' + mobileForm.id).then(function (data) {
                        if (data.status) {
                            self.userBaseInfo.userMobile = mobileForm.mobile;
                            self.userBaseForm.userMobile = mobileForm.mobile;
                            self.dialogVisibleChangeMobile = false;
                        }
                        self.show$message(data);
                        self.isUpdating = false;
                    }).catch(function () {
                        self.isUpdating = false;
                    })
                },

                getRoleName: function (project) {
                    if (this.userId === project.leaderId) {
                        return '项目负责人'
                    } else {
                        if (project.userType === '1') {
                            return '组成员'
                        }
                    }
                    return '导师'
                },
                getProjectRange: function (project) {
                    var startDate, endDate;
                    if (project.startDate) {
                        startDate = moment(project.startDate).format('YYYY-MM-DD');
                    }
                    if (project.endDate) {
                        endDate = moment(project.endDate).format('YYYY-MM-DD');
                    }
                    if (startDate) {
                        return startDate + '至' + endDate;
                    }
                    return ''
                },


                showEditForm: function (name) {
                    var self = this;
                    if((name === 'userEducationForm' && this.isEditBaseInfo) || (name === 'userBaseForm' && this.isEditEducationInfo)){
                        this.$confirm('是否保存'+ (this.isEditBaseInfo ? '基本信息' : '学历信息'), '提示', {
                            confirmButtonText: '保存',
                            cancelButtonText: '取消',
                            type: 'warning'
                        }).then(function () {
                            self.updateForm(name === 'userBaseForm' ? 'userEducationForm' : 'userBaseForm')
                        }).catch(function () {
//                            self.catchCancelShow(name)
                        })
                    }else {
                        this.catchCancelShow(name)
                    }
                },


                catchCancelShow: function (name) {
                    if (name === 'userBaseForm' ) {
                        Object.assign(this.userBaseForm, this.userBaseInfo);
                        this.isEditBaseInfo = true;
                        this.isEditEducationInfo = false;
                    }
                    if (name === 'userEducationForm' ) {
                        Object.assign(this.userEducationForm, this.userEducationInfo);
                        this.isEditEducationInfo = true;
                        this.isEditBaseInfo = false;
                    }
                },

                updateForm: function (formname) {
                    var self = this;
                    this.$refs[formname].validate(function (valid) {
                        if (valid) {
                            var userBaseForm = self.getUpdateUserInfoParams(self.userBaseForm);
                            var educationForm = self.getUpdateUserInfoParams(self.userEducationForm);
                            var data = {};
                            userBaseForm.id = self.userId; //id为用户ID;
                            data['base'] = userBaseForm;
                            data['education'] = educationForm;
                            self.ajaxUpdateUserInfo(data, formname, userBaseForm, educationForm);
                        }
                    })
                },

                ajaxUpdateUserInfo: function (userInfoParams, formname, userBaseForm, educationForm) {
                    var self = this;
                    this.$axios.post('/sys/frontStudentExpansion/ajaxUpdateUserInfo?userId=' + this.userId, userInfoParams).then(function (response) {
                        var data = response.data;
                        if (data.status) {
                            if (formname === 'userBaseForm') {
                                Object.assign(self.userBaseInfo, self.userBaseForm);
                                self.isEditBaseInfo = false;
                            }
                            if (formname === 'userEducationForm') {
                                Object.assign(self.userEducationInfo, self.userEducationForm);
                                self.isEditEducationInfo = false;
                            }
                            self.isUpdating = false;
                        }
                        self.$msgbox({
                            title: '提示',
                            type: data.status ? 'success' : 'error',
                            message: data.msg
                        })
                    }).catch(function (error) {
                        self.$msgbox({
                            title: '提示',
                            type: 'error',
                            message: error.response.data
                        })
                    })
                },


                updateUserPic: function () {
                    var data = this.$refs.cropperPic.getData();
                    var self = this;
                    var formData = new FormData();

                    if(data.x < 0 || data.y < 0){
                        this.show$message({
                            status: false,
                            msg: '超出边界，请缩小裁剪框，点击上传'
                        });
                        return false;
                    }

                    this.isUpdating = true;
                    formData.append('upfile', this.userPicFile);
                    self.$axios({
                        method: 'POST',
                        url: '/ftp/ueditorUpload/cutImgToTempDir?folder=user&x=' + parseInt(data.x) + '&y=' + parseInt(data.y) + '&width=' + parseInt(data.width) + '&height=' + parseInt(data.height),
                        data: formData
                    }).then(function (response) {
                        var data = response.data;
                        if (data.state === 'SUCCESS') {
                            self.moveFile(data.ftpUrl);
                        }
                    }).catch(function (error) {

                    })
                },

                moveFile: function (url) {
                    var self = this;
                    return this.$axios.post('/sys/user/ajaxUpdatePhoto?photo=' + url + "&userId=" + this.userId).then(function (response) {
                        var data = response.data;
                        self.show$message(data);
                        if (data.status) {
                            data = data.datas;
                            self.dialogVisibleChangeUserPic = false;
                            self.userAvatar = self.addFtpHttp(data.photo);
                            self.userPhoto = data.photo;
                            self.userPicFile = null;
                        }
                        self.isUpdating = false;

                    }).catch(function (error) {
                        self.isUpdating = false;
                    })
                },


                getUserPicFile: function (file) {
                    this.userPicFile = file;
                },

                getUserInfoParams: function (data, userColumn) {
                    var user = data.user;
                    for (var k in userColumn) {
                        if (userColumn.hasOwnProperty(k)) {
                            if (/user/.test(k) && k != 'userId') {
                                var nk = globalUtils.lowerCaseCamel(k);
                                user[nk.replace('user', '')] = userColumn[k];
                            } else {
                                data[k] = userColumn[k];
                            }
                        }
                    }
                    return data;
                },

                getUpdateUserInfoParams: function (userColumn) {
                    var data = {};
                    for (var k in userColumn) {
                        if (userColumn.hasOwnProperty(k) && userColumn[k]) {
                            if (/user/.test(k) && k != 'userId') {
                                var nk = globalUtils.lowerCaseCamel(k);
                                if (nk.indexOf('professional') > -1) {
                                    data['professional'] = userColumn[k][1];
                                    data['officeId'] = userColumn[k][0];
                                } else {
                                    data[nk.replace('user', '')] = userColumn[k];
                                }
                            } else if (k === 'tClass') {
                                data['tclass'] = userColumn[k];
                            } else {
                                data[k] = userColumn[k];
                            }
                        }
                    }
                    data['id'] = this.id;
                    data['userId'] = this.userId;
                    return data;
                },

                ajaxGetUserInfoById: function () {
                    var self = this;
                    this.$axios.get('/sys/frontStudentExpansion/ajaxGetUserInfoById?userId=' + this.userId).then(function (response) {
                        var data = response.data;
                        if (data.status) {
                            self.originUserInfo = data.datas;
                            self.id = data.datas.id;
                            self.userId = data.datas.user.id;
                            self.userBaseInfo = Object.assign({}, self.getUserColumnDetail(data.datas, self.userBaseForm));
                            self.userEducationInfo = Object.assign({}, self.getUserColumnDetail(data.datas, self.userEducationForm));
                            self.userAvatar = self.addFtpHttp(data.datas.user.photo);
                            self.userPhoto = data.datas.user.photo;
                        }
                    })
                },

                ajaxGetUserProjectById: function () {
                    var self = this;
                    this.$axios.get('/sys/frontStudentExpansion/ajaxGetUserProjectById?userId=' + this.userId).then(function (response) {
                        var data = response.data;
                        if (data.status) {
                            self.projectList = data.datas;
                        }
                    })
                },
                ajaxGetUserGContestById: function () {
                    var self = this;
                    this.$axios.get('/sys/frontStudentExpansion/ajaxGetUserGContestById?userId=' + this.userId).then(function (response) {
                        var data = response.data;
                        if (data.status) {
                            self.contestList = data.datas;
                        }
                    })
                },

                addFtpHttp: function (url) {
                    if (!url) {
                        return ''
                    }
                    return this.ftpHttp + url.replace('/tool', '');
                },

                getUserColumnDetail: function (data, userColumn) {
                    var user = data.user;
                    for (var k in userColumn) {
                        if (userColumn.hasOwnProperty(k)) {
                            if (/user/.test(k)) {
                                var nk = globalUtils.lowerCaseCamel(k);
                                var removeUserNk = nk.replace('user', '');
                                if (user[removeUserNk]) {
                                    if (removeUserNk === 'professional') {
                                        var professionalParentId = this.collegeEntries[user[removeUserNk]] ? this.collegeEntries[user[removeUserNk]].parentId : '';
                                        userColumn[k] = [professionalParentId, user[removeUserNk]];
                                    } else if (k === 'userBirthday') {
                                        userColumn[k] = moment(user[removeUserNk]).format('YYYY-MM')
                                    } else {
                                        userColumn[k] = user[removeUserNk]
                                    }
                                }
                            } else {
                                if (data[k]) {
                                    if (k === 'enterdate' || k === 'temporaryDate' || k === 'graduation') {
                                        userColumn[k] = moment(data[k]).format('YYYY-MM')
                                    } else {
                                        userColumn[k] = data[k] || '';
                                    }
                                }
                            }
                        }
                    }
                    return userColumn;
                }
            },
            beforeMount: function () {
                this.ajaxGetUserInfoById();
                this.ajaxGetUserProjectById();
                this.ajaxGetUserGContestById();
            },
            mounted: function () {
                var self = this;

                window.onbeforeunload  = function () {
                    if(self.isEditBaseInfo || self.isEditEducationInfo){
                        window.event.returnValue = '您有信息还未保存，确认离开吗？'
                        return window.event.returnValue
                    }
                }
            }
        })
    }(Vue);


</script>

</body>
</html>