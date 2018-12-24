package com.oseasy.initiate.test;

import java.io.File;
import java.io.IOException;

import com.oseasy.putil.common.utils.Ftp;

public class FTPTest2 {

	public static void main(String[] args) {
		System.out.println("start....");
	Ftp ftp = new Ftp(1, "test", "192.168.0.105", 2121, "utf-8", "192.168.0.105");
	ftp.setUsername("ftponly");
	ftp.setPassword("os-easy");
	ftp.setPath("/");
	try {
		ftp.restore("/tool/中国.txt", new File("D://新建文本文档.txt"));
	} catch (IOException e) {
		e.printStackTrace();
	}
	}

}
