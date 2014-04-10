package cc.landking.web.core.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.data.domain.Page;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Maps;

import cc.landking.web.core.entity.Role;
import cc.landking.web.core.entity.User;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.core.service.IUserService;
import cc.landking.web.core.service.UserService;
import cc.landking.web.core.service.ShiroRoleService;
import cc.landking.web.core.utils.Servlets;

/**
 * 管理员管理用户的Controller.
 * 
 * @author calvin
 */
@Controller
@RequestMapping(value = "/core/user")
public class UserController extends BaseController<User>{


	   @Autowired
	    private MessageSource messageSource;

	@Autowired
	private IUserService userService;
	
	@Autowired
	private ShiroRoleService shiroRoleService;


	@Override
	@RequestMapping(value = "update/{id}", method = RequestMethod.GET)
	public String update(@PathVariable("id") String id, Model model) {
		model.addAttribute("user", userService.getUser(id));
		model.addAttribute("rolesList",shiroRoleService.findRoles());
		model.addAttribute("action","update");
		return getBaseViewPath()+"/edit";
	}
	@RequestMapping(value = "forbid/{id}/{forbid}", method = RequestMethod.GET)
	public String forbidUser(@PathVariable("id") String id, @PathVariable("forbid") boolean forbid, 
			@RequestParam(value = "ref", defaultValue = "") String ref,
			Model model,  RedirectAttributes redirectAttributes) {
		
		User user = userService.getUser(id);
		user.setForbidden(forbid);
		userService.updateUser(user);
		if(forbid){
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("core.forbid.user.success", new Object[]{user.getName()}, null));
		}else{
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("core.enable.user.success", new Object[]{user.getName()}, null));			
		}
		return "redirect:"+ref;

	}

	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(@Valid @ModelAttribute("preloadUser") User user, RedirectAttributes redirectAttributes) {
		userService.updateUser(user);
		redirectAttributes.addFlashAttribute("message", messageSource.getMessage("core.update.user.success", new Object[]{user.getLoginName()}, null));
		return "redirect:/core/user/list";
	}
	
	@Override
	@RequestMapping(value = "create", method = RequestMethod.GET)
	public String create( Model model) {
		model.addAttribute("model", createDomainModel());
		model.addAttribute("rolesList",shiroRoleService.findRoles());
		model.addAttribute("action","save");
		return getBaseViewPath()+"/edit";
	}

	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(@Valid @ModelAttribute("createDomainModel") User model, RedirectAttributes redirectAttributes) {
		if(StringUtils.isEmpty(model.getRoles())){
			model.setRoles(Role.USER_ROLE);
		}
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource.getMessage("core.update.success", new Object[]{}, null));
		return "redirect:"+getBaseViewPath()+"/list";
	}

	@RequestMapping(value = "delete/{id}")
	public String delete(@PathVariable("id") String id, RedirectAttributes redirectAttributes) {
		User user = userService.getUser(id);
		userService.deleteUser(id);
		redirectAttributes.addFlashAttribute("message", messageSource.getMessage("core.delete.user.success", new Object[]{user.getLoginName()}, null));
		return "redirect:/core/user/list";
	}

	/**
	 * 使用@ModelAttribute, 实现Struts2 Preparable二次部分绑定的效果,先根据form的id从数据库查出User对象,再把Form提交的内容绑定到该对象上。
	 * 因为仅update()方法的form中有id属性，因此本方法在该方法中执行.
	 */
	@ModelAttribute("preloadUser")
	public User getUser(@RequestParam(value = "id", required = false) String id) {
		if (id != null) {
			return userService.getUser(id);
		}
		return null;
	}

	@Override
	public BaseService<User> getService() {
		return (BaseService<User>) userService;
	}

	@Override
	public String getBaseViewPath() {
		return "/core/user";
	}
}
