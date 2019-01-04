/**
 * .
 */

package com.oseasy.pcms.common.utils;

import java.util.List;

import com.google.common.collect.Lists;
import com.oseasy.pcms.modules.cms.dao.CmsMenuDao;
import com.oseasy.pcms.modules.cms.entity.CmsMenu;
import com.oseasy.pcms.modules.cmss.dao.CmsSiteDao;
import com.oseasy.pcms.modules.cmss.dao.CmssMenuDao;
import com.oseasy.pcms.modules.cmss.dao.CmssSiteDao;
import com.oseasy.pcms.modules.cmss.entity.CmsSite;
import com.oseasy.pcms.modules.cmss.entity.CmssCategory;
import com.oseasy.pcms.modules.cmss.entity.CmssMenu;
import com.oseasy.pcms.modules.cmss.vo.CmsSiteType;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.utils.SpringContextHolder;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * .
 * @author chenhao
 *
 */
public class CmsUtil {
    private static CmsMenuDao cmsMenuDao = SpringContextHolder.getBean(CmsMenuDao.class);
    private static CmssMenuDao cmssMenuDao = SpringContextHolder.getBean(CmssMenuDao.class);
    private static CmsSiteDao cmsSiteDao = SpringContextHolder.getBean(CmsSiteDao.class);
    private static CmssSiteDao cmssSiteDao = SpringContextHolder.getBean(CmssSiteDao.class);

    /**
     * 获取当前App站点.
     * @return
     */
    public static CmsSite getAppCurr(){
        CmsSite pcmsSite = new CmsSite();
        pcmsSite.setType(CmsSiteType.WEB.getKey());
        pcmsSite.setIsZzd(CoreSval.YES);
        return cmsSiteDao.getCurr(pcmsSite);
    }

    /**
     * 获取前端App菜单列表.
     * @return List
     */
    public static List<CmssMenu> getAppCurrMenus(){
        CmsSite curSmsSite = getAppCurr();
        if((curSmsSite == null) || StringUtil.isEmpty(curSmsSite.getId())){
            return Lists.newArrayList();
        }
        return cmssMenuDao.findListBySite(new CmssMenu(curSmsSite.getId()));
    }

    /**
     * 获取当前Web站点.
     * @return
     */
    public static CmsSite getWebCurr(){
        CmsSite pcmsSite = new CmsSite();
        pcmsSite.setType(CmsSiteType.WEB.getKey());
        pcmsSite.setIsZzd(CoreSval.YES);
        return cmsSiteDao.getCurr(pcmsSite);
    }

    /**
     * 获取前端Web菜单列表.
     * @return List
     */
    public static List<CmssMenu> getWebCurrMenus(){
        CmsSite curSmsSite = getWebCurr();
        if((curSmsSite == null) || StringUtil.isEmpty(curSmsSite.getId())){
            return Lists.newArrayList();
        }
        List<CmssMenu> list = Lists.newArrayList();
        List<CmssMenu> sourcelist = cmssMenuDao.findListBySite(new CmssMenu(curSmsSite));
        CmssMenu.sortList(list, sourcelist, CmssMenu.getRootId(), true);
        return list;
    }

    /**
     * 获取当前站点组.
     * @return
     */
    public static CmsSite getCurr(){
        CmsSite pcmsSite = new CmsSite();
        pcmsSite.setIsZzd(CoreSval.NO);
        return cmsSiteDao.getCurr(pcmsSite);
    }

    /**
     * 获取站点组菜单列表.
     * @return
     */
    public static List<CmssMenu> getCurrMenus(){
        return cmssMenuDao.findListBySite(new CmssMenu(new CmsSite(getCurr())));
    }

    /******************************************************************************/



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
    public List getExcTemplateList(){
        //TODO CHENHAO
        return null;
    }

    /**
     * 根据模板列表.
     * @param resid
     * @return
     */
    public List getTemplateList(){
        //TODO CHENHAO
        return null;
    }

    /**
     * 根据Key和根节点ID获取栏目列表.
     * @param key
     * @param pid
     * @return
     */
    public List getCategorys(String key, String pid){
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
