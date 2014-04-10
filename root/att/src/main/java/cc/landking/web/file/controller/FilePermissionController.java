package cc.landking.web.file.controller;

import java.util.HashMap;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import cc.landking.web.core.controller.BaseController;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.file.entity.FileBase;
import cc.landking.web.file.entity.FilePermission;
import cc.landking.web.file.service.FilePermissionService;


@Controller
@RequestMapping(value = "/file/filePermission")
public class FilePermissionController extends BaseController<FilePermission> {

	@Autowired
	private FilePermissionService filePermissionService;


	@Override
	public BaseService<FilePermission> getService() {
		return filePermissionService;
	}

	@Override
	public String getBaseViewPath() {
		return "/file/filePermission";
	}
	@RequestMapping(value = "permit",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> permit(@RequestParam(value = "id") String id) {
		FileBase obj = new FileBase();
		obj.setId(id);
		Map<String, Object> retval = new HashMap<String,Object>();
		boolean result = filePermissionService.hasPermission(obj, FilePermission.EDITOR);
		retval.put("result", result);
		retval.put("status", "success");
		return retval;
	}
	@RequestMapping(value = "perms",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> perms(@RequestParam(value = "id") String id) {
		Map<String, Object> retval = filePermissionService.findPermissionByObjectId(id);
		
		retval.put("status", "success");
		return retval;
	}

	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(
			@Valid @ModelAttribute("createDomainModel") FilePermission model,
			RedirectAttributes redirectAttributes) {
			
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:" + getBaseViewPath();
	}
	


	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(
			@Valid @ModelAttribute("preloadDomainModel") FilePermission model,
			RedirectAttributes redirectAttributes) {
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:" + getBaseViewPath();
	}

}
