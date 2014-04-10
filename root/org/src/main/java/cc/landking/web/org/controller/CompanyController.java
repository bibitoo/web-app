package cc.landking.web.org.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.ServletRequest;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import cc.landking.web.core.service.AuthorizationService;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.core.utils.Servlets;
import cc.landking.web.core.utils.UserUtils;
import cc.landking.web.core.controller.BaseController;
import cc.landking.web.core.entity.Authorization;
import cc.landking.web.org.entity.Employee;
import cc.landking.web.org.service.EmployeeService;
import cc.landking.web.org.entity.Company;
import cc.landking.web.org.service.CompanyService;
import cc.landking.web.org.entity.Department;
import cc.landking.web.org.service.DepartmentService;
import cc.landking.web.org.entity.Organization;
import cc.landking.web.org.service.OrganizationService;


@Controller
@RequestMapping(value = "/org/company")
public class CompanyController extends BaseOrganizationController<Company> {

	@Autowired
	private EmployeeService employeeService;

	@Autowired
	private AuthorizationService authorizationService;

	@Autowired
	private CompanyService companyService;

	@Autowired
	private DepartmentService departmentService;

	@Autowired
	private OrganizationService organizationService;


	@Override
	public BaseService<Company> getService() {
		return companyService;
	}

	@Override
	public String getBaseViewPath() {
		return "/org/company";
	}

	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(
			@Valid @ModelAttribute("createDomainModel") Company model,
			@RequestParam(value = "parentId", required = false) String parentId,
			@RequestParam(value = "leaderId", required = false) String leaderId,
			RedirectAttributes redirectAttributes) {
		if(StringUtils.isNotEmpty(parentId)){
			model.setParent(departmentService.get(parentId));
		}
			
			if(StringUtils.isNotEmpty(leaderId)){
				model.setLeader(employeeService.get(leaderId));
			}
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:" + "/org/organization?orgType=Company&hierarchyId="+(model.getParent()==null?"":model.getParent().getHierarchyId());
	}
	


	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(
			@Valid @ModelAttribute("preloadDomainModel") Company model,
			@RequestParam(value = "parentId", required = false) String parentId,
			@RequestParam(value = "leaderId", required = false) String leaderId,
			RedirectAttributes redirectAttributes) {
		if(StringUtils.isNotEmpty(parentId)){
			model.setParent(departmentService.get(parentId));
		}
			if(StringUtils.isNotEmpty(leaderId)){
				model.setLeader(employeeService.get(leaderId));
			}
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:" + "/org/organization?orgType=Company&hierarchyId="+(model.getParent()==null?"":model.getParent().getHierarchyId()); 
	}

	@RequestMapping(value = "treejson",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<Company> treejson(@RequestParam(value = "id", required = false) String id, Model model, ServletRequest request) {
		
		List<Company> retval = companyService.findByParent(id);
		
		return retval;
	}
	
}
