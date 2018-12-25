/**
 *
 */
package com.oseasy.pcms.common.web.a;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.oseasy.pcore.common.web.BaseController;

/**
 * 网站Controller


 */
@Controller
@RequestMapping(value = "${adminPath}/cms")
public class CmsAcontroller extends BaseController{
    /*静态页面*/
    @RequestMapping(value = "page-{pageName}")
    public String viewPages(@PathVariable String pageName, Model model) {

        return "modules/website/pages/"+pageName;
    }

    /*静态页面2*/
    @RequestMapping(value = "html-{pageName}")
    public String htmlviewPages(@PathVariable String pageName, Model model) {
        return "modules/website/html/"+pageName;
    }
}
