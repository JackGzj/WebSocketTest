package servelet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.websocket.Session;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;

import pojo.Users;
import service.MessageService;
import service.UsersMap;
import userDAO.UserDAO;

/**
 * Servlet implementation class UserAction
 */
@WebServlet("/UserAction")
public class UserAction extends HttpServlet
{
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(UserAction.class);

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UserAction()
	{
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at:
		// ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		String uid = request.getParameter("uid");
		Users u = UserDAO.check(uid, request.getParameter("upass"));
		if (u == null)
		{
			// 带登录错误信息，请求转发
			request.setAttribute("error", "登录失败!");
			request.getRequestDispatcher("/index.jsp").forward(request, response);
			return;
		}
		// 是否已在另一地点登录
		else if (UsersMap.checkIfOnline(uid))
		{
			// 强迫下线
			Session session = UsersMap.getSessionByUid(uid);
			MessageService.sendSystemMessage("{\"type\": \"0\", \"message\" :\"您的账号已在另一地点登录！\"}", session);
			// 给当前页面session
			request.getSession().setAttribute("uid", u.getUserid());
			request.getSession().setAttribute("uname", u.getUname());
			// request.setAttribute("msg", "重复登录的新用户!");
			request.setAttribute("time", UserDAO.getOnlineTime(uid));
			request.getRequestDispatcher("/chat.jsp").forward(request, response);
			String msg = "重复登录：" + uid + "session:" + session;
			log.log(Level.INFO, msg);
			System.out.println(msg);
		}
		else
		{
			request.getSession().setAttribute("uid", u.getUserid());
			request.getSession().setAttribute("uname", u.getUname());
			UsersMap.usersName.put(u.getUserid(), u.getUname());
			request.setAttribute("time", UserDAO.getOnlineTime(uid));
			request.getRequestDispatcher("/chat.jsp").forward(request, response);
			return;
		}
	}

}
