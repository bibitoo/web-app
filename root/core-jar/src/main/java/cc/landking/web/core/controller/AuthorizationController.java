package cc.landking.web.core.controller;

import javax.servlet.ServletRequest;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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

import cc.landking.web.core.entity.Authorization;
import cc.landking.web.core.entity.Role;
import cc.landking.web.core.service.AuthorizationService;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.core.service.IUserService;
import cc.landking.web.core.service.RoleService;
import cc.landking.web.core.utils.UserUtils;


@Controller
@RequestMapping(value = "/core/authorization")
public class AuthorizationController extends BaseController<Authorization> {

	@Value(value="${core.reference.path.organizationModulePath}") 
	private String  organizationModulePath;

	@Autowired
	private RoleService roleService;

	@Autowired
	private IUserService userService;
	
	@Autowired
	private AuthorizationService authorizationService;


	@Override
	public BaseService<Authorization> getService() {
		return authorizationService;
	}

	@Override
	public String getBaseViewPath() {
		return "/core/authorization";
	}
	
	@RequestMapping(value = "authorize", method = RequestMethod.GET)
	public String authorize(Model model){
		model.addAttribute("roles",roleService.findAuthorizableRoles());
		model.addAttribute("organizationModulePath",organizationModulePath);
		return getBaseViewPath()+"/authorize";
	}
	@RequestMapping(value = "authorize/{oper}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String authorize(@PathVariable String oper,
			@Valid @ModelAttribute("createDomainModel") Authorization model,
			@RequestParam(value = "organizationId", required = false) String organizationId,
			@RequestParam(value = "creatorId", required = false) String creatorId,
			@RequestParam(value = "roleId", required = false) String roleId,
			ServletRequest request) {
			if(StringUtils.isNotEmpty(organizationId)){
				model.setOrganizationId(organizationId);
			}
			if(StringUtils.isNotEmpty(creatorId)){
				model.setCreator(userService.getUser(creatorId));
			}else{
				model.setCreator(userService.getUser(UserUtils.getCurrentUserId()));
			}
			if(StringUtils.isNotEmpty(roleId)){
				
				Role role = roleService.get(roleId);
				if(role != null ){
					authorizationService.deleteByRoleAndOrganization(role,organizationId);
					model.setRole(role);
				}
				
			}
			if(oper.equals("add")){
				getService().save(model);
			}
		return "success";
	}
	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(
			@Valid @ModelAttribute("createDomainModel") Authorization model,
			@RequestParam(value = "organizationId", required = false) String organizationId,
			@RequestParam(value = "creatorId", required = false) String creatorId,
			@RequestParam(value = "roleId", required = false) String roleId,
			RedirectAttributes redirectAttributes) {
			
			if(StringUtils.isNotEmpty(organizationId)){
				model.setOrganizationId(organizationId);
			}
			if(StringUtils.isNotEmpty(creatorId)){
				model.setCreator(userService.getUser(creatorId));
			}
			if(StringUtils.isNotEmpty(roleId)){
				model.setRole(roleService.get(roleId));
			}
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:" + getBaseViewPath();
	}
	


	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(
			@Valid @ModelAttribute("preloadDomainModel") Authorization model,
			@RequestParam(value = "organizationId", required = false) String organizationId,
			@RequestParam(value = "creatorId", required = false) String creatorId,
			@RequestParam(value = "roleId", required = false) String roleId,
			RedirectAttributes redirectAttributes) {
			if(StringUtils.isNotEmpty(organizationId)){
				model.setOrganizationId(organizationId);
			}
			if(StringUtils.isNotEmpty(creatorId)){
				model.setCreator(userService.getUser(creatorId));
			}
			if(StringUtils.isNotEmpty(roleId)){
				model.setRole(roleService.get(roleId));
			}
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:" + getBaseViewPath();
	}

}
