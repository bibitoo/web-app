package cc.landking.web.file.controller;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.security.AccessControlException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.io.FileBackedOutputStream;
import com.mysql.jdbc.Messages;

import cc.landking.web.core.controller.BaseController;
import cc.landking.web.core.entity.AbstractIdEntity;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.core.utils.Servlets;
import cc.landking.web.core.utils.UserUtils;
import cc.landking.web.file.entity.Attachment;
import cc.landking.web.file.entity.FileBase;
import cc.landking.web.file.entity.FilePermission;
import cc.landking.web.file.entity.Folder;
import cc.landking.web.file.service.AttFileService;
import cc.landking.web.file.service.AttachmentService;
import cc.landking.web.file.service.FileBaseService;
import cc.landking.web.file.service.FilePermissionService;
import cc.landking.web.file.service.FolderService;


@Controller
@RequestMapping(value = "/file/attachment")
public class AttachmentController extends BaseController<Attachment> {
	/**
	 * Logger for this class
	 */
	private static final Log logger = LogFactory
			.getLog(AttachmentController.class);

    @Autowired
    private FileBaseService fileBaseService;
  
    
    @Autowired
    private AttFileService attFileService;

	@Autowired
	private FolderService folderService;

	@Autowired
	private AttachmentService attachmentService;

	@Autowired
	FilePermissionService filePermissionService;
	
	@Override
	public BaseService<Attachment> getService() {
		return attachmentService;
	}

	@Override
	public String getBaseViewPath() {
		return "/file/attachment";
	}
	@RequestMapping(value = "listjson/{sys}/{oid}/{key}",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> listjson( @PathVariable String sys, @PathVariable String oid,@PathVariable String key,
			@RequestParam(value = "sortType", defaultValue = "auto") String sortType,
			@RequestParam(value = "page", defaultValue = "1") int pageNumber,@RequestParam(value = "pageSize", defaultValue = PAGE_SIZE) int pageSize,
			@RequestParam(value = "sortOrder", defaultValue = "0") int sortOrder, Model model, ServletRequest request) {
		Map<String, Object> retval = new HashMap<String, Object>();
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
		if(sortType == null || sortType.equals("auto")){
			sortType="lastModifyTime";
			sortOrder = 1;
		}
        searchParams.put("EQ_systemCode", sys);
        searchParams.put("EQ_objectId", oid);
        searchParams.put("EQ_key", key);


		Page<Attachment> page = getService().findPage(searchParams, pageNumber, pageSize, sortType, sortOrder);
		
		retval.put("total_rows", page.getTotalElements());
		retval.put("rows", page.getContent());
		return retval;
	}
	 int length = 0x8FFFFFF; 
    @RequestMapping(value = "download/{id}", method = RequestMethod.GET)
    public void download(@PathVariable String id, HttpServletRequest request,
            HttpServletResponse response) throws Exception {
    	
    	if(StringUtils.isNotEmpty(id)){
    		boolean singleFile = false;
    		String fileName = null;
    		String[] theids = id.split(AbstractIdEntity.LIST_SPLITER);
    		if(theids.length > 0){
    			FileBase fbs = fileBaseService.get(theids[0]);
    			if(fbs != null ){
					fileName = fbs.getName();

    				if(fbs.getFileBaseType().equals("Attachment") && theids.length == 1){
    					singleFile = true;
    				}
    			}
    		}
    		if(!singleFile){
				
    		}
    		if(!singleFile){
    			long start = System.currentTimeMillis();

    			if(theids.length > 1){
					fileName = FilenameUtils.getBaseName(fileName) + messageSource.getMessage("file.form.filename", new String[]{String.valueOf(theids.length)},getContext().getLocale());
				}
    			fileName = fileName + ".zip";
    			response.setContentType("application/x-zip-compressed"); 
    			response.setHeader("Content-disposition", "attachment; filename="
    			          + new String(fileName.getBytes("gb2312"), "ISO8859-1")); 
    			 String owner = request.getParameter("o");
//    			 FileBackedOutputStream fbos = new FileBackedOutputStream(4096);
    			 File file = File.createTempFile("download", "tmp");
    			 FileOutputStream fbos = new FileOutputStream(file);
    			 
    		        if(!UserUtils.hasRole("fileadmin") && (StringUtils.isEmpty(owner) || !owner.equals(UserUtils.getCurrentUserId()))){
    		        	 fileBaseService.zipFile(fbos, theids,true);
    		        }else{
    		        	  fileBaseService.zipFile(fbos, theids,false);
    		        }
    				if (logger.isInfoEnabled()) {
    					logger.info("download(String, HttpServletRequest, HttpServletResponse) zip file times(ns):"+(System.currentTimeMillis()-start));
    				}

    		        response.setHeader("Content-Length", String.valueOf(new FileInputStream(file).getChannel().size())); 
    		        IOUtils.copyLarge(new FileInputStream(file), response.getOutputStream());
    				if (logger.isInfoEnabled()) {
    					logger.info("download(String, HttpServletRequest, HttpServletResponse) zip file and downloaded times(ns):"+(System.currentTimeMillis()-start));
    				}

    		}else{
	    		Attachment attachment = attachmentService.get(id);
	    		if(attachment != null && attachment.getAttFileId() != null){
	    			response.setContentType(attachment.getType()); 
	    			response.setHeader("Content-disposition", "attachment; filename="
	    			          + new String(attachment.getName().getBytes("gb2312"), "ISO8859-1")); 
	    			  response.setHeader("Content-Length", String.valueOf(attachment.getSize())); 
	    			  attFileService.write(response.getOutputStream(), attachment.getAttFileId());
	    		}
    		}
    	}
    }

    @RequestMapping(value = "jsonDelete/{id}", method = RequestMethod.DELETE)
    public @ResponseBody List delete(@PathVariable String id) {
    	attachmentService.delete(id);
        
        List<Map<String, Object>> results = new ArrayList();
        Map<String, Object> success = new HashMap();
        success.put("success", true);
        results.add(success);
        return results;
    }
    @RequestMapping(value = "upload/{sys}/{oid}/{key}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public @ResponseBody Map uplist( @PathVariable String sys, @PathVariable String oid,@PathVariable String key,  ServletRequest request) {
    	HttpServletRequest req = (HttpServletRequest)request;
    	String contextpath = req.getContextPath();
    	Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
        List<Map> list = new ArrayList<Map>();
        searchParams.put("EQ_systemCode", sys);
        searchParams.put("EQ_objectId", oid);
        searchParams.put("EQ_key", key);
        Page<Attachment> attachments = attachmentService.findPage(searchParams, 0, 3000, "name", 0);
        for(Attachment attachment : attachments.getContent()) {
        	Map map = new HashMap();
            map.put("title", attachment.getTitle());
            map.put("name", attachment.getName());
            map.put("remark", attachment.getRemark());
            map.put("size", attachment.getSize());
            map.put("url", contextpath+"/file/attachment/download/"+attachment.getId());
            map.put("deleteUrl", contextpath+"/file/attachment/jsonDelete/"+attachment.getId());
            map.put("deleteType", "DELETE");
            list.add(map);
        }
        Map<String, Object> files = new HashMap();
        files.put("files", list);
        return files;
    }
    @RequestMapping(value = "upload", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public @ResponseBody Map list( ServletRequest request) {
    	HttpServletRequest req = (HttpServletRequest)request;
    	String contextpath = req.getContextPath();
    	Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
        List<Map> list = new ArrayList<Map>();
        Page<Attachment> attachments = attachmentService.findPage(searchParams, 0, 3000, "name", 0);
        for(Attachment attachment : attachments.getContent()) {
        	Map map = new HashMap();
            map.put("name", attachment.getName());
            map.put("size", attachment.getSize());
            map.put("url", contextpath+"/file/attachment/download/"+attachment.getId());
            map.put("deleteUrl", contextpath+"/file/attachment/jsonDelete/"+attachment.getId());
            map.put("deleteType", "DELETE");
            list.add(map);
        }
        Map<String, Object> files = new HashMap();
        files.put("files", list);
        return files;
    }
    @RequestMapping(value = "updateTitle/{id}/{title}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public @ResponseBody Map updateTitle( @PathVariable String id, @PathVariable String title, ServletRequest request) {
    	Attachment att = attachmentService.get(id);
    	if(title.equals("null")){
    		att.setTitle(null);
    	}else{
    		att.setTitle(title);
    	}
    	attachmentService.save(att);
    	 Map<String, Object> success = new HashMap();
         success.put("success", true);
         return success;
    }   
    @RequestMapping(value = "updateRemark/{id}/{mark}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public @ResponseBody Map updateRemark( @PathVariable String id, @PathVariable String mark, ServletRequest request) {
    	Attachment att = attachmentService.get(id);
    	if(mark.equals("null")){
    		att.setTitle(null);
    	}else{
    		att.setRemark(mark);
    	}
    	
    	attachmentService.save(att);
    	 Map<String, Object> success = new HashMap();
         success.put("success", true);
         return success;
    }   

    @RequestMapping(value = "upload", method = RequestMethod.POST, produces = MediaType.TEXT_PLAIN_VALUE)
    public @ResponseBody Map upload(MultipartHttpServletRequest request, HttpServletResponse response) {
        Iterator<String> itr = request.getFileNames();
        MultipartFile mpf;
        List list = new LinkedList();
        String folderid = request.getParameter("parentId");
        Folder folder = null;
        if(StringUtils.isNotEmpty(folderid)){
        	folder = folderService.get(folderid);
        }
        String owner = request.getParameter("o");
        if(StringUtils.isNotEmpty(owner) && !owner.equals(UserUtils.getCurrentUserId())){
	        boolean hasPermission = false;
	        if(UserUtils.hasRole("fileadmin") || UserUtils.isAdmin()){
	        	hasPermission = true;
	        }else   if(folder != null){
	        		hasPermission = filePermissionService.hasPermission(folder, FilePermission.EDITOR);
	        	
	        }
	        if(!hasPermission){
	        	throw new AccessControlException ("Access denied. Need fileadmin role.");
	        }
        }
        String systemCode = request.getParameter("s");
        if(StringUtils.isEmpty(systemCode)){
        	systemCode = Attachment.FILE_SYSTEM_CODE;
        }
        if(StringUtils.isEmpty(owner)){

        	owner = (UserUtils.getCurrentUserId());
        }
        boolean saveOther = true;
        String saveTitle = request.getParameter("saveOther");
        if(StringUtils.isNotEmpty(saveTitle) && saveTitle.equalsIgnoreCase("false")){
        	saveOther = false;
        }
        boolean draft = false;
        String draftStr = request.getParameter("draft");
        if(StringUtils.isNotEmpty(draftStr) && draftStr.equalsIgnoreCase("true")){
        	draft = true;
        }
        while (itr.hasNext()) {
            mpf = request.getFile(itr.next());
            
            String contentType = mpf.getContentType();
            
            String relativePath = request.getParameter("relativePath");
            
			if (logger.isDebugEnabled()) {
				logger.info("upload(MultipartHttpServletRequest, HttpServletResponse) - "
						+ relativePath);
			}
			
                Attachment attachment = new Attachment();
                if(StringUtils.isEmpty(relativePath)){
                	attachment.setParent(folder);
                }else{
                	Folder parentFolder = folderService.createRelativePath(folder, relativePath, owner, systemCode);
                	attachment.setParent(parentFolder);
                }
                
                attachment.setCreateTime(new Date());
                attachment.setName(mpf.getOriginalFilename());
                attachment.setType(contentType);
                attachment.setSize(mpf.getSize());
                attachment.setUserid(UserUtils.getCurrentUserId());

                attachment.setOwner(owner);

                attachment.setDraft(draft);

                attachment.setSystemCode(systemCode);
                attachment.setObjectId(request.getParameter("oid"));
                attachment.setKey(request.getParameter("key"));
                attachment.setProject(request.getParameter("proj"));
               if(saveOther){
                attachment.setTitle(request.getParameter("title"));
                attachment.setRemark(request.getParameter("mark"));
               }
                attachment.setParam1(request.getParameter("p1"));
                attachment.setParam2(request.getParameter("p2"));
                
                String aid = attFileService.upload( mpf);
                attachment.setAttFileId(aid);
                attachmentService.save(attachment);
                
                Map map = new HashMap();
                map.put("id", attachment.getId());
                map.put("createTime", attachment.getCreateTime());
                map.put("name", attachment.getName());
                map.put("size", attachment.getSize());
                

                list.add(map);
                

            
        }
        
        Map<String, Object> files = new HashMap();
        files.put("files", list);
        return files;
    }
	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(
			@Valid @ModelAttribute("createDomainModel") Attachment model,
			@RequestParam(value = "folderId", required = false) String folderId,
			RedirectAttributes redirectAttributes) {
			
			if(StringUtils.isNotEmpty(folderId)){
				model.setParent(folderService.get(folderId));
			}
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:" + getBaseViewPath();
	}
	


	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(
			@Valid @ModelAttribute("preloadDomainModel") Attachment model,
			@RequestParam(value = "folderId", required = false) String folderId,
			RedirectAttributes redirectAttributes) {
			if(StringUtils.isNotEmpty(folderId)){
				model.setParent(folderService.get(folderId));
			}
		getService().save(model);
		redirectAttributes.addFlashAttribute("message", messageSource
				.getMessage("core.update.success", new Object[] {}, null));
		return "redirect:" + getBaseViewPath();
	}

}
