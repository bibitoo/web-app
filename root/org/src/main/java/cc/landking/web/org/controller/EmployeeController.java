package cc.landking.web.org.controller;

import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.util.List;

import javax.servlet.ServletRequest;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;

import cc.landking.web.core.entity.User;
import cc.landking.web.core.filter.SessionContext;
import cc.landking.web.core.service.AuthorizationService;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.core.service.IUserService;
import cc.landking.web.core.service.LandkingUser;
import cc.landking.web.core.utils.Encodes;
import cc.landking.web.org.entity.Department;
import cc.landking.web.org.entity.Employee;
import cc.landking.web.org.entity.Group;
import cc.landking.web.org.service.DepartmentService;
import cc.landking.web.org.service.EmployeeService;
import cc.landking.web.org.service.GroupService;
import cc.landking.web.org.service.OrganizationService;
import cc.landking.web.org.service.PostService;

@Controller
@RequestMapping(value = "/org/employee")
public class EmployeeController extends BaseOrganizationController<Employee> {

	@Autowired
	private DepartmentService departmentService;

	@Autowired
	private PostService postService;

	@Autowired
	private AuthorizationService authorizationService;

	@Autowired
	private IUserService userService;

	@Autowired
	private GroupService groupService;

	@Autowired
	private EmployeeService employeeService;

	@Autowired
	private OrganizationService organizationService;
	
	@Autowired
	private ObjectMapper objectMapper;


	@Override
	public BaseService<Employee> getService() {
		return employeeService;
	}

	@Override
	public String getBaseViewPath() {
		return "/org/employee";
	}
	@RequestMapping(value = "switchCompany", method = RequestMethod.GET)
	public String switchCompany(
			@RequestParam(value = "companyId", required = false) String companyId,
			@RequestParam(value = "r", required = false) String r,
			RedirectAttributes redirectAttributes, Model springModel) throws Exception {
		LandkingUser user = (LandkingUser) SecurityUtils.getSubject().getPrincipal();
		if(companyId != null && !companyId.equals(user.getCompanyId())){
			user.setCompanyId(companyId);
			userService.resetUserRole(user);
			SessionContext.getContext().put(SessionContext.USER_COMPANY_ID_KEY, companyId);
		}
		if(r!=null && r.trim().length()>0){
			 StringWriter stringWriter = new StringWriter();
				
			 objectMapper.writeValue(stringWriter, SessionContext.getContext());
		     String lkc_ctx = Encodes.encodeBase64(stringWriter.toString().getBytes("UTF-8"));
		     if(r.indexOf("?")>0){
		    	 r = r + "&";
		     }else{
		    	 r = r + "?";
		     }
		     r = r + "_lkc_ctx" + lkc_ctx;
		        
			springModel.addAttribute("redirect", r);
		}else{
			springModel.addAttribute("redirect", getContext().getContextPath());
		}
		return getBaseViewPath()+"/redirect" ;
	}

	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(
			@Valid @ModelAttribute("createDomainModel") Employee model,
			@RequestParam(value = "parentId", required = false) String parentId,
			@RequestParam(value = "manageDepartmentId", required = false) String manageDepartmentId,
			@RequestParam(value = "postId", required = false) String postId,
			@RequestParam(value = "userid", required = false) String userId,
			@RequestParam(value = "groupsId", required = false) String groupsId,
			RedirectAttributes redirectAttributes, Model springModel) {
		if (StringUtils.isNotEmpty(parentId)) {
			model.setParent(organizationService.get(parentId));
		}

		if (StringUtils.isNotEmpty(postId)) {
			model.setPost(postService.get(postId));
		}

		if (StringUtils.isNotEmpty(groupsId)) {
			String[] groupsIds = groupsId.split(";");
			for (int i = 0; i < groupsIds.length; i++) {
				String groupId = groupsIds[i];
				Group group = groupService.get(groupId);
				if (group != null) {
					model.getGroups().add(group);
				}
			}
		}

		if (StringUtils.isNotEmpty(manageDepartmentId)) {
			String[] manageDepartmentIds = manageDepartmentId.split(";");
			for (int i = 0; i < manageDepartmentIds.length; i++) {
				String departmentId = manageDepartmentIds[i];
				Department department = departmentService.get(departmentId);
				if (department != null) {
					// department.setLeader(model);
					model.getManageDepartment().add(department);
				}
			}
		}


		if (!isCreateUser()){
			User user = userService.getUser(userId);
			if ( user != null ) {
				Employee emp=employeeService.getByUserid(userId,model.getParent().getCompanyId());
				if (emp != null){
					if(emp.getDeleted()){
						springModel.addAttribute("message", messageSource
								.getMessage("entity.employee.user_association_deleted",
										new Object[] {emp.getName()}, null));
					}else{
				springModel.addAttribute("message", messageSource
						.getMessage("entity.employee.user_association",
								new Object[] {emp.getName()}, null));
					}
				springModel.addAttribute("action", "save");
				model.setUser(userService.getUser(userId));
				springModel.addAttribute("model", model);
				return getBaseViewPath() + "/edit";
				}
			}
			if(user != null){
				model.setUser(user);
			}
		}else{
			User oldUser = userService.findUserByLoginName(model.getUser()
					.getLoginName());
			if (oldUser != null) {
				Employee emp=employeeService.getByUserid(oldUser.getId(),model.getParent().getCompanyId());

			
				if (emp != null){
					if(emp.getDeleted()){
						springModel.addAttribute("message", messageSource
								.getMessage("entity.employee.user.loginName.exists.employee_deleted",
										new Object[] {emp.getName()}, null));
					}else{
				springModel.addAttribute("message", messageSource
						.getMessage("entity.employee.user.loginName.exists.employee",
								new Object[] {emp.getName()}, null));
					}
				}else{

				springModel.addAttribute("message", messageSource.getMessage(
						"core.user.loginName.exists", new Object[] {}, null));
				}
				springModel.addAttribute("action", "save");
				springModel.addAttribute("model", model);
				return getBaseViewPath() + "/edit";
			}else{
				model.getUser().setName(model.getName());
				
			}
		}
		employeeService.save(model);
		model.setUser(userService.getUser(userId));

		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:/org/organization?orgType=Employee&hierarchyId="
				+ (model.getParent() == null ? "" : model.getParent()
						.getHierarchyId());
	}
	private boolean isCreateUser(){
		return getContext().getParameter("createUser") != null
				&& getContext().getParameter("createUser").equals("true")
				;
	}


	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(
			@Valid @ModelAttribute("preloadDomainModel") Employee model,
			@RequestParam(value = "parentId", required = false) String parentId,
			@RequestParam(value = "manageDepartmentId", required = false) String manageDepartmentId,
			@RequestParam(value = "postId", required = false) String postId,
			@RequestParam(value = "userid", required = false) String userId,
			@RequestParam(value = "groupsId", required = false) String groupsId,
			RedirectAttributes redirectAttributes, Model springModel) {

		if (StringUtils.isNotEmpty(parentId)) {
			model.setParent(organizationService.get(parentId));
		}
		if (StringUtils.isNotEmpty(manageDepartmentId)) {
			String[] manageDepartmentIds = manageDepartmentId.split(";");
			for (int i = 0; i < manageDepartmentIds.length; i++) {
				String departmentId = manageDepartmentIds[i];
				Department department = departmentService.get(departmentId);
				if (department != null) {
					department.setLeader(model);
				}
			}
		}
		if (StringUtils.isNotEmpty(postId)) {
			model.setPost(postService.get(postId));
		}
		boolean selectUser = getContext().getParameter("createUser") != null
				&& getContext().getParameter("createUser").equals("false");

		if (StringUtils.isNotEmpty(groupsId)) {
			String[] groupsIds = groupsId.split(";");
			for (int i = 0; i < groupsIds.length; i++) {
				String groupId = groupsIds[i];
				Group group = groupService.get(groupId);
				if (group != null) {
					model.getGroups().add(group);
				}
			}
		}

			Employee old = employeeService.getByUserid(model.getUserid(),model.getParent().getCompanyId());
			if (old != null && !old.getId().equals(model.getId())) {
				springModel.addAttribute("message", messageSource.getMessage(
						"entity.employee.user_association", new Object[] {},
						null));
				springModel.addAttribute("action", "update");
				springModel.addAttribute("model", model);
				return getBaseViewPath() + "/edit";
			}
		
		employeeService.update(model, !selectUser);

		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:/org/organization?orgType=Employee&hierarchyId="
				+ (model.getParent() == null ? "" : model.getParent()
						.getHierarchyId());
	}

	@RequestMapping(value = "treejson", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<Employee> treejson(
			@RequestParam(value = "id", required = false) String id,
			Model model, ServletRequest request) {

		List<Employee> retval = employeeService.findByParent(id);

		return retval;
	}

	@ModelAttribute("createDomainModel")
	public Employee createDomainModel() {
		Employee employee = new Employee();

		return employee;
	}

	@ModelAttribute("preloadDomainModel")
	public Employee preloadDomainModel(
			@RequestParam(value = "id", required = false) String id, @RequestParam(value = "userid", required = false) String userId) {
		if (id != null) {
			Employee employee = getService().get(id);
			if(employee == null){
				employee = new Employee();
			}

				if (userId != null) {
					User user = userService.getUser(userId);
					if (user != null) {
						employee.setUser(user);
					}
				} 
		
			return employee;
		}
		return null;
	}

}
