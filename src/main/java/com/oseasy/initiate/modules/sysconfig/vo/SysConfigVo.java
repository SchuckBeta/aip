/**
  * Copyright 2017 bejson.com 
  */
package com.oseasy.initiate.modules.sysconfig.vo;

/**
 * Auto-generated: 2017-11-07 16:22:10
 *
 * @author bejson.com (i@bejson.com)
 * @website http://www.bejson.com/java2pojo/
 */
public class SysConfigVo {
	/**
	 * 
	 */
	/**
	 {
	    "teamConf": {
	        "maxOnOff": 1,
	        "max": 5,
	        "invitationOnOff": 1,
	        "joinOnOff": 1,
	        "intramuralValiaOnOff": 1,
	        "intramuralValia": {
	            "min": 0,
	            "max": 1
	        },
	        "teamCheckOnOff": 1,
	        "teamCreateReject": 2,
	        "teamUpdateReject": 2
	    },
	    "applyConf": {
	        "aOnOff": 1,
	        "bOnOff": 1,
	        "proConf": {
	            "aOnOff": 1,
	            "bOnOff": 1,
	            "cOnOff": 1,
	            "proSubTypeConf": [
	                {
	                    "subType": 1,
	                    "lowTypeConf": [
	                        {
	                            "lowType": 1,
	                            "personNumConf": {
	                                "teamNumOnOff": 1,
	                                "teamNum": {
	                                    "min": 1,
	                                    "max": 5
	                                },
	                                "schoolTeacherNumOnOff": 1,
	                                "schoolTeacherNum": {
	                                    "min": 0,
	                                    "max": 1
	                                },
	                                "enTeacherNumOnOff": 1,
	                                "enTeacherNumOn": {
	                                    "min": 0,
	                                    "max": 1
	                                }
	                            }
	                        },
	                        {
	                            "lowType": 2,
	                            "personNumConf": {
	                                "teamNumOnOff": 1,
	                                "teamNum": {
	                                    "min": 1,
	                                    "max": 5
	                                },
	                                "schoolTeacherNumOnOff": 1,
	                                "schoolTeacherNum": {
	                                    "min": 1,
	                                    "max": 2
	                                },
	                                "enTeacherNumOnOff": 1,
	                                "enTeacherNumOn": {
	                                    "min": 0,
	                                    "max": 1
	                                }
	                            }
	                        },
	                        {
	                            "lowType": 3,
	                            "personNumConf": {
	                                "teamNumOnOff": 1,
	                                "teamNum": {
	                                    "min": 1,
	                                    "max": 7
	                                },
	                                "schoolTeacherNumOnOff": 1,
	                                "schoolTeacherNum": {
	                                    "min": 1,
	                                    "max": 2
	                                },
	                                "enTeacherNumOnOff": 1,
	                                "enTeacherNumOn": {
	                                    "min": 0,
	                                    "max": 1
	                                }
	                            }
	                        }
	                    ]
	                }
	            ]
	        },
	        "gconConf": {
	            "aOnOff": 1,
	            "bOnOff": 1,
	            "cOnOff": 1,
	            "gconSubTypeConf": [
	                {
	                    "subType": 1,
	                    "personNumConf": {
	                        "teamNumOnOff": 1,
	                        "teamNum": {
	                            "min": 0,
	                            "max": 1
	                        },
	                        "schoolTeacherNumOnOff": 1,
	                        "schoolTeacherNum": {
	                            "min": 0,
	                            "max": 1
	                        },
	                        "enTeacherNumOnOff": 1,
	                        "enTeacherNumOn": {
	                            "min": 0,
	                            "max": 1
	                        }
	                    }
	                }
	            ]
	        }
	    }
	}
	*/
	private String graduateMonth;//毕业月份
    private TeamConf teamConf;//团队创建的配置
    private ApplyConf applyConf;//项目、大赛申报的配置
	private RegisterConf registerConf; // 注册控制
    public void setTeamConf(TeamConf teamConf) {
         this.teamConf = teamConf;
     }
     public TeamConf getTeamConf() {
         return teamConf;
     }

    public void setApplyConf(ApplyConf applyConf) {
         this.applyConf = applyConf;
     }
     public ApplyConf getApplyConf() {
         return applyConf;
     }
	public String getGraduateMonth() {
		return graduateMonth;
	}
	public void setGraduateMonth(String graduateMonth) {
		this.graduateMonth = graduateMonth;
	}

	public RegisterConf getRegisterConf() {
		return registerConf;
	}

	public void setRegisterConf(RegisterConf registerConf) {
		this.registerConf = registerConf;
	}
}