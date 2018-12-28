/**
 *
 */
package com.oseasy.pgen.modules.core.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.oseasy.pgen.modules.gen.service.GenSchemeService;
import com.oseasy.pgen.modules.gen.service.GenTableService;
import com.oseasy.pgen.modules.gen.service.GenTemplateService;

/**
 * 业务表Service
 */
@Service
public class PgenService {
	@Autowired
	private GenSchemeService scheme;
	@Autowired
	private GenTableService table;
	@Autowired
	private GenTemplateService template;
    public GenSchemeService getScheme() {
        return scheme;
    }
    public GenTableService getTable() {
        return table;
    }
    public GenTemplateService getTemplate() {
        return template;
    }
}
