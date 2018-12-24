package com.oseasy.putil.common.ftp.commands;

import java.io.InputStream;
import java.util.List;

import com.oseasy.putil.common.ftp.vo.FileVo;
import com.oseasy.putil.common.ftp.vo.VsFile;

/**
 * Created by victor on 2017/7/24.
 */
public interface VsFtpCommads {
    boolean uploadFile( String remotePath, String filename, InputStream input);

    boolean downFile( String remotePath, String fileName, String localPath);

    FileVo downFiles(List<VsFile> vsfiles);

    boolean removeFile( String remotePath, String fileName);
}
