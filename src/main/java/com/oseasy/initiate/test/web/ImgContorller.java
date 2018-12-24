package com.oseasy.initiate.test.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.oseasy.pcore.common.web.BaseController;

/**
 * Created by zhangzheng on 2017/8/11.
 */
@Controller
@RequestMapping(value = "/ftp/img/")
public class ImgContorller extends BaseController {

    @RequestMapping(value = "testImgCut")
    public String testImgCut() {

        return "initiate/test/testImgCut";
    }

   //bootstrap 2.3.1
    @RequestMapping(value = "testImgCutTag")
    public String testImgCutTag() {
        return "initiate/test/testImgCutTag";
    }
   //bootstrap 3.3.5
    @RequestMapping(value = "frontTestImgCutTag")
    public String frontTestImgCutTag() {
        return "initiate/test/frontTestImgCutTag";
    }

}
