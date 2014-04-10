package cc.landking.web.core.entity;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.validation.constraints.NotNull;

import org.springframework.format.annotation.DateTimeFormat;

import cc.landking.web.core.utils.Digests;
import cc.landking.web.core.utils.Encodes;


@Entity
public class Role extends AbstractIdEntity {
	
	public static String USER_ROLE ="user";
	
	public static String ADMIN_ROLE = "admin";
	private String sysCode;
	
	public String getSysCode() {
		return sysCode;
	}

	public void setSysCode(String sysCode) {
		this.sysCode = sysCode;
	}


	private String name;
		@NotNull
			@Column(length = 200) 
		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}


	private String code;
		@NotNull
			@Column(length = 200) 
		public String getCode() {
			return code;
		}

		public void setCode(String code) {
			this.code = code;
		}


	private Date createTime;
				@DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss") 
		
		public Date getCreateTime() {
			return createTime;
		}

		public void setCreateTime(Date createTime) {
			this.createTime = createTime;
		}


	private Date lastModifyTime;
				@DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss") 
		
		public Date getLastModifyTime() {
			return lastModifyTime;
		}

		public void setLastModifyTime(Date lastModifyTime) {
			this.lastModifyTime = lastModifyTime;
		}



		public static String getRoleHash(String rolecode) throws UnsupportedEncodingException, IOException{
			return Encodes.encodeHex(Digests.md5(new ByteArrayInputStream(rolecode.getBytes("UTF-8"))));
		}


		public static void main(String[] args) throws UnsupportedEncodingException, IOException{
			for(int i=0;i<100;i++){
				System.out.println(getRoleHash("core.user.role.fileadmin"));
			}
		}





}