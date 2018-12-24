package com.oseasy.pcore.common.config;

/**
 * 内容管理--错误信息枚举类
 *
 * Created by liangjie on 2018/8/30.
 */
public enum ApiConst {
    TOKEN_FAILED(1001,"token失效"),
    PARAM_ERROR(1002,"参数有误"),
    INNER_ERROR(1003,"内部错误"),
    MORE_ERROR(1005,"重复数据"),
    CATEGORYMORE_ERROR(1006,"栏目标识已存在"),
    SYSTEM_ERROR(1007,"标识已存在"),
    NULL_ERROR(1004,"数据为空");


    public static Integer STATUS_SUCCESS = 1;
    public static Integer STATUS_FAIL = 0;
    public static Integer CODE_REQUEST_SUCCESS = 1000;
    public static Integer CODE_TOKEN_FAILED_CODE = 1001;
    public static Integer CODE_PARAM_ERROR_CODE = 1002;
    public static Integer CODE_INNER_ERROR = 1003;
    public static Integer CODE_NULL_ERROR = 1004;
    public static Integer CODE_MORE_ERROR = 1005;
    public static Integer CODE_CATEGORYMORE_ERROR = 1006;
    public static Integer CODE_SYSTEM_ERROR = 1007;
    private Integer code;
    private String msg;

    public static String STATUS_SUCCESS_STR = "1";
    public static String STATUS_FAIL_STR = "0";

    public static String AUDITSTATUS_TODO_STR = "0";
    public static String AUDITSTATUS_SUCCESS_STR = "1";
    public static String AUDITSTATUS_FAIL_STR = "2";

    ApiConst(Integer code,String msg){
        this.code = code;
        this.msg = msg;
    }

    public java.lang.Integer getCode() {
        return code;
    }

    public void setCode(java.lang.Integer code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }



    public static String getErrMsg(Integer code) {
        for(ApiConst cmsApiConst : ApiConst.values()){
            if(code.equals(cmsApiConst.getCode())){
                return cmsApiConst.getMsg();
            }
        }
        return INNER_ERROR.getMsg();
    }

}
