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
public class AttFile extends AbstractIdEntity {
	

	private String name;
		@NotNull
			@Column(length = 2000) 
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


	private String type;
		@NotNull
			@Column(length = 50) 
		public String getType() {
			return type;
		}

		public void setType(String type) {
			this.type = type;
		}


	private Long size;
		
		public Long getSize() {
			return size;
		}

		public void setSize(Long size) {
			this.size = size;
		}


	private String hashCode;
		
			@Column(length = 200) 
		public String getHashCode() {
			return hashCode;
		}

		public void setHashCode(String hashCode) {
			this.hashCode = hashCode;
		}




		private String path;
			
				@Column(length = 2000) 
			public String getPath() {
				return path;
			}

			public void setPath(String path) {
				this.path = path;
			}



			@PrePersist
			public void prePersist(){
				this.lastModifyTime = new Date();
				this.createTime = this.lastModifyTime;
			}
			
			@PreUpdate
			public void preUpdate(){
				this.lastModifyTime = new Date();    

			}


}