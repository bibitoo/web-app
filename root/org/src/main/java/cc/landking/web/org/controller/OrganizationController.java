package cc.landking.web.org.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
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

import cc.landking.web.core.service.AuthorizationService;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.core.utils.Collections3;
import cc.landking.web.core.utils.Servlets;
import cc.landking.web.core.utils.UserUtils;
import cc.landking.web.org.entity.Company;
import cc.landking.web.org.entity.Group;
import cc.landking.web.org.entity.Organization;
import cc.landking.web.org.service.GroupService;
import cc.landking.web.org.service.OrganizationService;

import com.fasterxml.jackson.databind.util.JSONPObject;

@Controller
@RequestMapping(value = "/org/organization")
public class OrganizationController extends
		BaseOrganizationController<Organization> {

	@Autowired
	private AuthorizationService authorizationService;

	@Autowired
	private GroupService groupService;

	@Autowired
	private OrganizationService organizationService;

	@Override
	public BaseService<Organization> getService() {
		return organizationService;
	}

	@Override
	public String getBaseViewPath() {
		return "/org/organization";
	}

	@RequestMapping(value = "enable/{id}/{pid}")
	public String enable(@PathVariable("id") String id,
			@PathVariable("pid") String pid,
			RedirectAttributes redirectAttributes) {
		Organization parent = organizationService.get(pid);
		Organization org = organizationService.get(id);
		if (!org.getOrgType().equals("Company") && parent == null) {
			redirectAttributes.addFlashAttribute("message", messageSource
					.getMessage("entity.department.mustBelongToCompany",
							new Object[] {}, null));
			return "redirect:/org/organization/view/" + id;
		}

		org.setParent(parent);
		org.setDeleted(Boolean.FALSE);
		organizationService.save(org);

		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("entity.organization.enable.success",
						new Object[] {}, null));
		return "redirect:/org/organization/listdeleted";
	}

	@RequestMapping(value = "enableAll", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> enableAll(
			@RequestParam(value = "ids", required = false) String idstr,
			@RequestParam(value = "pid", required = false) String pid,
			RedirectAttributes redirectAttributes, Model springModel) {
		Map<String, Object> retval = new HashMap<String, Object>();
		Organization parent = organizationService.get(pid);
		String[] ids = idstr.split(";");
		for (int i = 0; i < ids.length; i++) {
			String id = ids[i];
			Organization org = organizationService.get(id);
			if (org == null) {
				continue;
			}
			if (!org.getOrgType().equals("Company") && parent == null) {
				retval.put("status", "error");
				retval.put("message", messageSource.getMessage(
						"entity.department.mustBelongToCompany",
						new Object[] {}, null));
				return retval;

			} else {
				org.setParent(parent);
				org.setDeleted(Boolean.FALSE);
				organizationService.save(org);
			}
		}
		retval.put("status", "success");
		return retval;
	}

	@RequestMapping(value = "listdeleted", method = RequestMethod.GET)
	public String listdeleted() {
		return getBaseViewPath() + "/listdeleted";
	}

	@RequestMapping(value = "listdeletedjson", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> listdeletedjson(
			@RequestParam(value = "sortType", defaultValue = "auto") String sortType,
			@RequestParam(value = "page", defaultValue = "1") int pageNumber,
			@RequestParam(value = "pageSize", defaultValue = PAGE_SIZE) int pageSize,
			@RequestParam(value = "sortOrder", defaultValue = "0") int sortOrder,
			Model model, ServletRequest request) {
		Map<String, Object> retval = new HashMap<String, Object>();
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(
				request, "search_");
		if (!searchParams.containsKey("EQ_deleted")) {
			searchParams.put("EQ_deleted", true);
		}
		// 如果隔离公司
		if (companySeparate) {
			if (!searchParams.containsKey("EQ_companyId")
					&& !searchParams.containsKey("EQ_parent.id")) {
				String companyId = UserUtils.getUserCompanyId();
				if (companyId != null) {
					searchParams.put("EQ_companyId", companyId);
				}
			}
		}
		Page<Organization> page = getService().findPage(searchParams,
				pageNumber, pageSize, sortType, sortOrder);

		retval.put("total_rows", page.getTotalElements());
		retval.put("rows", page.getContent());
		return retval;
	}

	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(
			@Valid @ModelAttribute("createDomainModel") Organization model,
			@RequestParam(value = "parentId", required = false) String parentId,
			@RequestParam(value = "groupsId", required = false) String groupsId,
			RedirectAttributes redirectAttributes) {
		if (StringUtils.isNotEmpty(parentId)) {
			model.setParent(getService().get(parentId));
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

		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:" + getBaseViewPath();
	}

	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(
			@Valid @ModelAttribute("preloadDomainModel") Organization model,
			@RequestParam(value = "parentId", required = false) String parentId,
			@RequestParam(value = "groupsId", required = false) String groupsId,
			RedirectAttributes redirectAttributes) {
		if (StringUtils.isNotEmpty(parentId)) {
			model.setParent(getService().get(parentId));
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

		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:" + getBaseViewPath();
	}

	@RequestMapping(value = "treejson", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<Organization> treejson(
			@RequestParam(value = "id", required = false) String id,
			Model model, ServletRequest request) {

		if (!companySeparate || request.getParameter("all") != null
				|| UserUtils.isAdmin()) {
			return organizationService.findByParent(id);
		}
		if (companySeparate) {
			String userCompanyId = UserUtils.getUserCompanyId();
			Organization dept = null;
			if (id == null || id.trim().length() == 0) {
				if (userCompanyId != null) {
					dept = (Company) organizationService
							.getOriginalOrganization(userCompanyId);
					return Collections3.createList(dept);
				}
			}

			if (id != null) {

				dept = organizationService.getOriginalOrganization(id);
			}

			if (dept == null
					|| (dept.getOrgType().equals("Company") && !id
							.equals(userCompanyId))) {

				return Collections.EMPTY_LIST;
			}
		}
		List<Organization> retval = organizationService.findByParent(id);

		return retval;
	}

	@RequestMapping(value = "treejsonp", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public JSONPObject treejsonp(
			@RequestParam(value = "id", required = false) String id,
			Model model, ServletRequest request) {
		String callback = request.getParameter("callback");
		if (StringUtils.isEmpty(callback)) {
			callback = "callback";
		}
		return new JSONPObject(callback, treejson(id, model, request));
	}
	@RequestMapping(value = "listjsonp",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public JSONPObject listjsonp(@RequestParam(value = "sortType", defaultValue = "auto") String sortType,
			@RequestParam(value = "page", defaultValue = "1") int pageNumber,@RequestParam(value = "pageSize", defaultValue = PAGE_SIZE) int pageSize,
			@RequestParam(value = "sortOrder", defaultValue = "0") int sortOrder, Model model, ServletRequest request) {
		String callback = request.getParameter("callback");
		if (StringUtils.isEmpty(callback)) {
			callback = "callback";
		}
		return new JSONPObject(callback, listjson(sortType, pageNumber, pageSize, sortOrder, model, request));
		
	}
}
