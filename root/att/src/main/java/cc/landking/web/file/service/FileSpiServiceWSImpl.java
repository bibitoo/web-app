package cc.landking.web.file.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.jws.WebService;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Component;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import cc.landking.web.core.entity.AbstractIdEntity;
import cc.landking.web.core.utils.Exceptions;
import cc.landking.web.file.entity.Attachment;
import cc.landking.web.file.entity.FilePermission;
import cc.landking.web.file.spi.FileSpiService;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Component(value="fileSpiServiceWSImp")
@WebService( endpointInterface = "cc.landking.web.file.spi.FileSpiService")

public class FileSpiServiceWSImpl  extends SpringBeanAutowiringSupport implements FileSpiService {
	/**
	 * Logger for this class
	 */
	private static final Log logger = LogFactory
			.getLog(FileSpiServiceWSImpl.class);

	@Autowired
	private AttachmentService attachmentService;
	@Autowired
	private FilePermissionService filePermissionService;
	
	@Autowired
	private ObjectMapper objectMapper;

	@Override
	public void save(String resultStr, HashMap<String,String> permissions) {
		logger.debug(resultStr);
		if(resultStr == null){
			return;
		}
		try {
			JsonNode rootNode = objectMapper.readTree(resultStr);
			JsonNode idNode = rootNode.path("deletedIds");
			if(idNode != null && idNode.elements().hasNext()){
				String deletedIds = idNode.elements().next().asText();
				
				logger.debug(deletedIds);
				if(deletedIds != null){
					String[] dids = deletedIds.split(AbstractIdEntity.LIST_SPLITER);
					for(int i=0; i<dids.length; i++){
						try{
						attachmentService.delete(dids[i]);
						}catch(EmptyResultDataAccessException e){
							
						}
					}
				}
			}
			JsonNode rowNode = rootNode.path("rows");
			String rowStr = rowNode.toString();
			if(StringUtils.isNotEmpty(rowStr)){
				if (logger.isInfoEnabled()) {
					logger.info("save(String, List<String>) - String rowStr="
							+ rowStr);
				}
				ArrayList<Attachment> results = objectMapper.readValue(rowStr, new TypeReference<List<Attachment>>(){});
				for(Iterator<Attachment> it = results.iterator();it.hasNext();){
					Attachment newat = it.next();
					Attachment old = attachmentService.get(newat.getId());
					old.setTitle(newat.getTitle());
					old.setRemark(newat.getRemark());
					attachmentService.save(old);
					for(Iterator<String> keyit = permissions.keySet().iterator();keyit.hasNext();){
						String permission = keyit.next();
						String orgidsStr = permissions.get(permission);
						String[] orgids = orgidsStr.split(AbstractIdEntity.LIST_SPLITER);
						for(String orgid:orgids){
							FilePermission filePermission = new FilePermission();
							filePermission.setPermission(permission);
							filePermission.setObjectId(orgid);
							filePermission.setObjectId(old.getId());
							filePermissionService.save(filePermission);
						}
					}
					
					
				}
			}
		} catch (Exception e) {
			throw Exceptions.unchecked(e);
		} 
	}

}
