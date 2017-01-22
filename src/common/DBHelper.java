package common;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * 数据库工具类
 * 
 * @author Jack
 *
 */
public class DBHelper
{
    private static final String Driver = "com.mysql.jdbc.Driver";
    private static final String DB = "webchat";
    private static final String USER = "gzj";
    private static final String PASSWORD = "GZJdmysql2017";
    private static final String URL = "jdbc:mysql://120.77.176.18:8888/" + DB + "?user=" + USER + "&password="
            + PASSWORD + "&useUnicode=true&characterEncoding=utf8";

    private Connection conn = null;

    public DBHelper()
    { // 进行数据库连接
        try
        {
            Class.forName(Driver); // 用反射加载数据库驱动
            this.conn = DriverManager.getConnection(URL);
        } catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    /**
     * 获取连接
     * 
     * @return 返回一个连接
     */
    public Connection getConnection()
    {
        return this.conn; // 取得数据库的连接
    }

    /**
     * 关闭连接
     * 
     * @throws Exception 发生错误
     */
    public void close() throws Exception
    { // 关闭数据库
        if (this.conn != null)
        {
            try
            {
                this.conn.close(); // 数据库关闭
            } catch (Exception e)
            {
                throw e;
            }
        }
    }
}
