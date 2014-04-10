package cc.landking.web.core.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class CommonController {
	   @RequestMapping(value = "/", method = RequestMethod.GET)
	   public String index(){
		   return "index";
	   }
	   @RequestMapping(value = "/help", method = RequestMethod.GET)
	   public String help(){
		   return "help";
	   }
	   
	   @RequestMapping(value = "/401")
	   public String error401(){
		   return "error/401";
	   }
	   
	   @RequestMapping(value = "/404")
	   public String error404(){
		   return "error/404";
	   }
	   @RequestMapping(value = "/500")
	   public String error500(){
		   return "error/500";
	   }
	   @RequestMapping(value = "/error")
	   public String error(){
		   return "error/error";
	   }

}
