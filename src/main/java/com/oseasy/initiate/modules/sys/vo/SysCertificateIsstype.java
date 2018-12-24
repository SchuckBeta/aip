package com.oseasy.initiate.modules.sys.vo;

public enum SysCertificateIsstype {
  SCI_NSY("1", "拟授予")
 ,SCI_QXSN("2", "取消授予")
 ,SCI_SY("3", "已授予")
 ,SCI_CX("4", "授予后撤销");

 private String key;
 private String name;

 private SysCertificateIsstype(String key, String name) {
   this.key = key;
   this.name = name;
 }

 /**
  * 根据key获取枚举 .
  *
  * @author chenhao
  * @param key 枚举标识
  * @return SysCertificateIsstype
  */
 public static SysCertificateIsstype getByKey(String key) {
   if ((key != null)) {
     SysCertificateIsstype[] entitys = SysCertificateIsstype.values();
     for (SysCertificateIsstype entity : entitys) {
       if ((entity.getKey() != null) && (key).equals(entity.getKey())) {
         return entity;
       }
     }
   }
   return null;
 }

  public String getKey() {
    return key;
  }

  public String getName() {
    return name;
  }
}
