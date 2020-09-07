package com.qweib.cloud.core.exception;

/**
 * 
 * Description: DBException
 * @Author:  xushh
 * @Version: 1.0
 */

public class DaoException extends RuntimeException
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8355126101729001211L;

	public DaoException()
    {
         super();
    }
    
    public DaoException(String msg)
    {
        super(msg);
    }
    
    public DaoException(Throwable t)
    {
        super(t);
    }
    
    public DaoException(String msg,Throwable t)
    {
        super(msg,t);
    }

}
