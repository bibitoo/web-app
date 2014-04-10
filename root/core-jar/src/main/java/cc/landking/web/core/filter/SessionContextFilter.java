package cc.landking.web.core.filter;

import java.io.IOException;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import cc.landking.web.core.service.IUserService;
import cc.landking.web.core.utils.Encodes;
import cc.landking.web.core.utils.UserUtils;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

public class SessionContextFilter implements Filter {
	private static Logger logger = LoggerFactory.getLogger(SessionContextFilter.class);


	private static String COOKIE_PATH="/";
	private static String CHARSET_UTF8 = "UTF-8";
	String domain;
	
	JsonFactory factory;
	ObjectMapper mapper;
	TypeReference<HashMap<String,String>> typeRef ;
	
	@Override
	public void destroy() {
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		
        HttpServletRequest req = (HttpServletRequest)request;
        HttpServletResponse rep = (HttpServletResponse)response;
        if(req.getRequestURI().startsWith(req.getContextPath()+"/static/")){
        	chain.doFilter(request, response);
        	return;
        }
        
//        String oldCompanyId = UserUtils.getUserCompanyId();
        Cookie cookie = CookieUtils.getCookie(req, CookieUtils.COOKIE_TOKEN_KEY);
        if(cookie != null){
        	String value = cookie.getValue();
        	if(value != null){
        		 value = new String(Encodes.decodeBase64(value),CHARSET_UTF8);
        		 logger.debug("session context value:"+value);
        			HashMap<String,String> o 
        		       = mapper.readValue(value, typeRef); 
        			SessionContext.setContext(o);
        	}
        }

        chain.doFilter(request, response);
        if(req.getRequestURI().startsWith(req.getContextPath()+"/static/")){
        	return;
        }
        Map<String,String> map =SessionContext.getContext();
        if(!map.isEmpty()){
	        StringWriter stringWriter = new StringWriter();
	
	        mapper.writeValue(stringWriter, map);
	        logger.debug("will write session context value:"+stringWriter);
	        Cookie resCookie = new Cookie(CookieUtils.COOKIE_TOKEN_KEY,Encodes.encodeBase64(stringWriter.toString().getBytes(CHARSET_UTF8)));
	        if(domain != null){
	        	resCookie.setDomain(domain);
	        }
	        resCookie.setPath(COOKIE_PATH);
	        resCookie.setMaxAge(-1);
	        rep.addCookie(resCookie);

//	        CookieUtils.setToken(req, rep, Encodes.encodeBase64(stringWriter.toString().getBytes(CHARSET_UTF8)));
        }
        Cookie resCookie = new Cookie("mytest","value");
        rep.addCookie(resCookie);
	}

	@Override
	public void init(FilterConfig config) throws ServletException {
		domain = config.getInitParameter("domain");
		factory = new JsonFactory(); 
	    mapper = new ObjectMapper(factory); 
		typeRef = new TypeReference<HashMap<String, String>>() {
		}; 

	}

}
