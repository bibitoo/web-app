package cc.landking.web.core.entity;

public class IDGenerator {

	public static String UUID(){
		String u = java.util.UUID.randomUUID().toString();
		u = u.replaceAll("-", "");
		u = String.valueOf(System.currentTimeMillis())+u;
		return u.substring(0,36);
	}
}
