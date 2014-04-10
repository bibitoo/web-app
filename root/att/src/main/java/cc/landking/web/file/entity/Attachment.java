package cc.landking.web.file.entity;

import java.util.*;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.hibernate.annotations.Type;
import org.hibernate.validator.constraints.NotBlank;
import org.springframework.format.annotation.DateTimeFormat;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;

import cc.landking.web.core.entity.AbstractIdEntity;
import cc.landking.web.file.entity.Folder;


@Entity
public class Attachment extends FileBase {
	public static String FILE_SYSTEM_CODE="file";


	private String userid;
		
			@Column(length = 36) 
		public String getUserid() {
			return userid;
		}

		public void setUserid(String userid) {
			this.userid = userid;
		}


//mime-type
	private String type;
		
			@Column(length = 200) 
		public String getType() {
			return type;
		}

		public void setType(String type) {
			this.type = type;
		}

		//物理文件
		private String attFileId;
		@NotNull
		@Column(length = 36) 
		public String getAttFileId() {
			return attFileId;
		}

		public void setAttFileId(String attFileId) {
			this.attFileId = attFileId;
		}
		

}