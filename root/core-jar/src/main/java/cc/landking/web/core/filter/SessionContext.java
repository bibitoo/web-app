package cc.landking.web.core.filter;

import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.util.Assert;

public class SessionContext {
	
	public static final String USER_COMPANY_ID_KEY = "core.companyId";
	

    private static final ThreadLocal<Map<String,String>> contextHolder = new InheritableThreadLocal<Map<String,String>>();

    //~ Methods ========================================================================================================

    public  static void clearContext() {
        contextHolder.remove();
    }

    public  static Map<String,String> getContext() {
    	Map<String,String> ctx = contextHolder.get();

        if (ctx == null) {
            ctx = createEmptyContext();
            contextHolder.set(ctx);
        }

        return ctx;
    }

    public  static void setContext(Map<String,String> context) {
        Assert.notNull(context, "Only non-null SecurityContext instances are permitted");
        contextHolder.set(context);
    }

    public  static Map<String,String> createEmptyContext() {
        return new LinkedHashMap<String,String>();
    }
}
