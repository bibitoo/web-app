package cc.landking.web.file.controller;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import cc.landking.web.core.controller.BaseController;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.file.entity.AttFile;
import cc.landking.web.file.service.AttFileService;


@Controller
@RequestMapping(value = "/file/attFile")
public class AttFileController extends BaseController<AttFile> {

	@Autowired
	private AttFileService attFileService;


	@Override
	public BaseService<AttFile> getService() {
		return attFileService;
	}

	@Override
	public String getBaseViewPath() {
		return "/file/attFile";
	}

	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(
			@Valid @ModelAttribute("createDomainModel") AttFile model,
			RedirectAttributes redirectAttributes) {
			
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:" + getBaseViewPath();
	}
	


	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(
			@Valid @ModelAttribute("preloadDomainModel") AttFile model,
			RedirectAttributes redirectAttributes) {
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:" + getBaseViewPath();
	}

}
