package cc.landking.web.file.service;

import java.util.List;
import java.util.Map;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import javax.persistence.criteria.Subquery;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cc.landking.web.core.entity.ITree;
import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.dao.DynamicSpecifications;
import cc.landking.web.core.dao.IAuthQueryCallback;
import cc.landking.web.core.dao.SearchFilter;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.core.service.TreeService;
import cc.landking.web.core.utils.UserUtils;
import cc.landking.web.file.dao.AttachmentDao;
import cc.landking.web.file.entity.Attachment;
import cc.landking.web.file.entity.FileBase;
import cc.landking.web.file.entity.FilePermission;
import cc.landking.web.file.entity.Folder;

@Component
@Transactional(readOnly = true)
public class AttachmentService extends TreeService<Attachment> {

	private AttachmentDao attachmentDao;
	@Autowired
	private FilePermissionService filePermissionService;

	@Override
	public BaseDao<Attachment> getDao() {
		return attachmentDao;
	}
	
	@Autowired
	@Qualifier("attachmentDao")
	public void setAttachmentDao(AttachmentDao attachmentDao) {
		this.attachmentDao = attachmentDao;
	}
	protected Specification<Attachment> buildSpecification( Map<String, Object> searchParams) {
		Map<String, SearchFilter> filters = SearchFilter.parse(searchParams);
		Specification<Attachment> spec = DynamicSpecifications.bySearchAndAuthorizeFilter(filters.values(),getInterfaceClass(), new IAuthQueryCallback<Attachment>(){

			@Override
			public void buildAuth(Root root, CriteriaQuery query,
					CriteriaBuilder builder, List predicates) {
			if(UserUtils.isAdmin()){
				return;
			}
					Subquery<Attachment> subquery = query.subquery(Attachment.class);
					Root subRootEntity = subquery.from(FilePermission.class);
					subquery.select(subRootEntity);
					subquery.where(builder.and(builder.equal(root.get("id"), subRootEntity.get("objectId")),subRootEntity.get("role").in(UserUtils.getCurrentUserOrganizations())));
					predicates.add(builder.exists(subquery));
					
			}
		});
		return spec;
	}


	@Transactional(readOnly = false)
	public void save(Attachment entity) {

		 if(entity.getParent()!= null){
			 Map<String,Object> perms = filePermissionService.findPermissionByObjectId(entity.getParent().getId());
			 Map editors = (Map) perms.get(FilePermission.EDITOR);
			 Map readers = (Map) perms.get(FilePermission.READER);
			 filePermissionService.saveEditors(entity.getId(), (String) editors.get("ids"));
			 filePermissionService.saveReaders(entity.getId(), (String) readers.get("ids"));
		 }else{
			 if( UserUtils.getCurrentUser() != null){
				 filePermissionService.saveEditors(entity.getId(), UserUtils.getcurrentEmployeeId());
			 }
		 }
		 super.save(entity);
	}	
	@Transactional(readOnly = false)
	public void save(Attachment entity, String readers, String editors) {

		filePermissionService.saveEditors(entity.getId(), editors);
		filePermissionService.saveReaders(entity.getId(), readers);
		save(entity);
	}

}
