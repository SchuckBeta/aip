/**
 * .
 */

package com.oseasy.pact.modules.actyw.tool.process;

import org.apache.log4j.Logger;

import com.oseasy.pact.modules.actyw.entity.ActYwGclazzData;

/**
 * .
 * @author chenhao
 *
 */
public class GclzzFactory {
    public final Logger logger = Logger.getLogger(this.getClass());

    public ActYwGclazzData execute(ActYwGclazzData gclazzData){
       return GclzzUtils.invokMethodParam(gclazzData);
    }
}
