package cc.landking.web.core.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.data.domain.Page;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import cc.landking.web.core.service.BaseService;
import cc.landking.web.core.utils.Servlets;

@Controller
public abstract class BaseController<T> {
	Log log = LogFactory.getLog(getClass());
	
	protected static final String PAGE_SIZE = "15";
	

	protected HttpServletRequest getContext(){
		HttpServletRequest curRequest = 
				((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes())
				.getRequest();
		return curRequest;
	}

	public abstract BaseService<T> getService();
	public abstract String getBaseViewPath();
	   @Autowired
	    protected MessageSource messageSource;

		@RequestMapping(method = RequestMethod.GET)
		public String index(){
			return getBaseViewPath()+"/list";
		}
		
	   @RequestMapping(value = "list", method = RequestMethod.GET)
		public String list(@RequestParam(value = "sortType", defaultValue = "auto") String sortType,
				@RequestParam(value = "page", defaultValue = "1") int pageNumber, 
				@RequestParam(value = "pageSize", defaultValue = PAGE_SIZE) int pageSize,
				@RequestParam(value = "sortOrder", defaultValue = "0") int sortOrder,Model model, ServletRequest request) {
			Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
			Page<T> page = getService().findPage(searchParams, pageNumber, pageSize, sortType,  sortOrder);
			model.addAttribute("page", page);
			model.addAttribute("sortType", sortType);
			model.addAttribute("sortOrder", sortOrder);
			// 将搜索条件编码成字符串，用于排序，分页的URL
			model.addAttribute("searchParams", Servlets.encodeParameterStringWithPrefix(searchParams, "search_"));
			return getBaseViewPath()+"/list";
		}

		@RequestMapping(value = "listjson",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
		@ResponseBody
		public Map<String, Object> listjson(@RequestParam(value = "sortType", defaultValue = "auto") String sortType,
				@RequestParam(value = "page", defaultValue = "1") int pageNumber,@RequestParam(value = "pageSize", defaultValue = PAGE_SIZE) int pageSize,
				@RequestParam(value = "sortOrder", defaultValue = "0") int sortOrder, Model model, ServletRequest request) {
			Map<String, Object> retval = new HashMap<String, Object>();
			Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
			Page<T> page = getService().findPage(searchParams, pageNumber, pageSize, sortType, sortOrder);
			
			retval.put("total_rows", page.getTotalElements());
			retval.put("rows", page.getContent());
			return retval;
		}
		@RequestMapping(value = "update/{id}", method = RequestMethod.GET)
		public String update(@PathVariable("id") String id, Model model) {
			model.addAttribute("model", getService().get(id));
			model.addAttribute("action","update");
			return getBaseViewPath()+"/edit";
		}
		@RequestMapping(value = "create", method = RequestMethod.GET)
		public String create( Model model) {
			model.addAttribute("model", createDomainModel());
			model.addAttribute("action","save");
			return getBaseViewPath()+"/edit";
		}
		
		@RequestMapping(value = "view/{id}", method = RequestMethod.GET)
		public String view(@PathVariable("id") String id, Model model) {
			long start = System.currentTimeMillis();
			log.debug("start:"+start);
			model.addAttribute("model", getService().get(id));
			long end = System.currentTimeMillis();
			log.debug("end:"+end+"|pass:"+(end - start));
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

		/**
		 * 使用@ModelAttribute, 先根据form的id从数据库查出对象,再把Form提交的内容绑定到该对象上。
		 * 因为仅update()方法的form中有id属性，因此本方法在该方法中执行.
		 */
		@ModelAttribute("preloadDomainModel")
		public T preloadDomainModel(@RequestParam(value = "id", required = false) String id) {
			if (id != null) {
				return getService().get(id);
			}
			return null;
		}

		@ModelAttribute("createDomainModel")
		public T createDomainModel() {
			
			try {
				return getService().getInterfaceClass().newInstance();
			} catch (InstantiationException e) {
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			}
			return null;
		}

}
