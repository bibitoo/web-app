package cc.landking.web.file.dao;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.entity.ITree;
import cc.landking.web.file.entity.FilePermission;
import cc.landking.web.file.entity.Folder;

public interface FilePermissionDao extends BaseDao<FilePermission> {

	public List<FilePermission> findByObjectId(String objectId);

	public List<FilePermission> findByObjectIdAndPermission(String objectId,String permission);
	
	@Query("select o from FilePermission o where o.objectId=?1 and o.permission=?2 and o.role in(?3)")
	public List<FilePermission> findByObjectIdAndPermissionAndRoles(String objectId, String permission,List<String> roles,Pageable pageable);

	@Modifying
	@Query("delete from FilePermission o where o.objectId=?1 ")
	public void deleteByObjectId(String objectId);

}
