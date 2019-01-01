/**
 * .
 */

package com.oseasy.pcms.common.utils;

import java.util.List;

import com.oseasy.pcms.modules.cms.dao.CmsMenuDao;
import com.oseasy.pcms.modules.cms.entity.CmsMenu;
import com.oseasy.pcms.modules.cmss.dao.CmssMenuDao;
import com.oseasy.pcms.modules.cmss.entity.CmssCategory;
import com.oseasy.pcms.modules.cmss.entity.CmssMenu;
import com.oseasy.pcore.common.utils.SpringContextHolder;

/**
 * .
 * @author chenhao
 *
 */
public class CmsUtil {
    private static CmsMenuDao cmsMenuDao = SpringContextHolder.getBean(CmsMenuDao.class);
    private static CmssMenuDao cmssMenuDao = SpringContextHolder.getBean(CmssMenuDao.class);

    /**
     * 根据资源id获得html代码.
     * @param resid
     * @return
     */
    public String getHtmlByTemplate(String resid){
        //TODO CHENHAO
        return "";
    }

    /**
     * 获取优秀展示模板列表.
     * @return
     */
    public java.util.List getExcTemplateList(){
        //TODO CHENHAO
        return null;
    }

    /**
     * 根据模板列表.
     * @param resid
     * @return
     */
    public java.util.List getTemplateList(){
        //TODO CHENHAO
        return null;
    }

    /**
     * 根据Key和根节点ID获取栏目列表.
     * @param key
     * @param pid
     * @return
     */
    public java.util.List getCategorys(String key, String pid){
        //TODO CHENHAO
        return null;
    }

    /**
     * 获取前端首页栏目列表.
     * @return
     */
    public java.util.List getCategorysIndex(){
        //TODO CHENHAO
        return null;
    }

    /**
     * 添加前缀.
     * @return
     */
    public String addCtxFront(String a, String ss, Integer id){
        //TODO CHENHAO
        return null;
    }

    /**
     * 获取前端首页底部链接.
     * @return
     */
    public List getCmsLinks(){
        //TODO CHENHAO
        return null;
    }

    /**
     * 获取前端首页栏目列表.
     * @return
     */
    public List site(){
        //TODO CHENHAO
        return null;
    }

    /**
     * 获取栏目列表.
     * @return
     */
    public List siteByCategoryId(String categoryId){
        //TODO CHENHAO
        return null;
    }

    /**
     * 替换html代码中的FTP链接.
     * @return
     */
    public String replaceFtpUrl(String content){
        //TODO CHENHAO
        return null;
    }

    /**
     * 获取当前前端首页信息及栏目列表.
     * @return
     */
    public String curSite(){
        //TODO CHENHAO
        return null;
    }

    /**
     * 根据actywId查找配置的项目类别.
     * @return
     */
    public List getProCategoryByActywId(String actywId){
        //TODO CHENHAO
        return null;
    }

    /**
     * 获取站点列表.
     * @return
     */
    public List getSiteList(){
        //TODO CHENHAO
        return null;
    }

    /**
     * 获取主导航列表.
     * @return
     */
    public List getMainNavList(String siteId){
        //TODO CHENHAO
        return null;
    }

    /**
     *获得栏目列表.
     * @return
     */
    public List getCategoryList(String siteId, String parentId, String number, String param){
        //TODO CHENHAO
        return null;
    }

    /**
     *获得栏目列表.
     * @return
     */
    public List getCategoryListByIds(String categoryIds){
        //TODO CHENHAO
        return null;
    }

    /**
     *获取文章列表.
     * @return
     */
    public List getArticleList(String siteId, String categoryId, String number, String param){
        //TODO CHENHAO
        return null;
    }

    /**
     *获取链接列表.
     * @return
     */
    public List getLinkList(String siteId, String categoryId, String number, String param){
        //TODO CHENHAO
        return null;
    }

    /**
     * .
     * @param cmssCategory
     * @return
     */
    public static String getUrlDynamic(CmssCategory cmssCategory) {
        // TODO Auto-generated method stub
        return null;
    }

    /**
     * .
     * @param string
     */
    public static void removeCache(String string) {
        // TODO Auto-generated method stub

    }

    public static List<CmsMenu> findAllCmsMenu() {
        return cmsMenuDao.findAllList(new CmsMenu());
    }
    public static List<CmssMenu> findAllCmssMenu() {
        return cmssMenuDao.findAllList(new CmssMenu());
    }
}
