/**
 *
 */
package com.oseasy.pcms.modules.core.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.oseasy.pcms.modules.cmss.service.CmsSiteService;
import com.oseasy.pgen.modules.gen.service.GenSchemeService;
import com.oseasy.pgen.modules.gen.service.GenTableService;
import com.oseasy.pgen.modules.gen.service.GenTemplateService;

/**
 * 业务表Service
 */
@Service
public class PcmsService {
	@Autowired
	private CmsSiteService site;

    public CmsSiteService getSite() {
        return site;
    }
}
