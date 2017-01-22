package service;

import java.util.HashMap;
import java.util.Map.Entry;
import java.util.Set;

import javax.websocket.Session;

public class UsersMap
{
    private static HashMap<String, Session> onlineUsers = new HashMap<String, Session>();
    public static HashMap<String, String> usersName = new HashMap<String, String>();
    
    public static boolean checkIfOnline(String uid)
    {
    	if (onlineUsers.containsKey(uid))
    	{
    		return true;
    	}
    	else
    	{
    		return false;
    	}
    }
    
    public static void addOnlineUser(String uid, Session session)
    {
    	if (uid == "null" || uid.isEmpty() || uid == null)
    		return;
    	onlineUsers.put(uid, session);
    }
    
    public static void offline(String uid)
    {
    	onlineUsers.remove(uid);
    	usersName.remove(uid);
    }
    
    public static Session getSessionByUid(String uid)
    {
    	return onlineUsers.get(uid);
    }
    
    public static String getUidBySession(Session session)
    {
    	Set<Entry<String, Session>> entrySet = onlineUsers.entrySet();
    	for (Entry<String, Session> entry : entrySet)
		{
    		if (entry.getValue().equals(session) || entry.getValue() == session)
    		{
    			return entry.getKey();
    		}
		}
    	return null;
    }
    
    public static String getUsersName(String uid)
    {
    	return usersName.get(uid) + "(" + uid + ")";
    }
    
    public static Set<Entry<String, Session>> getAll()
    {
    	return onlineUsers.entrySet();
    }
    
    public static void print()
    {
    	System.out.println(onlineUsers);
    }
    
}
