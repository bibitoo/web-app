package cc.landking.web.org.controller;

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
import cc.landking.web.org.entity.Company;
import cc.landking.web.org.entity.Group;
import cc.landking.web.org.service.GroupService;
import cc.landking.web.org.entity.Organization;
import cc.landking.web.org.service.OrganizationService;


@Controller
@RequestMapping(value = "/org/group")
public class GroupController extends BaseOrganizationController<Group> {

	@Autowired
	private HttpServletRequest context;
	
	@Autowired
	private AuthorizationService authorizationService;

	@Autowired
	private GroupService groupService;

	@Autowired
	private OrganizationService organizationService;


	@Override
	public BaseService<Group> getService() {
		return groupService;
	}

	@Override
	public String getBaseViewPath() {
		return "/org/group";
	}

	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(
			@Valid @ModelAttribute("createDomainModel") Group model,
			@RequestParam(value = "parentId", required = false) String parentId,
				@RequestParam(value = "organizationsId", required = false) String organizationsId,
			@RequestParam(value = "groupsId", required = false) String groupsId,
			RedirectAttributes redirectAttributes) {
		if(StringUtils.isNotEmpty(parentId)){
			model.setParent(getService().get(parentId));
		}
			
			if(StringUtils.isNotEmpty(organizationsId)){
				String[] organizationsIds = organizationsId.split(";");
				for(int i=0;i<organizationsIds.length;i++){
					String organizationId = organizationsIds[i];
					Organization organization = organizationService.get(organizationId);
					if(organization != null ){
						model.getOrganizations().add(organization);
					}
				}
			}

			if(StringUtils.isNotEmpty(groupsId)){
				String[] groupsIds = groupsId.split(";");
				for(int i=0;i<groupsIds.length;i++){
					String groupId = groupsIds[i];
					Group group = groupService.get(groupId);
					if(group != null ){
						model.getGroups().add(group);
					}
				}
			}

			
				String companyId = UserUtils.getUserCompanyId( );
				model.setCompanyId(companyId);
			
		getService().save(model);
			
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:"+getBaseViewPath() + "?hierarchyId="+(model.getParent()==null?"":model.getParent().getHierarchyId());
	}
	


	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(
			@Valid @ModelAttribute("preloadDomainModel") Group model,
			@RequestParam(value = "parentId", required = false) String parentId,
				@RequestParam(value = "organizationsId", required = false) String organizationsId,
			@RequestParam(value = "groupsId", required = false) String groupsId,
			RedirectAttributes redirectAttributes) {
		if(StringUtils.isNotEmpty(parentId)){
			model.setParent(getService().get(parentId));
		}else{
			model.setParent(null);
		}
			if(StringUtils.isNotEmpty(organizationsId)){
				String[] organizationsIds = organizationsId.split(";");
				for(int i=0;i<organizationsIds.length;i++){
					String organizationId = organizationsIds[i];
					Organization organization = organizationService.get(organizationId);
					if(organization != null ){
						model.getOrganizations().add(organization);
					}
				}
			}else{
				model.getOrganizations().clear();
			}

			if(StringUtils.isNotEmpty(groupsId)){
				String[] groupsIds = groupsId.split(";");
				for(int i=0;i<groupsIds.length;i++){
					String groupId = groupsIds[i];
					Group group = groupService.get(groupId);
					if(group != null ){
						model.getGroups().add(group);
					}
				}
			}else{
				model.getGroups().clear();
			}

		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:"+getBaseViewPath()  + "?hierarchyId="+(model.getParent()==null?"":model.getParent().getHierarchyId());
	}



	@RequestMapping(value = "treejson",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<Group> treejson(@RequestParam(value = "id", required = false) String id, Model model, ServletRequest request) {
		if(companySeparate && id == null){
			String companyId = UserUtils.getUserCompanyId( );
			List<Group> retval = groupService.findByParent(id,companyId);
			return retval;
		}else{
			List<Group> retval = groupService.findByParent(id);
			
			return retval;
		}
	}
	
}
