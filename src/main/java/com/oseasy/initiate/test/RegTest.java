package com.oseasy.initiate.test;

import java.util.HashSet;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RegTest {

	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}
	public static Set<String> getImgSet(String content) {
		Set<String> set=new HashSet<String>();
        String regxpForTag = "<\\s*img\\s+([^>]*)\\s*" ;  
        String regxpForTagAttrib = "src=\\s*\"([^\"]+)\"" ;  
        Pattern patternForTag = Pattern.compile (regxpForTag,Pattern. CASE_INSENSITIVE );  
        Pattern patternForAttrib = Pattern.compile (regxpForTagAttrib,Pattern. CASE_INSENSITIVE );     
        Matcher matcherForTag = patternForTag.matcher(content);  
        boolean result = matcherForTag.find();  
        while (result) {  
            Matcher matcherForAttrib = patternForAttrib.matcher(matcherForTag.group(1));  
            if (matcherForAttrib.find()) {  
            	set.add(matcherForAttrib.group(1));  
            }  
            result = matcherForTag.find();  
        }
        return set;
	}
}
