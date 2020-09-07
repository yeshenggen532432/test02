package com.qweib.cloud.core.exception;

/**
 * 
 * Description: DBException
 * @Author:  xushh
 * @Version: 1.0
 */

public class ServiceException extends RuntimeException
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8355126101729001211L;

	public ServiceException()
    {
         super();
    }
    
    public ServiceException(String msg)
    {
        super(msg);
    }
    
    public ServiceException(Throwable t)
    {
        super(t);
    }
    
    public ServiceException(String msg,Throwable t)
    {
        super(msg,t);
    }

}
