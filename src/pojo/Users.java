package pojo;

import java.io.Serializable;

public class Users implements Serializable
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String userid;
	private String uname;
	private String upass;
	
	public String getUserid()
	{
		return userid;
	}
    public void setUserid(String userid)
    {
    	this.userid = userid;
    }
    public String getUname()
    {
    	return uname;
    }
    public void setName(String uname)
	{
		this.uname = uname;
	}
    public String getUpass()
    {
    	return upass;
    }
    public void setUpass(String upass)
    {
    	this.upass = upass;
    }
}

