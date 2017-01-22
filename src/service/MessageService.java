package service;

import java.io.IOException;
import java.util.Map.Entry;
import java.util.Set;

import javax.websocket.Session;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;


/*
 * 后端至前端Json数据格式定义：（所有json串都应包含type属性）
 * type:
 *   0: 系统消息，前端应弹窗显示。 Json{'type': '0', 'message' :'this is a system message'}
 *   1: 用户上线通知，前端接收后添加在线用户下拉列表框选项。 Json{'type': '1', 'user' : '小瓜子(1409030206)'}
 *   2: 用户下线通知，前端接收后去除在线用户下拉列表框选项。 Json{'type': '2', 'user' : '小瓜子(1409030206)'}
 *   3: 点对点消息 。 Json{'type': '3', 'sender' : '小瓜子(或1409030206)', 'receiver' : '圆碌碌(1409030204)',
 *                     'message' : 'this is a p2p message', 'date' : 'yyyy-mm-dd-hh-mm'}
 *   4: 广播消息 。 Json{'type': '4', 'sender' : '小瓜子(或1409030206)',
 *                     'message' : 'this is a p2p message', 'date' : 'yyyy-mm-dd-hh-mm'}
 *   5: 当前所有在线用户通知。  Json{'type' : '5', 'users' : {'小瓜子(1409030206)', '圆碌碌(1409030204)'}}              
 *                     
 *  前端至后端Json数据格式定义： 
 *  type:
 *    3: 对应“点对点消息”
 *    4: 对应“广播消息”
 *    
 */
		

public class MessageService
{ 
    private static Logger log = Logger.getLogger(MessageService.class);
    
	public static void sendMessage(String message)
	{
		ObjectMapper mapper = new ObjectMapper();
		JsonNode json;
		try
		{
			json = mapper.readTree(message);
			if (json.get("type").textValue().equals("3"))
			{
				// System.out.println("P2P Message!");
				String receiverStr = json.get("receiver").textValue();
				String receiver = receiverStr.substring((receiverStr.indexOf('(') + 1), receiverStr.indexOf(')'));
				if (UsersMap.checkIfOnline(receiver))
				{
					UsersMap.getSessionByUid(receiver).getBasicRemote().sendText(message);
				}
			}
			else if (json.get("type").textValue().equals("4"))
			{
				broadcast(message, null);
			}
		}
		catch (JsonProcessingException e)
		{
			e.printStackTrace();
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}
	}
	
	public static void sendOnline(String uid)
	{
		String onlineMessage = "{\"type\":\"1\",\"user\":\"" + UsersMap.getUsersName(uid) + "\"}";
		if (!onlineMessage.contains("null"))
		{
			broadcast(onlineMessage, uid);
			String msg = "sendOnline!" + onlineMessage + "," + UsersMap.getSessionByUid(uid);
			log.log(Level.INFO, msg);
			System.out.println(msg);
		}
		
	}
	
	public static void sendOffline(String uid)
	{
		String offlineMessage = "{\"type\":\"2\",\"user\":\"" + UsersMap.getUsersName(uid) + "\"}";
		if (!offlineMessage.contains("null"))
		{
			broadcast(offlineMessage, uid);
			log.log(Level.INFO, "sendOffline!" + offlineMessage);
			System.out.println("sendOffline!" + offlineMessage);
		}
		
	}
	
	public static void sendAllOnline(Session session)
	{
		short i = 0;
		String message = "{\"type\":\"5\",\"users\":[";
		Set<Entry<String, Session>> entrySet = UsersMap.getAll();
		for (Entry<String, Session> entry : entrySet)
		{
			if (entry.getValue() == session)
			{
				continue;
			}
			if (i == 0)
			{
				message += "{\"user\":\"" + UsersMap.getUsersName(entry.getKey()) + "\"}";
			}
			else
			{
				message += ",{\"user\":\"" + UsersMap.getUsersName(entry.getKey()) + "\"}";
			}
			i++;
		}
		message += "]}";
		try
		{
			if (i > 0)
			{
				session.getBasicRemote().sendText(message);
			}
			
			String msg = "sendAll " + session.getId() + message;
			log.log(Level.INFO, msg);
			System.out.println(msg);
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}
	}
	
	public static void broadcast(String msg, String selfId)
	{
		// System.out.println("broadcast");
		Set<Entry<String, Session>> entrySet = UsersMap.getAll();
		for (Entry<String, Session> entry : entrySet)
		{
			if (entry.getKey() == selfId)
			{
				continue;
			}
			Session client = entry.getValue();
			try
			{
				synchronized (client)
				{
					client.getBasicRemote().sendText(msg);
				}
			}
			catch (IOException e)
			{
			    log.error("Chat Error: Failed to send message to client");
				System.out.println("Chat Error: Failed to send message to client");
				UsersMap.offline(entry.getKey());
				try
				{
					client.close();
				}
				catch (IOException e1)
				{
					// Ignore
				}
				String message = String.format("* %s %s", client, "has been disconnected.");
				broadcast(message, null);
			}
		}
	}
	
	public static void sendSystemMessage(String message, Session session)
	{
		try
		{
			session.getBasicRemote().sendText(message);
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}
	}
}
