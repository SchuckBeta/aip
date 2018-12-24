package com.oseasy.pact.modules.actyw.tool.process.vo;

/**
 * 表单表单组类型.
 * @author chenhao
 *
 */
public class FormThemeVo {
    private FormTheme theme;
    private FormPage page;
    private FlowPcms cms;
    private FlowPmenu menu;

    public FormThemeVo() {
        super();
    }

    public FormThemeVo(FormTheme theme, FormPage page, FlowPcms cms, FlowPmenu menu) {
        super();
        this.theme = theme;
        this.page = page;
        this.cms = cms;
        this.menu = menu;
    }

    public FormTheme getTheme() {
        return theme;
    }
    public void setTheme(FormTheme theme) {
        this.theme = theme;
    }
    public FormPage getPage() {
        return page;
    }
    public void setPage(FormPage page) {
        this.page = page;
    }
    public FlowPcms getCms() {
        return cms;
    }
    public void setCms(FlowPcms cms) {
        this.cms = cms;
    }
    public FlowPmenu getMenu() {
        return menu;
    }
    public void setMenu(FlowPmenu menu) {
        this.menu = menu;
    }
}
