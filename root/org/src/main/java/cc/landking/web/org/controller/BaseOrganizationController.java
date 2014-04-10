package cc.landking.web.org.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.data.domain.Page;
import org.springframework.http.MediaType;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import cc.landking.web.core.controller.BaseController;
import cc.landking.web.core.utils.Exceptions;
import cc.landking.web.core.utils.Servlets;
import cc.landking.web.core.utils.UserUtils;
import cc.landking.web.org.entity.Company;
import cc.landking.web.org.entity.Department;
import cc.landking.web.org.entity.Employee;
import cc.landking.web.org.entity.Organization;
import cc.landking.web.org.service.CompanyService;
import cc.landking.web.org.service.EmployeeService;
import cc.landking.web.org.service.OrganizationService;

public abstract class BaseOrganizationController<T extends Organization> extends BaseController<T> {
	

	@Value("${org.company.is_separate}")
    protected boolean companySeparate;

	@Autowired
	protected CompanyService companyService;
	
	@Autowired
	protected OrganizationService organizationService;
	
	@Autowired
	protected EmployeeService employeeService;
	
	@RequestMapping(value = "create", method = RequestMethod.GET)
	public String create( Model model) {
		Organization organization = createDomainModel();
		model.addAttribute("model", organization);
		model.addAttribute("action","save");
		String parentId = getContext().getParameter("parentId");
		if(parentId != null){
			Organization parent = organizationService.get(parentId);
			organization.setParent(parent);
		}
		if(!UserUtils.isAdmin() && organization.getParent()!=null
				&& (organization instanceof Company
				|| organization instanceof Department
				|| organization instanceof Employee)){
			Company userCompany = companyService.get(UserUtils.getUserCompanyId());
			if(organization.getParent().getHierarchyId().startsWith(userCompany.getHierarchyId())){
				if(companySeparate && !organization.getParent().getId().equals(userCompany.getId()) && organization.getParent().getOrgType().equals("Company")){
					model.addAttribute("error", messageSource
							.getMessage("error.entity.organization.separate.create", new Object[] {}, null));
					getContext().removeAttribute("com.opensymphony.sitemesh.APPLIED_ONCE");

					throw new RuntimeException(messageSource
							.getMessage("error.entity.organization.separate.create", new Object[] {}, null));
				}
			}else{
				model.addAttribute("error", messageSource
						.getMessage("error.entity.organization.create.othercompany", new Object[] {}, null));
				getContext().removeAttribute("com.opensymphony.sitemesh.APPLIED_ONCE");
				throw new RuntimeException(messageSource
						.getMessage("error.entity.organization.create.othercompany", new Object[] {}, null));
				
			}
		}
		return getBaseViewPath()+"/edit";
	}

	@RequestMapping(value = "listjson",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> listjson(@RequestParam(value = "sortType", defaultValue = "auto") String sortType,
			@RequestParam(value = "page", defaultValue = "1") int pageNumber,@RequestParam(value = "pageSize", defaultValue = PAGE_SIZE) int pageSize,
			@RequestParam(value = "sortOrder", defaultValue = "0") int sortOrder, Model model, ServletRequest request) {
		Map<String, Object> retval = new HashMap<String, Object>();
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
		if(!searchParams.containsKey("EQ_deleted")){
			searchParams.put("EQ_deleted", false);
		}
		//如果隔离公司
		if(companySeparate && !UserUtils.isAdmin()){
			if(!searchParams.containsKey("EQ_companyId") && !searchParams.containsKey("EQ_parent.id")){
				String companyId = UserUtils.getUserCompanyId( );
				if(companyId != null){
						searchParams.put("EQ_companyId", companyId);
				}
			}
		}
		Page<T> page = getService().findPage(searchParams, pageNumber, pageSize, sortType, sortOrder);
		
		retval.put("total_rows", page.getTotalElements());
		retval.put("rows", page.getContent());
		return retval;
	}
	@RequestMapping(value = "disable/{id}")
	public String disable(@PathVariable("id") String id, RedirectAttributes redirectAttributes) {
		T obj = getService().get(id);
		if(!obj.getChildren().isEmpty()){
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("common.error.referenceObjectExist", new Object[]{}, null));
			return "redirect:/org/organization";
		}
		obj.setParent(null);
		obj.setDeleted(true);
		
		getService().save(obj);
		redirectAttributes.addFlashAttribute("message", messageSource.getMessage("core.delete.success", new Object[]{}, null));
		return "redirect:/org/organization";
	}
	@RequestMapping(value = "disableAll",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> disableAll(@RequestParam("ids") String ids, RedirectAttributes redirectAttributes) {
		Map<String, Object> retval = new HashMap<String, Object>();
		String[] idsArray = ids.split(";");
		String id = null;
		for(int i=0;i< idsArray.length;i++){
			id = idsArray[i];
			if(StringUtils.isNotEmpty(id)){
				try{
					T obj = getService().get(id);
					if(!obj.getChildren().isEmpty()){
						throw new DataIntegrityViolationException("reference object exist.");
					}

					obj.setParent(null);
					obj.setDeleted(true);
					getService().save(obj);
				}catch(EmptyResultDataAccessException ex){
					ex.printStackTrace();
				}catch(DataIntegrityViolationException ex){
					retval.put("status", "error");
					retval.put("message", messageSource.getMessage("common.error.referenceObjectExist", new Object[]{}, null));
					return retval;
				}
			}
		}
		retval.put("status", "success");
		return retval;
	}

}
