package cc.landking.web.core.filter;

import java.io.StringWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import cc.landking.web.core.service.IUserService;
import cc.landking.web.core.utils.Encodes;
import cc.landking.web.core.utils.UserUtils;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;


public class SessionContextInterceptor implements HandlerInterceptor,ApplicationContextAware {
	private static Logger logger = LoggerFactory.getLogger(SessionContextInterceptor.class);
	private static String COOKIE_PATH="/";
	private static String CHARSET_UTF8 = "UTF-8";
	String domain;
	String sysCode;
	

	public void setSysCode(String sysCode) {
		this.sysCode = sysCode;
	}

	ObjectMapper mapper;
	TypeReference<HashMap<String,String>> typeRef ;

	ApplicationContext ctx;
	
	 @Override  
	    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {  
		 if(request.getRequestURI().startsWith(request.getContextPath()+"/static/")){
			 return true;
		 }
		 //parameter first
		 String lkc_ctx = request.getParameter("_lkc_ctx");
		 if(StringUtils.isEmpty(lkc_ctx)){
			 Cookie cookie = CookieUtils.getCookie(request, CookieUtils.COOKIE_TOKEN_KEY);
	        if(cookie != null){
	        	String value = cookie.getValue();
	        	if(value != null){
	        		 value = new String(Encodes.decodeBase64(value),CHARSET_UTF8);
	        		 logger.debug("session context value:"+value + " on "+ request.getRequestURI());
	        			HashMap<String,String> o 
	        		       = mapper.readValue(value, typeRef); 
	        			SessionContext.setContext(o);
	        	}
	        }
		 }else{
			 String value = new String(Encodes.decodeBase64(lkc_ctx),CHARSET_UTF8);
			 HashMap<String,String> o 
		       = mapper.readValue(value, typeRef); 
			SessionContext.setContext(o);
		 }
	        String oldCompanyId = UserUtils.getUserCompanyId();
		 String newCompanyId = oldCompanyId;
		 if(SessionContext.getContext() != null){
			 newCompanyId = SessionContext.getContext().get(SessionContext.USER_COMPANY_ID_KEY);
		 }
		 if(UserUtils.getCurrentUser() != null && !UserUtils.getCurrentUser().getCompanies().contains(newCompanyId)){
			 SessionContext.getContext().put(SessionContext.USER_COMPANY_ID_KEY,oldCompanyId);
			 newCompanyId = SessionContext.getContext().get(SessionContext.USER_COMPANY_ID_KEY);
		 }
	        
	        logger.debug(sysCode + "oldCompanyId:" + oldCompanyId + " new Company Id:" + newCompanyId + " on "+ request.getRequestURI());
	        if(UserUtils.getCurrentUser()!=null && newCompanyId != null && !ObjectUtils.equals(oldCompanyId, newCompanyId) ){
	        	UserUtils.getCurrentUser().setCompanyId(newCompanyId);
	        	IUserService userService = (IUserService) ctx.getBean("userService");
	        	userService.resetUserRole(UserUtils.getCurrentUser());

	        }
	        return true;//如果返回false，则不再调用之后的方法  
	    }  
	  
	    @Override  
	    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {  
			 if(request.getRequestURI().startsWith(request.getContextPath()+"/static/")){
				 return ;
			 }
	        if(modelAndView != null){  //加入当前时间  
	            modelAndView.addObject("now", new Date());  
	        }  
	        Map<String,String> map =SessionContext.getContext();
	        if(!map.isEmpty()){
		        StringWriter stringWriter = new StringWriter();
		
		        mapper.writeValue(stringWriter, map);
		        logger.debug("will write session context value:"+stringWriter + " on "+ request.getRequestURI());
		        String lkc_ctx = Encodes.encodeBase64(stringWriter.toString().getBytes(CHARSET_UTF8));
		        Cookie resCookie = new Cookie(CookieUtils.COOKIE_TOKEN_KEY,lkc_ctx);
		        if(domain != null && domain.trim().length()>0){
		        	resCookie.setDomain(domain);
		        }
		        resCookie.setPath(COOKIE_PATH);
		        resCookie.setMaxAge(-1);
		        response.addCookie(resCookie);
		        request.setAttribute("_lkc_ctx", lkc_ctx);
	        }
	    }  
	  
	    @Override  
	    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {  
	    }  
	    
	    public void init(){
			typeRef = new TypeReference<HashMap<String, String>>() {
			}; 
	    }

		@Override
		public void setApplicationContext(ApplicationContext ctx)
				throws BeansException {
			this.ctx = ctx;
		}

		public void setObjectMapper(ObjectMapper mapper) {
			this.mapper = mapper;
		}
}
