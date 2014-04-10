package cc.landking.web.file.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.data.domain.Page;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
import cc.landking.web.file.entity.FileBase;
import cc.landking.web.file.entity.FilePermission;
import cc.landking.web.file.service.AttachmentService;
import cc.landking.web.file.service.FileBaseService;
import cc.landking.web.file.service.FilePermissionService;
import cc.landking.web.file.service.FolderService;


@Controller
@RequestMapping(value = "/file/fileBase")
public class FileBaseController extends BaseController<FileBase> {

    @Value("${file.upload.directory}")
    private String fileUploadDirectory;
    
    
    @Autowired
    private FileBaseService fileBaseService;

	@Autowired
	private FolderService folderService;

	@Autowired
	private AttachmentService attachmentService;

	@Autowired
	private FilePermissionService filePermissionService;
	
	@Override
	public BaseService<FileBase> getService() {
		return fileBaseService;
	}

	@Override
	public String getBaseViewPath() {
		return "/file/fileBase";
	}
	@RequestMapping(value = "clear",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> clear(@RequestParam( value = "o", required = false) String owner){
		Map<String, Object> retval = new HashMap<String, Object>();
		String o = owner;
		if(StringUtils.isEmpty(o)){
			o =  UserUtils.getCurrentUserId();
		}
		try{
			fileBaseService.deleteByOwner(o);
			retval.put("status", "success");
		}catch(Exception ex){
			ex.printStackTrace();
			if(StringUtils.containsIgnoreCase(ex.getMessage(), "foreign key")
					|| StringUtils.containsIgnoreCase(ex.getMessage(), "ConstraintViolationException")){
				retval.put("message", messageSource.getMessage("common.error.referenceObjectExist", new Object[]{}, null));
			}else{
				retval.put("message", ex.getMessage());
			}
			retval.put("status", "error");
			
		}
		
		return retval;
	}
	@RequestMapping(value = "move",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> move(@RequestParam("id") String id, @RequestParam("toid") String toid){
		Map<String, Object> retval = new HashMap<String, Object>();
		FileBase fromfb = fileBaseService.get(id);
		if(StringUtils.isEmpty(toid)){
			if(!fromfb.getOwner().equals(UserUtils.getCurrentUserId())){
				boolean isPerm = filePermissionService.hasPermission(fromfb, FilePermission.EDITOR);
				if(!isPerm){
					retval.put("status", "error");
					retval.put("message", messageSource.getMessage("common.error.401", null, getContext().getLocale()));
					return retval;				
				}
			}
		}else{
			FileBase fb = fileBaseService.get(toid);
			if(!fb.getOwner().equals(UserUtils.getCurrentUserId())){
				boolean isPerm = filePermissionService.hasPermission(fb, FilePermission.EDITOR);
				if(!isPerm){
					retval.put("status", "error");
					retval.put("message", messageSource.getMessage("common.error.401", null, getContext().getLocale()));
					return retval;				
				}
			}
			fb = fileBaseService.get(id);
			if(!fb.getOwner().equals(UserUtils.getCurrentUserId())){
				boolean isPerm = filePermissionService.hasPermission(fb, FilePermission.EDITOR);
				if(!isPerm){
					retval.put("status", "error");
					retval.put("message", messageSource.getMessage("common.error.401", null, getContext().getLocale()));
					return retval;				
				}
			}
		}
		fileBaseService.move(id, toid);
		retval.put("status", "success");
		return retval;
	}
	@RequestMapping(value = "rename",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> rename(@RequestParam("id") String id, @RequestParam("name") String name
			, @RequestParam(value="editorsId" ,required=false) String editorsId
			, @RequestParam(value="readersId",required=false) String readersId){
		Map<String, Object> retval = new HashMap<String, Object>();
		FileBase obj = getService().get(id);
		if(!obj.getOwner().equals(UserUtils.getCurrentUserId())){
			boolean isPerm = filePermissionService.hasPermission(obj, FilePermission.EDITOR);
			if(!isPerm){
				retval.put("status", "error");
				retval.put("message", messageSource.getMessage("common.error.401", null, getContext().getLocale()));
				return retval;				
			}
		}

			obj.setName(name);
			fileBaseService.update(obj, readersId, editorsId);
			retval.put("status", "success");
			return retval;

	}
	@RequestMapping(value = "listjson",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> listjson(@RequestParam(value = "sortType", defaultValue = "auto") String sortType,
			@RequestParam(value = "page", defaultValue = "1") int pageNumber,@RequestParam(value = "pageSize", defaultValue = PAGE_SIZE) int pageSize,
			@RequestParam(value = "sortOrder", defaultValue = "0") int sortOrder, Model model, ServletRequest request) {
		Map<String, Object> retval = new HashMap<String, Object>();
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
		if(sortType == null || sortType.equals("auto")){
			sortType="lastModifyTime";
			sortOrder = 1;
		}
		if(!searchParams.containsKey("EQ_owner") || searchParams.get("EQ_owner").toString().trim().length()==0){
			String owner = UserUtils.getCurrentUserId();
			searchParams.put("EQ_owner", owner);
		}
		if(!searchParams.containsKey("EQ_systemCode") || searchParams.get("EQ_systemCode").toString().trim().length()==0){
			searchParams.put("EQ_systemCode", "file");
		}
		if(!searchParams.containsKey("EQ_parent.id")){
			searchParams.put("ISNULL_parent", "null");
		}

		Page<FileBase> page = fileBaseService.findPage(searchParams, pageNumber, pageSize, sortType, sortOrder);
		
		retval.put("total_rows", page.getTotalElements());
		retval.put("rows", page.getContent());
		return retval;
	}


    @RequestMapping(value = "jsonDelete/{id}", method = RequestMethod.DELETE)
    public @ResponseBody List delete(@PathVariable String id) {
        Map<String, Object> success = new HashMap();
        
        List<Map<String, Object>> results = new ArrayList();
		FileBase fb = fileBaseService.get(id);
		if(fb != null){
			boolean permit = filePermissionService.hasPermission(fb, FilePermission.EDITOR);
			if(permit){
		    	attachmentService.delete(id);
		        success.put("success", true);
			}else{
		        success.put("success", false);
			}
		}
        results.add(success);
        return results;
    }


	@RequestMapping(value = "disable/{id}")
	public String disable(@PathVariable("id") String id, RedirectAttributes redirectAttributes) {
		FileBase fb = fileBaseService.get(id);
		if(fb != null){
			boolean permit = filePermissionService.hasPermission(fb, FilePermission.EDITOR);
			if(permit){
				fileBaseService.disable(id);
			}else{
				redirectAttributes.addFlashAttribute("message", messageSource.getMessage("common.error.401", new Object[]{}, null));
				return "redirect:"+getBaseViewPath();
			}
		}
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
					FileBase fb = fileBaseService.get(id);
					if(fb != null){
						boolean permit = filePermissionService.hasPermission(fb, FilePermission.EDITOR);
						if(permit){
							fileBaseService.disable(id);
						}else{
							retval.put("status", "error");
							retval.put("message", messageSource.getMessage("common.error.401", new Object[]{}, null));
							return retval;
						}
					}
					
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
