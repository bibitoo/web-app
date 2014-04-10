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


@Entity
public class Share extends AbstractIdEntity {
	

	private String name;
		@NotNull
			@Column(length = 200) 
		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
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


	private String objectId;
		@NotNull
			@Column(length = 36) 
		public String getObjectId() {
			return objectId;
		}

		public void setObjectId(String objectId) {
			this.objectId = objectId;
		}


	private String type;
		@NotNull
			@Column(length = 20) 
		public String getType() {
			return type;
		}

		public void setType(String type) {
			this.type = type;
		}







}