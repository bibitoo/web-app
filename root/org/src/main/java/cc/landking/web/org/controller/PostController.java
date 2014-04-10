package cc.landking.web.org.controller;

import java.util.List;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.ServletRequest;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
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
import cc.landking.web.core.utils.UserUtils;
import cc.landking.web.core.controller.BaseController;
import cc.landking.web.core.entity.Authorization;
import cc.landking.web.org.entity.Employee;
import cc.landking.web.org.entity.Group;
import cc.landking.web.org.service.EmployeeService;
import cc.landking.web.org.entity.Post;
import cc.landking.web.org.service.PostService;
import cc.landking.web.org.entity.Organization;
import cc.landking.web.org.service.OrganizationService;


@Controller
@RequestMapping(value = "/org/post")
public class PostController extends BaseOrganizationController<Post> {
	@Autowired
	private HttpServletRequest context;
	

	@Autowired
	private EmployeeService employeeService;

	@Autowired
	private AuthorizationService authorizationService;

	@Autowired
	private PostService postService;

	@Autowired
	private OrganizationService organizationService;


	@Override
	public BaseService<Post> getService() {
		return postService;
	}

	@Override
	public String getBaseViewPath() {
		return "/org/post";
	}

	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(
			@Valid @ModelAttribute("createDomainModel") Post model,
			@RequestParam(value = "parentId", required = false) String parentId,
			RedirectAttributes redirectAttributes) {
		if(StringUtils.isNotEmpty(parentId)){
			model.setParent(getService().get(parentId));
		}
		String companyId = UserUtils.getUserCompanyId( );
		model.setCompanyId(companyId);
			
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:"+getBaseViewPath()  + "?hierarchyId="+(model.getParent()==null?"":model.getParent().getHierarchyId());
	}
	


	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(
			@Valid @ModelAttribute("preloadDomainModel") Post model,
			@RequestParam(value = "parentId", required = false) String parentId,
			RedirectAttributes redirectAttributes) {
		if(StringUtils.isNotEmpty(parentId)){
			model.setParent(getService().get(parentId));
		}else{
			model.setParent(null);
		}
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:"+getBaseViewPath()  + "?hierarchyId="+(model.getParent()==null?"":model.getParent().getHierarchyId());
	}

	@RequestMapping(value = "treejson",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<Post> treejson(@RequestParam(value = "id", required = false) String id, Model model, ServletRequest request) {
		if(companySeparate && id == null){
			String companyId = UserUtils.getUserCompanyId( );
			List<Post> retval = postService.findByParent(id,companyId);
			return retval;
		}else{
		List<Post> retval = postService.findByParent(id);
		
		return retval;
		}
	}
	
}
