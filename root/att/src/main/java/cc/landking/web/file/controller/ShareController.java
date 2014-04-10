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
import cc.landking.web.file.entity.Share;
import cc.landking.web.file.service.ShareService;


@Controller
@RequestMapping(value = "/file/share")
public class ShareController extends BaseController<Share> {

	@Autowired
	private ShareService shareService;


	@Override
	public BaseService<Share> getService() {
		return shareService;
	}

	@Override
	public String getBaseViewPath() {
		return "/file/share";
	}

	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(
			@Valid @ModelAttribute("createDomainModel") Share model,
			RedirectAttributes redirectAttributes) {
			
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:" + getBaseViewPath();
	}
	


	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(
			@Valid @ModelAttribute("preloadDomainModel") Share model,
			RedirectAttributes redirectAttributes) {
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:" + getBaseViewPath();
	}

}
