package com.oseasy.putil.common.ftp.exceptions;
import com.oseasy.putil.common.ftp.exceptions.FtpException;
/**
 * Created by victor on 2017/7/21.
 */
public class FtpConnectionException extends FtpException {
    public FtpConnectionException(String message) {
        super(message);
    }

    public FtpConnectionException(Throwable e) {
        super(e);
    }

    public FtpConnectionException(String message, Throwable cause) {
        super(message, cause);
    }
}
