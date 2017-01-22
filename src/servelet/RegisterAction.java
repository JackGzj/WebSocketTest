package servelet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jsoup.Connection.Method;
import org.jsoup.Jsoup;
import org.jsoup.Connection.Response;

import pojo.Users;
import userDAO.UserDAO;

/**
 * Servlet implementation class RegisterAction
 */
@WebServlet("/RegisterAction")
public class RegisterAction extends HttpServlet
{
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public RegisterAction()
    {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        Users u = new Users();
        request.setCharacterEncoding("UTF-8");
        u.setUserid(request.getParameter("uid"));
        u.setName(request.getParameter("uname"));
        u.setUpass(request.getParameter("upass"));
        if (UserDAO.checkIfExist(request.getParameter("uid")))
        {
            request.setAttribute("error", "您输入的用户已注册，请重新输入！");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } else
        {
            if (UserDAO.insertNewUser(u))
            {
                // request.getSession().setAttribute("uid", u.getUserid());
                // request.getSession().setAttribute("uname", u.getUname());
                // UsersMap.usersName.put(u.getUserid(), u.getUname());
                sentMsgToServerChan("有新用户注册辣！", "uid : " + u.getUserid() + ", uname : " + u.getUname());
                request.setAttribute("msg", "注册成功！");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            } else
            {
                request.setAttribute("error", "注册失败，请重试！");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
        }
    }
    
    private boolean sentMsgToServerChan (String text, String desp)
    {
        try
        {
            Response rs = Jsoup.connect("http://sc.ftqq.com/SCU5023T54e0116afeb61e6c8fcc931089a3435c586f98b7842a8.send?text=" + text + "&desp=" + desp).timeout(1500).method(Method.POST).execute();
            int error = Integer.parseInt(rs.body().split(",")[0].split(":")[1]);
            // System.out.println(rs.body());
            if (error != 0)
            {
                System.out.println("Error! Errmsg : " + rs.body().split(",")[1].split(":")[1]);
                return true;
            }
            else
            {
                System.out.println("Send OK!");
                return false;
            }
        }
        catch (IOException e)
        {
            e.printStackTrace();
            return false;
        }
    }

}
