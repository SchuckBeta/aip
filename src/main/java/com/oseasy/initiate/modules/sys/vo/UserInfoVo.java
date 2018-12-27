/**
 * .
 */

package com.oseasy.initiate.modules.sys.vo;

import java.io.Serializable;

/**
 * 用户信息.
 * @author chenhao
 *
 */
public class UserInfoVo implements Serializable{
    public static final String UI_BASE = "base";
    public static final String UI_EDUCATION = "education";
    private static final long serialVersionUID = 1L;
    private UserBase base;
    private UserEducation education;

    public UserInfoVo() {
        super();
    }
    public UserInfoVo(UserBase base, UserEducation education) {
        super();
        this.base = base;
        this.education = education;
    }
    public UserBase getBase() {
        return base;
    }
    public void setBase(UserBase base) {
        this.base = base;
    }
    public UserEducation getEducation() {
        return education;
    }
    public void setEducation(UserEducation education) {
        this.education = education;
    }

//    /**
//     * 转换UserUInfoVo到StudentExpansion.
//     */
//    public static StudentExpansion convert(StudentExpansion sexpansion, UserInfoVo userInfoVo) {
//        if(userInfoVo == null){
//            return null;
//        }
//
//        if(sexpansion == null){
//            sexpansion = new StudentExpansion();
//        }
//        if(userInfoVo.getBase() != null){
//            UserBase userBase = userInfoVo.getBase();
//            if(sexpansion.getUser() == null){
//                sexpansion.setUser(CoreUtils.getUser());
//            }
//            User user = sexpansion.getUser();
//            user.setId(userBase.getId());
//            user.setLoginName(userBase.getLoginName());
//            user.setName(userBase.getName());
//            user.setSex(userBase.getSex());
//            user.setIdType(userBase.getIdType());
//            user.setIdNumber(userBase.getIdNumber());
//            user.setBirthday(userBase.getBirthday());
//            user.setEmail(userBase.getEmail());
//            user.setMobile(userBase.getMobile());
//            user.setQq(userBase.getQq());
//            user.setCountry(userBase.getCountry());
//            user.setNational(userBase.getNational());
//            user.setPolitical(userBase.getPolitical());
//            user.setIntroduction(userBase.getIntroduction());
//            user.setResidence(userBase.getResidence());
//
//            sexpansion.setUser(user);
//            sexpansion.setAddress(userBase.getAddress());
//        }
//
//        if(userInfoVo.getEducation() != null){
//            UserEducation userEducation = userInfoVo.getEducation();
//            if(sexpansion.getUser() != null){
//                User user = sexpansion.getUser();
//                user.setDomainIdList(userEducation.getDomainIdList());
//                user.setEducation(userEducation.getEducation());
//                user.setDegree(userEducation.getDegree());
//                user.setNo(userEducation.getNo());
//                user.setProfessional(userEducation.getProfessional());
//                if(StringUtil.isNotEmpty(userEducation.getOfficeId())){
//                    user.setOffice(new Office(userEducation.getOfficeId()));
//                }
//                sexpansion.setUser(user);
//            }
//            sexpansion.setId(userEducation.getId());
//            sexpansion.setEnterdate(userEducation.getEnterdate());
//            sexpansion.setCycle(userEducation.getCycle());
//            sexpansion.setGraduation(userEducation.getGraduation());
//            sexpansion.setCurrState(userEducation.getCurrState());
//            sexpansion.setInstudy(userEducation.getInstudy());
//            sexpansion.setTClass(userEducation.getTclass());
//            sexpansion.setInstudy(userEducation.getInstudy());
//            sexpansion.setTemporaryDate(userEducation.getTemporaryDate());
//        }
//        return sexpansion;
//    }
}
