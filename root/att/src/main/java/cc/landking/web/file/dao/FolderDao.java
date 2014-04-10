package cc.landking.web.file.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Query;

import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.entity.ITree;
import cc.landking.web.file.entity.FileBase;
import cc.landking.web.file.entity.Folder;

public interface FolderDao extends BaseDao<Folder> {

	public List<Folder> findByParentAndDeleted(ITree<FileBase> parent,boolean deleted);
	
	public List<Folder> findByParentAndOwnerAndDeleted(ITree<FileBase> parent, String owner, boolean deleted);

	@Query("SELECT o FROM Folder o WHERE EXISTS (SELECT p FROM FilePermission p WHERE p.objectId = o.id and p.role in (?3)) and  o.parent =?1  and o.deleted = false and o.owner = ?2  ")
	public List<Folder> findByParentAndOwnerAndDeletedAuth(ITree<FileBase> parent, String owner, List<String> roles);

	@Query("SELECT o FROM Folder o WHERE o.parent is null  and o.deleted = false and o.owner = ?1 and o.systemCode = ?2 ")
	public List<Folder> findRoot(String owner, String systemCode);
	
	@Query("SELECT o FROM Folder o WHERE EXISTS (SELECT p FROM FilePermission p WHERE p.objectId = o.id and p.role in (?3)) and  o.parent is null  and o.deleted = false and o.owner = ?1 and o.systemCode = ?2 ")
	public List<Folder> findRootAuth(String owner, String systemCode,List<String> roles);
	
	@Query("SELECT o FROM Folder o WHERE o.parent is null  and o.deleted = false and o.owner is null and  o.systemCode = ?1")
	public List<Folder> findRoot(String systemCode);
	
	@Query("SELECT o FROM Folder o WHERE o.parent = ?1  and o.deleted = false")
	public List<Folder> findByParent(ITree<FileBase> parent);

	@Query("SELECT o FROM Folder o WHERE o.hierarchyId like ?1 ")
	public List<Folder> findDeletedByHierarchyId(String  hierarchyId);
	
	@Query("SELECT o FROM Folder o WHERE o.parent is null  and o.name = ?1 and o.owner=?2 and o.systemCode=?3 and  o.deleted = false ")
	public List<Folder> findByNameOnRoot(String name,String owner,String systemCode);
	
	public List<Folder> findByParentAndName(Folder parent,String name);

}
