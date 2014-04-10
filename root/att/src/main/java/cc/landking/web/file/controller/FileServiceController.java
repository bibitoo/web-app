package cc.landking.web.file.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import cc.landking.web.core.controller.BaseController;
import cc.landking.web.core.entity.AbstractIdEntity;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.core.utils.Collections3;
import cc.landking.web.core.utils.Servlets;
import cc.landking.web.core.utils.UserUtils;
import cc.landking.web.file.entity.Attachment;
import cc.landking.web.file.entity.FileBase;
import cc.landking.web.file.entity.FilePermission;
import cc.landking.web.file.service.AttachmentService;
import cc.landking.web.file.service.FileBaseService;
import cc.landking.web.file.service.FilePermissionService;
import cc.landking.web.file.service.FolderService;


@Controller
@RequestMapping(value = "/file/http-service")
public class FileServiceController  {


	@Autowired
	private AttachmentService attachmentService;

	@Autowired
	private FilePermissionService filePermissionService;
	
	@Autowired
	private ObjectMapper objectMapper;
	
	private TypeReference<HashMap<String, String>> typeRef = new TypeReference<HashMap<String, String>>() {
	}; 
	   @Autowired
	    protected MessageSource messageSource;

		@RequestMapping(value = "edit/{sys}/{oid}/{key}", method = RequestMethod.GET)
		public String serviceEdit(@PathVariable String sys, @PathVariable String oid,@PathVariable String key
				,HttpServletRequest request) throws JsonProcessingException{
			serviceList(sys,oid,key,request);
			
			
			return "/file/service/edit";
		}
		@RequestMapping(value = "dlist/{sys}/{oid}/{key}", method = RequestMethod.GET)
		public String serviceList(@PathVariable String sys, @PathVariable String oid,@PathVariable String key
				,@RequestParam(value = "sortType", defaultValue = "createTime") String sortType,
				@RequestParam(value = "page", defaultValue = "1") int pageNumber,@RequestParam(value = "pageSize", defaultValue = "5000") int pageSize,
				@RequestParam(value = "sortOrder", defaultValue = "0") int sortOrder,HttpServletRequest request) throws Exception{
			Map<String, Object> retval = new HashMap<String, Object>();
			Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
			if(sortType == null || sortType.equals("auto")){
				sortType="lastModifyTime";
				sortOrder = 1;
			}

			searchParams.put("EQ_draft", false);

			searchParams.put("EQ_systemCode", sys);
			searchParams.put("EQ_objectId", oid);
			searchParams.put("EQ_key", key);
	        searchParams.put("EQ_deleted", false);

			Page<Attachment> page = attachmentService.findPage(searchParams, pageNumber, pageSize, sortType, sortOrder);
			
			request.setAttribute("page", page);
			return "/file/service/dlist";
		}		

		@RequestMapping(value = "iedit/{sys}/{oid}/{key}")
		public String serviceIEdit(@PathVariable String sys, @PathVariable String oid,@PathVariable String key
				,@RequestParam(value = "sortType", defaultValue = "createTime") String sortType,
				@RequestParam(value = "page", defaultValue = "1") int pageNumber,@RequestParam(value = "pageSize", defaultValue = "5000") int pageSize,
				@RequestParam(value = "sortOrder", defaultValue = "0") int sortOrder,HttpServletRequest request) throws Exception{
			serviceList(sys,oid,key,request);
			String rows = request.getParameter("rows");
			Page<Attachment> page = null;
			if(StringUtils.isNotEmpty(rows) && rows.equalsIgnoreCase("empty")){
				 page = new PageImpl<Attachment>(new ArrayList<Attachment>());
			}else if(StringUtils.isNotEmpty(rows)){
				List<Attachment> atts = objectMapper.readValue(rows, new TypeReference<List<Attachment>>(){});
				List<Attachment> list = new ArrayList<Attachment>();
				for(Attachment att : atts){
					Attachment theAtt = attachmentService.get(att.getId());
					theAtt.setTitle(att.getTitle());
					theAtt.setRemark(att.getRemark());
					list.add(theAtt);
				}
				page = new PageImpl<Attachment>(list);
			}else{
				 page = getEditPage(sys,oid,key,sortType,pageNumber,pageSize,sortOrder,request);
			}
			request.setAttribute("page", page);
			return "/file/service/iedit";
		}		
		@RequestMapping(value = "dedit/{sys}/{oid}/{key}", method = RequestMethod.GET)
		public String serviceDEdit(@PathVariable String sys, @PathVariable String oid,@PathVariable String key
				,@RequestParam(value = "sortType", defaultValue = "createTime") String sortType,
				@RequestParam(value = "page", defaultValue = "1") int pageNumber,@RequestParam(value = "pageSize", defaultValue = "5000") int pageSize,
				@RequestParam(value = "sortOrder", defaultValue = "0") int sortOrder,HttpServletRequest request) throws JsonProcessingException{
			serviceList(sys,oid,key,request);
			Page<Attachment> page = getEditPage(sys,oid,key,sortType,pageNumber,pageSize,sortOrder,request);
			request.setAttribute("page", page);
			return "/file/service/dedit";
		}
		private Page<Attachment> getEditPage( String sys,  String oid, String key
				, String sortType,
				 int pageNumber,int pageSize,
				 int sortOrder,HttpServletRequest request){

			Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
			searchParams.put("EQ_draft", false);

			searchParams.put("EQ_systemCode", sys);
			searchParams.put("EQ_objectId", oid);
			searchParams.put("EQ_key", key);
	        searchParams.put("EQ_deleted", false);

			Page<Attachment> page = attachmentService.findPage(searchParams, pageNumber, pageSize, sortType, sortOrder);
			return page;
		}

	@RequestMapping(value = "list/{sys}/{oid}/{key}", method = RequestMethod.GET)
	public String serviceList(@PathVariable String sys, @PathVariable String oid,@PathVariable String key
			,HttpServletRequest request) throws JsonProcessingException{
		request.setAttribute("_service_sys", sys);
		request.setAttribute("_service_oid", oid);
		request.setAttribute("_service_key", key);
		String cols = request.getParameter("cols");
		if(StringUtils.isEmpty(cols)){
			cols = "id;title;name;size;createTime;remark";
		}
		ObjectMapper objectMapper = new ObjectMapper();
			String[] columns = cols.split(AbstractIdEntity.LIST_SPLITER);
			request.setAttribute("_service_file_columns", objectMapper.writeValueAsString(columns));
			List columnList = Collections3.createList(columns);
			List columnLabels = new LinkedList();
			for(int i=0;i<columns.length;i++){
				Map column = new HashMap();
				String col = columns[i];
				if(columnList.contains(col)){
					column.put("name", col);
					column.put("label", messageSource.getMessage("entity.attachment."+col.trim(), null, request.getLocale()));
					columnLabels.add(column);
				}
			}
			
			request.setAttribute("_service_file_columnLabels", objectMapper.writeValueAsString(columnLabels));

			String ts = request.getParameter("ts");
			if(StringUtils.isNotEmpty(ts)){
				String[] titles = ts.split(AbstractIdEntity.LIST_SPLITER);
				List tsList = Collections3.createList(titles);
				request.setAttribute("_service_file_titleSuggest", objectMapper.writeValueAsString(tsList));
			}
			String rm = request.getParameter("rm");
			if(StringUtils.isNotEmpty(rm)){
				String[] remarks = rm.split(AbstractIdEntity.LIST_SPLITER);
				List rmList = Collections3.createList(remarks);
				request.setAttribute("_service_file_remarkSuggest", objectMapper.writeValueAsString(rmList));
			}
		
		return "/file/service/list";
	}

    @RequestMapping(value = "config/{sys}/{key}", method = RequestMethod.GET)
    public String config(@PathVariable String sys) {
    	return "/file/service/config";
    }

	@RequestMapping(value = "listjson",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> listjson(@RequestParam(value = "sortType", defaultValue = "auto") String sortType,
			@RequestParam(value = "page", defaultValue = "1") int pageNumber,@RequestParam(value = "pageSize", defaultValue = "1000") int pageSize,
			@RequestParam(value = "sortOrder", defaultValue = "0") int sortOrder, Model model, ServletRequest request) {
		Map<String, Object> retval = new HashMap<String, Object>();
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
		searchParams.put("EQ_draft", false);
		if(sortType == null || sortType.equals("auto")){
			sortType="lastModifyTime";
			sortOrder = 1;
		}
		if(!searchParams.containsKey("EQ_owner") || searchParams.get("EQ_owner").toString().trim().length()==0){
			String owner = UserUtils.getCurrentUserId();
			searchParams.put("EQ_owner", owner);
		}
		if(!searchParams.containsKey("EQ_parent.id")){
			searchParams.put("ISNULL_parent", "null");
		}

		Page<Attachment> page = attachmentService.findPage(searchParams, pageNumber, pageSize, sortType, sortOrder);
		
		retval.put("total_rows", page.getTotalElements());
		retval.put("rows", page.getContent());
		return retval;
	}


}
