/**
 * .
 */

package com.oseasy.initiate.modules.sys.vo;

/**
 * .
 * @author chenhao
 *
 */
public enum SysPropType {
    SPT_ENTER("10", "10", "创业基地-入驻配置", ""),
    SPT_DOOR("20", "20", "创业基地-预警配置", "");

  private String key;
  private String id;
  private String name;
  private String url;

  public static final String SYS_PROP_TYPES = "sysPropTypes";
  private SysPropType(String key, String id, String name, String url) {
    this.key = key;
    this.id = id;
    this.name = name;
    this.url = url;
  }

  /**
   * 根据key获取枚举 .
   *
   * @author chenhao
   * @param key 枚举标识
   * @return SysPropType
   */
  public static SysPropType getByKey(String key) {
    if ((key != null)) {
      SysPropType[] entitys = SysPropType.values();
      for (SysPropType entity : entitys) {
        if ((key).equals(entity.getKey())) {
          return entity;
        }
      }
    }
    return null;
  }
//
//    /**
//     * 获取配置Map.
//     */
//  public static Map<String, Object> getMaps(PwRenewalRuleService pwrrService) {
//    Map<String, Object> maps = Maps.newHashMap();
//    maps.put(SysPropType.SPT_ENTER.getKey(), pwrrService.get(SysPropType.SPT_ENTER.getId()));
//    return maps;
//  }

  public String getKey() {
    return key;
}

public String getName() {
    return name;
}

public String getUrl() {
    return url;
}

public String getId() {
    return id;
}

@Override
  public String toString() {
      return "{\"key\":\"" + this.key + "\",\"id\":\"" + this.id + "\",\"name\":\"" + this.name+ "\",\"url\":\"" + this.url + "\"}";
  }
}
