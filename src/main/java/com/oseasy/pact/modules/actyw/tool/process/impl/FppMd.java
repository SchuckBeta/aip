/**
 * .
 */

package com.oseasy.pact.modules.actyw.tool.process.impl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

import com.oseasy.initiate.modules.attachment.entity.SysAttachment;
import com.oseasy.initiate.modules.attachment.service.SysAttachmentService;
import com.oseasy.initiate.modules.promodel.entity.ProModel;

/**
 * 民大表单参数初始化，ProModel，SysAttachmentService，ProModelMdService 必填.
 * @author chenhao
 */
public class FppMd extends Fpparam{

    @Override
    public Boolean init(Model model, HttpServletRequest request, HttpServletResponse response, Object... objs) {
        return super.init(model, request, response, objs);
    }

    @Override
    public Boolean initSysAttachment(Model model, HttpServletRequest request, HttpServletResponse response, Object... objs) {
        ProModel proModel = (ProModel) objs[0];
        SysAttachmentService sysAttachmentService = (SysAttachmentService) objs[1];
//        ProModelMdService proModelMdService = (ProModelMdService) objs[2];

//        if((proModel == null) || (sysAttachmentService == null) || (proModelMdService == null)){
//            return true;
//        }

//        if (StringUtils.isNotBlank(proModel.getId())) {
//            ProModelMd proModelMd= proModelMdService.getByProModelId(proModel.getId());
//            model.addAttribute("proModelMd", proModelMd);
//        }
        SysAttachment sa=new SysAttachment();
//        sa.setUid(proModel.getId());
        /*sa.setFileStep(FileStepEnum.S2000);
        sa.setType(FileTypeEnum.S10);
        sa.setType(FileTypeEnum.S10);*/
        List<SysAttachment> fileListMap =  sysAttachmentService.getFiles(sa);
        model.addAttribute("sysAttachments", fileListMap);
        return super.initSysAttachment(model, request, response, objs);
    }

}
