package servelet;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpSession;
import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.core.JsonProcessingException;

import common.GetHttpSessionConfigurator;
import service.MessageService;
import service.UsersMap;
import userDAO.UserDAO;

/**
 * Created by shanl on 14-3-2.
 */
@ServerEndpoint(value = "/WebsocketAction",configurator = GetHttpSessionConfigurator.class)
public class WebsocketAction
{
 
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm")  
    private Date sendTime;
	private Session session;
	private HttpSession httpSession;
	private long startTime;
	
	private static Logger log = Logger.getLogger(WebsocketAction.class);

	@OnOpen
	public void start(Session session, EndpointConfig config)
	{
		startTime = System.currentTimeMillis() / 1000;
		httpSession = (HttpSession) config.getUserProperties().get(HttpSession.class.getName());
		String uid = (String)httpSession.getAttribute("uid");
		if (uid == null)
		{
			String message = "{\"type\": \"0\", \"message\" :\"illegal login!\"}";
			MessageService.sendSystemMessage(message, session);
			return;
		}
		this.session = session;
		UsersMap.addOnlineUser(uid, session);
		MessageService.sendAllOnline(session);
		MessageService.sendOnline(uid);
		// System.out.println(session.getId() + " id:" + httpSession.getAttribute("uname") + " is Online!");
	}

	@OnClose
	public void end()
	{
		// httpSession = (HttpSession) config.getUserProperties().get(HttpSession.class.getName());
		offLineAction(httpSession);
		// System.out.println(session.getId() + " id:" + httpSession.getAttribute("uname") + " is Offline!");
	}

	@OnMessage
	public void incoming(String message) throws JsonProcessingException, IOException
	{
	    log.log(Level.INFO, message);
		System.out.println(message);
		// Never trust the client
		MessageService.sendMessage(message);
	}

	@OnError
	public void onError(Throwable t) throws Throwable
	{
		// httpSession = (HttpSession) config.getUserProperties().get(HttpSession.class.getName());
		log.error("Chat Error: " + t.toString());
	    System.out.println("Chat Error: " + t.toString());
		offLineAction(httpSession);
	}
	
	// 统一处理下线方法
	public void offLineAction(HttpSession httpSession)
	{
		// 更新在线时间
		UserDAO.updateOnlineTime((String)httpSession.getAttribute("uid"), (System.currentTimeMillis() / 1000 - startTime));
		httpSession.removeAttribute("uid");
		httpSession.removeAttribute("uname");
		String uid = UsersMap.getUidBySession(session);
		MessageService.sendOffline(uid);
		UsersMap.offline(uid);
	}
}