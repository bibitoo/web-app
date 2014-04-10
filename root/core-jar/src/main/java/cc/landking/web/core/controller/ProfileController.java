package cc.landking.web.core.controller;

import javax.validation.Valid;

import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import cc.landking.web.core.entity.User;
import cc.landking.web.core.service.IUserService;
import cc.landking.web.core.utils.UserUtils;

/**
 * 用户修改自己资料的Controller.
 * 
 * @author calvin
 */
@Controller
@RequestMapping(value = "/profile")
public class ProfileController {

	@Autowired
	private IUserService accountService;

	@RequestMapping(method = RequestMethod.GET)
	public String updateForm(Model model) {
		String id = UserUtils.getCurrentUserId();
		model.addAttribute("user", accountService.getUser(id));
		return "account/profile";
	}

	@RequestMapping(method = RequestMethod.POST)
	public String update(@Valid @ModelAttribute("preloadUser") User user) {
		accountService.updateUser(user);
		UserUtils.updateCurrentUserName(user.getName());
		return "redirect:/";
	}

	@ModelAttribute("preloadUser")
	public User getUser(@RequestParam(value = "id", required = false) String id) {
		if (id != null) {
			return accountService.getUser(id);
		}
		return null;
	}


}
