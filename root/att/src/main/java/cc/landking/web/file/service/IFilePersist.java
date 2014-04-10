package cc.landking.web.file.service;

import java.io.InputStream;
import java.io.OutputStream;

import org.springframework.web.multipart.MultipartFile;

public interface IFilePersist {
	/**
	 * 
	 * @param mpf
	 * @return path
	 */
	public String upload(MultipartFile mpf) ;
	
	/**
	 * 
	 * @param path
	 * @param out
	 */
	public void download(String path, OutputStream out);
	
	
	public InputStream getInputStream(String path);
}
