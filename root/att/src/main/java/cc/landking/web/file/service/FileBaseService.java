package cc.landking.web.file.service;

import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;
import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.persistence.Query;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.persistence.criteria.Subquery;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.domain.Sort.Order;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.dao.DynamicSpecifications;
import cc.landking.web.core.dao.IAuthQueryCallback;
import cc.landking.web.core.dao.SearchFilter;
import cc.landking.web.core.entity.ITree;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.core.service.TreeService;
import cc.landking.web.core.utils.UserUtils;
import cc.landking.web.file.dao.FileBaseDao;
import cc.landking.web.file.dao.FolderDao;
import cc.landking.web.file.entity.Attachment;
import cc.landking.web.file.entity.FileBase;
import cc.landking.web.file.entity.FilePermission;
import cc.landking.web.file.entity.Folder;

@Component
@Transactional(readOnly = true)
public class FileBaseService extends TreeService<FileBase> {
	/**
	 * Logger for this class
	 */
	private static final Log logger = LogFactory.getLog(FileBaseService.class);

	@Autowired
	private FileBaseDao fileBaseDao;
	
	@Autowired
	private FolderDao folderDao;
	
	@Autowired
	private FolderService folderService;
	
	@Autowired
	private AttachmentService attachmentService;
	@Autowired
	private FilePermissionService filePermissionService;

	@Autowired
	private AttFileService attFileService;

	@Override
	public BaseDao<FileBase> getDao() {
		return fileBaseDao;
	}
	
	public Page<FileBase> findPage( Map<String, Object> searchParams, int pageNumber, int pageSize,
			String sortType, int sortOrder) {
		if(pageNumber < 1){
			pageNumber = 1;
		}

		List< Order> orders=new ArrayList< Order>();
		orders.add( new Order(Direction.DESC, "fileBaseType"));
		orders.add( new Order(sortOrder == 0?Direction.ASC:Direction.DESC, sortType));
		PageRequest pageRequest = null;
		Sort  sort = new Sort(orders);
		

		pageRequest = new PageRequest(pageNumber - 1, pageSize, sort);
		if((searchParams.containsKey("EQ_owner") && searchParams.get("EQ_owner").toString().equals(UserUtils.getCurrentUserId()))
				|| UserUtils.hasRole("fileadmin" )
				){
			Specification<FileBase> spec = super.buildSpecification(searchParams);
			return getDao().findAll(spec, pageRequest);
		}
		Specification<FileBase> spec = buildSpecification(searchParams);
		return getDao().findAll(spec, pageRequest);
	}
	public void zipFile(OutputStream out, String[] ids, boolean auth) throws Exception{
		//查找所有的文件、目录
		List<FileBase> all = new ArrayList<FileBase>();
		for(int i=0;i<ids.length;i++){
			String id = ids[i];
			FileBase fb = get(id);
			if(fb != null && !fb.getDeleted()){
				boolean add = true;
				for(Iterator<FileBase> it = all.iterator();it.hasNext();){
					FileBase fileBase = it.next();
					if(fileBase.getHierarchyId().startsWith(fb.getHierarchyId())){
						//replace
						add = true;
						it.remove();
						break;
					}else if(fb.getHierarchyId().startsWith(fileBase.getHierarchyId())){
						//do nothing
						add = false;
						break;
						
					}
				}
				if(add){
					all.add(fb);
				}
			}
		}

		if (logger.isInfoEnabled()) {
			logger.info("zipFile(String[]) - List<FileBase> all=" + all);
		}
		//find all Files and folders


		ZipArchiveOutputStream zout = new ZipArchiveOutputStream(new BufferedOutputStream(out));  
        for(FileBase fileBase:all){
        	createCompressedFile(zout, fileBase, "",auth);  
        }
        zout.flush();
        zout.close();
	}
    public void createCompressedFile(ZipArchiveOutputStream out,FileBase file,String dir, boolean auth) throws Exception{  
        //如果当前的是文件夹，则进行进一步处理  
        if(file.isDirectory()){  
            //得到文件列表信息  
        	List<FileBase> files = null;
        	if(auth){
        		files = fileBaseDao.findByParent(file, UserUtils.getCurrentUserOrganizations());  
        	}else{
        		files = fileBaseDao.findByParent(file);  
        	}
            //将文件夹添加到下一级打包目录  
            dir =  dir+ file.getName()+"/";  

              
              
            //循环将文件夹中的文件打包  
            for(int i = 0 ; i < files.size() ; i++){  
            	FileBase fb = files.get(i);
                createCompressedFile(out, fb, dir , auth);         //递归处理  
            }  
        }  
        else{   //当前的是文件，打包处理  
            //文件输入流  
            Attachment attachment =  attachmentService.get(file.getId());
            InputStream in = attFileService.getFileInputStream(attachment.getAttFileId());

            //进行写操作  

            out.putArchiveEntry(new ZipArchiveEntry(dir + file.getName()));
            IOUtils.copy(in, out);
            out.closeArchiveEntry();

            //关闭输入流  
            in.close();  
        }  
    }  
	protected Specification<FileBase> buildSpecification( Map<String, Object> searchParams) {
		Map<String, SearchFilter> filters = SearchFilter.parse(searchParams);
		Specification<FileBase> spec = DynamicSpecifications.bySearchAndAuthorizeFilter(filters.values(),getInterfaceClass(), new IAuthQueryCallback<FileBase>(){

			@Override
			public void buildAuth(Root root, CriteriaQuery query,
					CriteriaBuilder builder, List predicates) {
			
					Subquery<FileBase> subquery = query.subquery(FileBase.class);
					Root subRootEntity = subquery.from(FilePermission.class);
					subquery.select(subRootEntity);
					subquery.where(builder.and(builder.equal(root.get("id"), subRootEntity.get("objectId")),subRootEntity.get("role").in(UserUtils.getCurrentUserOrganizations())));
					predicates.add(builder.exists(subquery));
					
			}
		});
		return spec;
	}

	public void deleteByOwner(String owner) {
		fileBaseDao.dolObj(owner);
		fileBaseDao.deleteClearAll(owner);
		
	}
	@Transactional(readOnly = false)
	public void disable(String id){
		FileBase fileBase = get(id);
		if(fileBase.getFileBaseType().equals("Attachment")){
			fileBase.setDeleted(true);
			fileBase.setParent(null);
			save(fileBase);
		}else{
			fileBaseDao.disable(fileBase.getHierarchyId()+"%",UserUtils.getCurrentUserId());
			fileBase.setDeleted(true);
			fileBase.setParent(null);
			save(fileBase);
		}
	}
	@Transactional(readOnly = false)
	public void move(String id,String to){
		FileBase obj = get(id);
		if(obj.getDeleted()){
			if(obj.getFileBaseType().equals("Folder")){

				fileBaseDao.enable(obj.getHierarchyId()+"%",UserUtils.getCurrentUserId());
			}
		}
		obj.setDeleted(false);
		
		obj.setParent((Folder)get(to));
		save(obj);
	}
	@Transactional(readOnly = false)
	public void update(FileBase entity,String readers, String editors) {
		filePermissionService.deleteByObjectId(entity.getId());
		if(entity instanceof Folder){
			folderService.save((Folder)entity,readers, editors);
		}else{
			attachmentService.save((Attachment)entity,readers, editors);
		}
	}
	@SuppressWarnings("rawtypes")
	@Override
	@Transactional(readOnly = false)
	public void save(FileBase entity) {
		ITree tree = (ITree) entity;
		String oldhierarchyId = tree.getHierarchyId();
		String hierachyId = null;
		if (tree.getParent() != null) {
			hierachyId = ((ITree) tree.getParent()).getHierarchyId()
					+ ITree.SPLITER + entity.getId();
		} else {
			hierachyId = ITree.SPLITER + entity.getId();
		}
		tree.setHierarchyId(hierachyId);
		// tree.selfSet();
		String newhierarchyId = tree.getHierarchyId();
		if (oldhierarchyId != null && !oldhierarchyId.equals(newhierarchyId)) {
			String hql = "update FileBase set ";
			hql += "hierarchyId='" + newhierarchyId
					+ "' || substring(hierarchyId, "
					+ (oldhierarchyId.length() + 1) + ", length(hierarchyId)) , lastModifier='"+UserUtils.getCurrentUserId()+"' ";
			hql += "where substring(hierarchyId,1," + oldhierarchyId.length()
					+ ")='" + oldhierarchyId + "'";

			Query q = em.createQuery(hql);

			q.executeUpdate();
		}

		getDao().save(entity);
	}

}
