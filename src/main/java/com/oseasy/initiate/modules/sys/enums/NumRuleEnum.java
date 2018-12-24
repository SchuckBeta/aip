package com.oseasy.initiate.modules.sys.enums;

public enum NumRuleEnum {
	 PROJECT("1","event_projectnum_reset","seq_project_declare_num")
	,GCONTEST("2","event_gcontestnum_reset","seq_g_contest_num")
	,TEAM("4","event_teamnum_reset","seq_team_num");

	private String value;
	private String event;
	private String seq;
	

	private NumRuleEnum(String value, String event, String seq) {
		this.value = value;
		this.event = event;
		this.seq = seq;
	}


	public String getValue() {
		return value;
	}


	public void setValue(String value) {
		this.value = value;
	}


	public String getEvent() {
		return event;
	}


	public void setEvent(String event) {
		this.event = event;
	}


	public String getSeq() {
		return seq;
	}


	public void setSeq(String seq) {
		this.seq = seq;
	}


	public static NumRuleEnum getEnumByValue(String value) {
		if (value!=null) {
			for(NumRuleEnum e:NumRuleEnum.values()) {
				if (e.value.equals(value)) {
					return e;
				}
			}
		}
		return null;
	}
	
}
