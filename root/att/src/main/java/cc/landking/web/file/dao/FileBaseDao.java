package cc.landking.web.file.dao;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.file.entity.FileBase;
import cc.landking.web.file.entity.Folder;

public interface FileBaseDao extends BaseDao<FileBase> {
	@Query("SELECT o FROM FileBase o WHERE o.parent = ?1  and o.deleted = false")
	public List<FileBase> findByParent(FileBase parent);
	
	@Query("SELECT o FROM FileBase o  WHERE o.parent in ?1  and o.deleted = false and EXISTS (SELECT p FROM FilePermission p WHERE p.objectId = o.id and p.role in (?2))")
	public List<FileBase> findByParent(FileBase parent, List<String> roles);

	 @Modifying
	 @Query("delete FROM FileBase o WHERE o.owner = ?1  and o.deleted = true")
	public void deleteClearAll(String owner);
	 @Modifying
	 @Query("update  FileBase o set o.parent = null  WHERE o.owner = ?1  and o.deleted = true ")
	public void dolObj(String owner );

	 @Modifying
	 @Query("update  FileBase o set o.deleted = true,o.lastModifier=?2 WHERE o.hierarchyId like ?1  ")
	public void disable(String hid, String lastModifier );
	 @Modifying
	 @Query("update  FileBase o set o.deleted = false,o.lastModifier=?2  WHERE o.hierarchyId like ?1  ")
	public void enable(String hid, String lastModifier );

	 @Modifying
	 @Query("update  FileBase o set o.deleted = false,o.lastModifier=?2  WHERE o.parent in ?1")
	public void enable(List<Folder> folders, String lastModifier);
	 

}
