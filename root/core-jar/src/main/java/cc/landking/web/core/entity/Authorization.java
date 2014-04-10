package cc.landking.web.core.entity;

import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Transient;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;


@Entity
public class Authorization extends AbstractIdEntity {
	
	@PrePersist
	public void prePersist(){
		this.lastModifyTime = new Date();
		this.createTime = this.lastModifyTime;
	}
	
	@PreUpdate
	public void preUpdate(){
		this.lastModifyTime = new Date();    
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


		private String companyId;
		


		public String getCompanyId() {
			return companyId;
		}

		public void setCompanyId(String companyId) {
			this.companyId = companyId;
		}

		private String organizationId;
		
		
		public void setOrganizationId(String organizationId) {
			this.organizationId = organizationId;
		}


		private String creatorId;
		
		

		public String getCreatorId() {
			return creatorId;
		}

		public void setCreatorId(String creatorId) {
			this.creatorId = creatorId;
		}


		@JsonBackReference  
		private User creator;
		
		@Transient@JsonIgnore 
		public User getCreator() {
			return creator;
		}
	
	
		public void setCreator(User creator) {
			this.creator = creator;
		}


		@JsonBackReference  
		private Role role;
		
		@ManyToOne(cascade = CascadeType.REFRESH, fetch = FetchType.EAGER, optional = true) 
		@JoinColumn(name="roleId") 
		public Role getRole() {
			return role;
		}
	
	
		public void setRole(Role role) {
			this.role = role;
		}

		@Transient
		public String getRoleId(){
			if(getRole() != null){
				return getRole().getId();
			}
			return null;
		}

		public String getOrganizationId(){
			return organizationId;
		}

}