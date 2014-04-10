package cc.landking.web.file.service;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Calendar;
import java.util.Date;
import java.util.UUID;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import cc.landking.web.core.utils.Exceptions;
@Component
public class SystemFilePersist implements IFilePersist {
	/**
	 * Logger for this class
	 */
	private static final Log logger = LogFactory
			.getLog(SystemFilePersist.class);
	
    @Value("${file.upload.directory}")
    private String fileUploadDirectory;

	@Override
	public String upload(MultipartFile mpf) {
		try{
	        String newFilenameBase = UUID.randomUUID().toString();
	        String originalFileExtension = mpf.getOriginalFilename().substring(mpf.getOriginalFilename().lastIndexOf("."));
	        String newFilename = newFilenameBase + originalFileExtension;
	        File newFile = new File(fileUploadDirectory +generatePath(newFilename));
	        if(!newFile.getParentFile().exists())
	        	FileUtils.forceMkdir(newFile.getParentFile());
	        mpf.transferTo(newFile);
	  
	        return newFile.getAbsolutePath();
		}catch(Exception ex){
			throw Exceptions.unchecked(ex);
		}
	}
	
	private String generatePath(String id) {
		Date createTime = new Date();
		Calendar cal = Calendar.getInstance();
		cal.setTime(createTime);
		return "/" + cal.get(Calendar.YEAR) + "/"
				+ (cal.get(Calendar.MONTH) + 1) + "/" + id;
	}

	@Override
	public void download(String path, OutputStream out) {
		try {
			IOUtils.copy(new FileInputStream(path), out);
		} catch (Exception ex) {
			throw Exceptions.unchecked(ex);
		} 
	}

	@Override
	public InputStream getInputStream(String path) {
		
		try {
			return new FileInputStream(path);
		} catch (FileNotFoundException e) {

			e.printStackTrace();

			if (logger.isDebugEnabled()) {
				logger.debug("getInputStream(String)", e);
			}
		}
		return null;
	}
}
