package cc.landking.web.file.service;

import java.util.Arrays;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cc.landking.web.core.entity.AbstractIdEntity;
import cc.landking.web.core.entity.ITree;
import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.core.service.TreeService;
import cc.landking.web.core.utils.UserUtils;
import cc.landking.web.file.dao.FolderDao;
import cc.landking.web.file.entity.FileBase;
import cc.landking.web.file.entity.FilePermission;
import cc.landking.web.file.entity.Folder;

@Component
@Transactional(readOnly = true)
public class FolderService extends TreeService<Folder> {

	private FolderDao folderDao;
	
	@Autowired
	private FilePermissionService filePermissionService;

	@Override
	public BaseDao<Folder> getDao() {
		return folderDao;
	}
	
	@Autowired
	@Qualifier("folderDao")
	public void setFolderDao(FolderDao folderDao) {
		this.folderDao = folderDao;
	}

	public List<Folder> findByParent(String owner, String systemCode,String id){
		ITree<FileBase> parent = null;
		if(UserUtils.isAdmin() || UserUtils.hasRole("fileadmin") || UserUtils.getCurrentUserId().equals(owner)){
			if(StringUtils.isNotEmpty(id)){
				parent = get(id);
				return folderDao.findByParentAndOwnerAndDeleted(parent, owner, false);
			}
			if(StringUtils.isNotEmpty(owner)){
				return folderDao.findRoot(owner,systemCode);
			}else{
				return folderDao.findRoot(UserUtils.getCurrentUserId(),systemCode);
			}
		}else{
			if(StringUtils.isNotEmpty(id)){
				parent = get(id);
				return folderDao.findByParentAndOwnerAndDeletedAuth(parent, owner, UserUtils.getCurrentUserOrganizations());
			}
			if(StringUtils.isNotEmpty(owner)){
				return folderDao.findRootAuth(owner,systemCode, UserUtils.getCurrentUserOrganizations());
			}else{
				return folderDao.findRoot(UserUtils.getCurrentUserId(),systemCode);
			}			
		}
	}
	@Transactional(readOnly = false)
	public void save(Folder entity,String readers,String editors){
		filePermissionService.saveEditors(entity.getId(), editors);
		filePermissionService.saveReaders(entity.getId(), readers);
		save(entity);
	}

	public Folder createRelativePath(Folder folder, String relativePath, String owner, String systemCode) {
		String[] paths = relativePath.split("/");
		Folder parent = folder;
		for(int i=0;i<paths.length;i++){
			List<Folder> folders = null;
			if(parent == null){
				folders = folderDao.findByNameOnRoot(paths[i],owner,systemCode);
			}else{
				folders = folderDao.findByParentAndName(parent, paths[i]);
			}
			if(folders != null && folders.size()>0){
				parent = folders.get(0);
			}else{
				Folder newfolder = new Folder();
				if(parent == null){
					newfolder.setName(paths[i]);
					newfolder.setOwner(owner);
					newfolder.setSystemCode(systemCode);	
					newfolder.setFileBaseType(newfolder.getClass().getSimpleName());
					save(newfolder);
				}else{
					newfolder.setFileBaseType(parent.getFileBaseType());
					newfolder.setName(paths[i]);
					newfolder.setOwner(parent.getOwner());
					newfolder.setSystemCode(parent.getSystemCode());
					newfolder.setParent(parent);
					filePermissionService.copyPermission(parent.getId(),newfolder.getId());
				}
				parent = newfolder;
			}
		}
		return parent;
	}

}
