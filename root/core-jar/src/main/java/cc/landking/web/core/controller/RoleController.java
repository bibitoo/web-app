package cc.landking.web.core.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.data.domain.Page;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import cc.landking.web.core.entity.Role;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.core.service.RoleService;
import cc.landking.web.core.utils.Servlets;


@Controller
@RequestMapping(value = "/core/role")
public class RoleController extends BaseController<Role> {

	@Autowired
	private RoleService roleService;

	@Autowired
	private MessageSource messageSource;

	@Override
	public BaseService<Role> getService() {
		return roleService;
	}

	@Override
	public String getBaseViewPath() {
		return "/core/role";
	}
	@RequestMapping(value = "listjson",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> listjson(@RequestParam(value = "sortType", defaultValue = "auto") String sortType,
			@RequestParam(value = "page", defaultValue = "1") int pageNumber,@RequestParam(value = "pageSize", defaultValue = PAGE_SIZE) int pageSize,
			@RequestParam(value = "sortOrder", defaultValue = "0") int sortOrder, Model model, ServletRequest request) {
		Map<String, Object> retval = new HashMap<String, Object>();
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
		Page<Role> page = getService().findPage(searchParams, pageNumber, pageSize, sortType, sortOrder);
		List<Role> roles = page.getContent();
		for(Role role : roles){
			role.setName(messageSource.getMessage(role.getName(), null, RequestContextUtils.getLocale((HttpServletRequest) request)));
		}
		retval.put("total_rows", page.getTotalElements());
		retval.put("rows", page.getContent());
		return retval;
	}

	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(
			@Valid @ModelAttribute("createDomainModel") Role model,
			RedirectAttributes redirectAttributes) {
			
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:" + getBaseViewPath();
	}
	


	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(
			@Valid @ModelAttribute("preloadDomainModel") Role model,
			RedirectAttributes redirectAttributes) {
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:" + getBaseViewPath();
	}

}
