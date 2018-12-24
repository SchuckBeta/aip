package com.oseasy.initiate.common.utils.poi;

public class PoiUtilTest {

  /**
   * 1.对于word,使用XWPFDocument操作07以上的doc或者docx都没有问题,并且必须是07或者以上的电脑上生成的word
   * 如果是WordExtractor或者HWPFDocument只能操作03以下的word,并且只能是03以下电脑生成的word
   *
   * @param args
   */
  public static void main(String[] args) {
      // TODO Auto-generated method stub
      String path="e:\\poi\\";
      String fileName="poi.docx";
      String filePath=path+fileName;
      //创建word
      //PoiUtil.createWord(path,fileName);
      //写入数据
      String data="两国元首在亲切友好、相互信任的气氛中，就中乌关系现状和发展前景，以及共同关心的国际和地区问题深入交换了意见，达成广泛共识。两国元首高度评价中乌关系发展成果，指出建立和发展战略伙伴关系是正确的历史选择，拓展和深化双方各领域合作具有广阔前景和巨大潜力，符合两国和两国人民的根本利益。";
      PoiUtil.writeDataDocx(filePath,data);

      //读取数据
      String contentWord = PoiUtil.readDataDocx(filePath);
      System.out.println("word的内容为:\n"+contentWord);

      //创建excel
      fileName="poi.xlsx";
      filePath=path+fileName;
      String[] unitTitle={"google","baidu","oracle","合计"};
      String[] itemTitle={"单位","总收入","盈利","亏损"};
      String[] dataExcel={"10","20","30"};
      String title="各大公司收入情况";
      PoiUtil.writeDataExcelx(filePath,dataExcel,title,unitTitle,itemTitle);

      //读取数据
      String contentExcel = PoiUtil.readDataExcelx(filePath);
      System.out.println("\nexcel的内容为:\n"+contentExcel);

      //创建ppt
      fileName="poi.pptx";
      filePath=path+fileName;
      String titlePptx="华尔街纪录片";
      String imagePath="images/hej.png";
      PoiUtil.writeDataPptx(filePath,titlePptx,imagePath);

      //读取pptx的数据
      String contentPptx = PoiUtil.readDataPptx(filePath);
      System.out.println("\nppt的内容为:\n"+contentPptx);
  }
}