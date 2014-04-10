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
import cc.landking.web.core.utils.UserUtils;


@Entity
public class FilePermission extends AbstractIdEntity {
	public static String READER = "reader";
	public static String EDITOR= "editor";

	public FilePermission() {
		super();
	}


	public FilePermission(String objectId, String role, String permission) {
		super();
		this.objectId = objectId;
		this.role = role;
		this.permission = permission;
	}
	@PrePersist
	public void prePersist(){
		this.createTime = new Date();
		this.creator = UserUtils.getCurrentUserId();
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


	private String role;
		@NotNull
			@Column(length = 36) 
		public String getRole() {
			return role;
		}

		public void setRole(String role) {
			this.role = role;
		}


	private String creator;
		@NotNull
			@Column(length = 36) 
		public String getCreator() {
			return creator;
		}

		public void setCreator(String creator) {
			this.creator = creator;
		}


	private Date createTime;
				@DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss") 
		
		public Date getCreateTime() {
			return createTime;
		}

		public void setCreateTime(Date createTime) {
			this.createTime = createTime;
		}


	private String permission;
		@NotNull
			@Column(length = 10) 
		public String getPermission() {
			return permission;
		}

		public void setPermission(String permission) {
			this.permission = permission;
		}






}