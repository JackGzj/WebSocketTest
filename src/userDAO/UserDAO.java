package userDAO;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import common.DBHelper;
import pojo.Users;

public class UserDAO
{
	private static Connection con = null;
	private static Statement st = null;
	private static ResultSet rs = null;
	private static DBHelper dbHelper = new DBHelper(); 

	public static Users check(String uid, String upass)
	{
		try
		{
			con = dbHelper.getConnection();
			String sql = String.format("select * from user where uid = '%s'" ,uid);
			// System.out.println(sql);
			st = con.createStatement(); // 获取Statement
			rs = st.executeQuery(sql);
			if (rs.next())
			{
				if (upass.equals(rs.getString(3)))
				{
					Users u = new Users();
					u.setUserid(rs.getString(1));
					u.setName(rs.getString(2));
					u.setUpass(rs.getString(3));
					return u;
				}
				else
				{
					return null;
				}
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return null;
	}
	
	// 检查注册的用户是否已经存在
	public static boolean checkIfExist(String uid)
	{
		try
		{
			con = dbHelper.getConnection();
			String sql = String.format("select * from user where uid = '%s'" ,uid);
			st = con.createStatement(); // 获取Statement
			rs = st.executeQuery(sql);
			return rs.next();   //有下一个：true，存在,返回true
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return true;
	}
	
	public static boolean insertNewUser(Users u)
	{
		try
		{
			
			con = dbHelper.getConnection();
			String sql = String.format("INSERT INTO `user` VALUES('" + u.getUserid() + "','" + u.getUname() + "','" + u.getUpass() + "',0)");
			// System.out.println(sql);
			st = con.createStatement(); // 获取Statement
			int flag = st.executeUpdate(sql);
			if (flag > 0)
			{
				return true;
			}
			return false;
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return false;
	}
	
	public static long getOnlineTime(String uid)
	{
		long onlineTime = -1;
		try
		{
			con = dbHelper.getConnection();
			String sql = String.format("select utime from user where uid = '%s'" ,uid);
			st = con.createStatement();
			rs = st.executeQuery(sql);
			if (rs.next())
			{
			    onlineTime = Long.parseLong(rs.getString(1));
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return onlineTime;
	}
	
	public static void updateOnlineTime(String uid, long tempOnlineTime)
	{
		long onlineTime = -1;
		try
		{
			con = dbHelper.getConnection();
			String sql = String.format("select utime from user where uid = '%s'" ,uid);
			st = con.createStatement();
			rs = st.executeQuery(sql);
			if (rs.next())
			{
			    onlineTime = Long.parseLong(rs.getString(1));
			}
			if (onlineTime >= 0)
			{
				onlineTime += tempOnlineTime;
				sql = String.format("UPDATE user SET utime = '%d' WHERE uid = '%s'", onlineTime, uid);
				st.executeUpdate(sql);
				// System.out.println("User:" + uid + " total online time is:" + onlineTime + ". This time online:" + tempOnlineTime);
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
}