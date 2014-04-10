package cc.landking.web.file.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.core.utils.Exceptions;
import cc.landking.web.file.dao.AttFileDao;
import cc.landking.web.file.entity.AttFile;

@Component
@Transactional(readOnly = true)
public class AttFileService extends BaseService<AttFile> implements ApplicationContextAware{

	private AttFileDao attFileDao;
	
    @Value("${file.upload.filePersist.default}")
    private String filePersist;

	@Override
	public BaseDao<AttFile> getDao() {
		return attFileDao;
	}
	
	@Autowired
	@Qualifier("attFileDao")
	public void setAttFileDao(AttFileDao attFileDao) {
		this.attFileDao = attFileDao;
	}
	
	public InputStream getFileInputStream(String  id) throws FileNotFoundException, IOException{
		//select authorize files
		IFilePersist fp = getFilePersist(this.filePersist);
		AttFile attFile = attFileDao.findOne(id);
		if(attFile != null){
			return fp.getInputStream(attFile.getPath());
		}
		return null;
	}
	
	
	public void write(OutputStream out,String id) throws FileNotFoundException, IOException{
		AttFile attFile = get(id);
		getFilePersist(attFile.getType()).download(attFile.getPath(), out);
	}

	public String upload(MultipartFile mpf) {
		try{
	        AttFile attFile = new AttFile();
	        attFile.setSize(mpf.getSize());
	        attFile.setName(mpf.getOriginalFilename());
	        attFile.setType(filePersist);
	        String path = getFilePersist(filePersist).upload(mpf);
	        attFile.setPath(path);
	        save(attFile);
	        return attFile.getId();
		}catch(Exception ex){
			throw Exceptions.unchecked(ex);
		}
	}

	private IFilePersist getFilePersist(String type) {
		
		return (IFilePersist) ctx.getBean(type);
	}


	
	ApplicationContext ctx;
	@Override
	public void setApplicationContext(ApplicationContext ctx)
			throws BeansException {
		this.ctx = ctx;
		
	}
}
