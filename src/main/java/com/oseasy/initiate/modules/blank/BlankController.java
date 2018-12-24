package com.oseasy.initiate.modules.blank;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by zhangzheng on 2017/4/8.
 */
@Controller
@RequestMapping(value = "${adminPath}/blank")
public class BlankController {
    @RequestMapping(value = "")
    public String blank(Model model) {
        model.addAttribute("msg","该模块还在建设中");
        return "error/msg";
    }
}
