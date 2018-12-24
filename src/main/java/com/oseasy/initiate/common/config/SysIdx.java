package com.oseasy.initiate.common.config;

/**
 *  系统固定页面
 * @author Administrator
 *
 */
public enum SysIdx {
	SYSIDX_404(404, "404", "error/404"),
	SYSIDX_BACK_V3(13, "backV3", "modules/sys/sysIndexBackV3"),
	SYSIDX_BACK_V4(14, "backV4", "modules/sys/sysIndexBackV4");

	private Integer val;
	private String idx;
	private String idxUrl;
	private SysIdx(Integer val, String idx, String idxUrl) {
		this.val = val;
		this.idx = idx;
		this.idxUrl = idxUrl;
	}
	public String getIdx() {
		return idx;
	}
	public Integer getVal() {
		return val;
	}
	public String getIdxUrl() {
		return idxUrl;
	}
	public static SysIdx getByVal(Integer val) {
		SysIdx[] entitys = SysIdx.values();
		for (SysIdx entity : entitys) {
			if ((val).equals(entity.getVal())) {
				return entity;
			}
		}
		return null;
	}

	public static SysIdx getByIdx(String idx) {
		SysIdx[] entitys = SysIdx.values();
		for (SysIdx entity : entitys) {
			if ((entity.getIdx()).equals(idx)) {
				return entity;
			}
		}
		return null;
	}
}
