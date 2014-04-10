package cc.landking.web.file.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.EmptyResultDataAccessException;
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

import cc.landking.web.core.controller.BaseController;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.core.utils.Servlets;
import cc.landking.web.core.utils.UserUtils;
import cc.landking.web.file.entity.Attachment;
import cc.landking.web.file.entity.Folder;
import cc.landking.web.file.service.AttachmentService;
import cc.landking.web.file.service.FolderService;


@Controller
@RequestMapping(value = "/file/folder")
public class FolderController extends BaseController<Folder> {

	@Autowired
	private HttpServletRequest context;

	@Autowired
	private AttachmentService attachmentService;

	@Autowired
	private FolderService folderService;


	@Override
	public BaseService<Folder> getService() {
		return folderService;
	}

	@Override
	public String getBaseViewPath() {
		return "/file/folder";
	}

		@RequestMapping(value = "update/{id}", method = RequestMethod.GET)
		public String update(@PathVariable("id") String id, Model model) {
			model.addAttribute("model", getService().get(id));
			model.addAttribute("action","update");
			return getBaseViewPath()+"/edit";
		}
		@RequestMapping(value = "create", method = RequestMethod.GET)
		public String create( Model model) {
			Folder folder = new Folder();
			String parentId = context.getParameter("parentId");
			if(StringUtils.isNotEmpty(parentId)){
				Folder parent = folderService.get(parentId);
				folder.setParent(parent);
			}
			model.addAttribute("model", folder);
			model.addAttribute("action","save");
			return getBaseViewPath()+"/edit";
		}
		
		@RequestMapping(value = "view/{id}", method = RequestMethod.GET)
		public String view(@PathVariable("id") String id, Model model) {
			model.addAttribute("model", getService().get(id));
			return getBaseViewPath()+"/view";
		}

		@RequestMapping(value = "delete/{id}")
		public String delete(@PathVariable("id") String id, RedirectAttributes redirectAttributes) {
			getService().delete(id);
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("core.delete.success", new Object[]{}, null));
			return "redirect:"+getBaseViewPath();
		}
		@RequestMapping(value = "deleteAll",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
		@ResponseBody
		public Map<String, Object> deleteAll(@RequestParam("ids") String ids, RedirectAttributes redirectAttributes) {
			Map<String, Object> retval = new HashMap<String, Object>();
			String[] idsArray = ids.split(";");
			String id = null;
			for(int i=0;i< idsArray.length;i++){
				id = idsArray[i];
				if(StringUtils.isNotEmpty(id)){
					try{
						getService().delete(id);
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
		@RequestMapping(value = "save",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
		@ResponseBody
		public Map<String, Object> save(@RequestParam(value="id", required = false) String id, @RequestParam("name") String name,
				 @RequestParam(value="parentId", required = false) String parentId,@RequestParam(value="s", required = false) String systemCode,
				 @RequestParam(value="o", required = false) String owner,RedirectAttributes redirectAttributes) {

				Folder model = new Folder();
				model.setName(name);
				if(StringUtils.isNotEmpty(parentId)){
					model.setParent(getService().get(parentId));
				}
				
				if(StringUtils.isEmpty(systemCode)){
					systemCode = Attachment.FILE_SYSTEM_CODE;
				}
	
				if(StringUtils.isNotEmpty(owner)){
					model.setOwner(owner);
				}else{
					model.setOwner(UserUtils.getCurrentUserId());
				}
				String userid = UserUtils.getCurrentUserId();
				model.setCreator(userid);
				model.setDeleted(Boolean.FALSE);
				model.setSystemCode(systemCode);
				String editors = context.getParameter("editorsId");
				String readers = context.getParameter("readersId");
				folderService.save(model,readers,editors);

			Map<String, Object> retval = new HashMap<String, Object>();
			retval.put("status", "success");
			return retval;
		}

	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(
			@Valid @ModelAttribute("createDomainModel") Folder model,
			@RequestParam(value = "parentId", required = false) String parentId,
			RedirectAttributes redirectAttributes) {
		if(StringUtils.isNotEmpty(parentId)){
			model.setParent(getService().get(parentId));
		}
		String systemCode = context.getParameter("s");
		if(StringUtils.isEmpty(systemCode)){
			systemCode = Attachment.FILE_SYSTEM_CODE;
		}

		String owner = context.getParameter("o");//UserUtils.getUserCompanyId(context);
		if(StringUtils.isNotEmpty(owner)){
			model.setOwner(owner);
		}else{
			model.setOwner(UserUtils.getCurrentUserId());
		}
		String userid = UserUtils.getCurrentUserId();
		model.setCreator(userid);
		model.setDeleted(Boolean.FALSE);
		model.setSystemCode(systemCode);
		String editors = context.getParameter("editorsId");
		String readers = context.getParameter("readersId");
		folderService.save(model,readers,editors);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		String ref = context.getParameter("ref");
		if(StringUtils.isNotEmpty(ref) && ref.equals("a")){
			 return "redirect:/file/attachment";
		}
		return "redirect:" + getBaseViewPath();
	}
	


	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(
			@Valid @ModelAttribute("preloadDomainModel") Folder model,
			@RequestParam(value = "parentId", required = false) String parentId,
			RedirectAttributes redirectAttributes) {
		if(StringUtils.isNotEmpty(parentId)){
			model.setParent(getService().get(parentId));
		}
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		String ref = context.getParameter("ref");
		if(StringUtils.isNotEmpty(ref) && ref.equals("a")){
			 return "redirect:/file/attachment";
		}

		return "redirect:" + getBaseViewPath();
	}

	@RequestMapping(value = "treejson",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<Folder> treejson(@RequestParam(value = "id", required = false) String id, Model model, ServletRequest request) {
		String systemCode = request.getParameter("s");
		if(StringUtils.isEmpty(systemCode)){
			systemCode = Attachment.FILE_SYSTEM_CODE;
		}
		String owner =  request.getParameter("o");
		if(StringUtils.isEmpty(owner)){
			owner = UserUtils.getCurrentUserId();
		}

		List<Folder> retval = folderService.findByParent(owner,systemCode,id);
		
		return retval;
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
		if(!searchParams.containsKey("EQ_owner")){
			String owner = UserUtils.getCurrentUserId();
			searchParams.put("EQ_owner", owner);
		}
		if(!searchParams.containsKey("EQ_systemCode")){
			searchParams.put("EQ_systemCode", Attachment.FILE_SYSTEM_CODE);
		}
		Page<Folder> page = getService().findPage(searchParams, pageNumber, pageSize, sortType, sortOrder);
		
		retval.put("total_rows", page.getTotalElements());
		retval.put("rows", page.getContent());
		return retval;
	}
	@RequestMapping(value = "disable/{id}")
	public String disable(@PathVariable("id") String id, RedirectAttributes redirectAttributes) {
		Folder obj = getService().get(id);
		obj.setParent(null);
		obj.setDeleted(true);
		getService().save(obj);
		redirectAttributes.addFlashAttribute("message", messageSource.getMessage("core.delete.success", new Object[]{}, null));
		return "redirect:"+getBaseViewPath();
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
					Folder obj = getService().get(id);
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
