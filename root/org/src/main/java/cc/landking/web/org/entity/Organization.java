package cc.landking.web.org.entity;

import java.util.Date;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;

import org.springframework.format.annotation.DateTimeFormat;

import cc.landking.web.core.entity.AbstractIdEntity;
import cc.landking.web.core.entity.ITree;
import cc.landking.web.core.service.OrganizationData;

import com.fasterxml.jackson.annotation.JsonIgnore;


@Entity
public class Organization extends AbstractIdEntity implements ITree<Organization>{
	
	public Organization(String id){
		this.id = id;
	}
	public Organization(){
	}
	
	private String companyId;
	
	
	public String getCompanyId() {
		return companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}


	private String orgType;

	public String getOrgType() {
		return orgType;
	}

	public void setOrgType(String orgType) {
		this.orgType = orgType;
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


	private Boolean virtual;
		
		public Boolean getVirtual() {
			return virtual;
		}

		public void setVirtual(Boolean virtual) {
			this.virtual = virtual;
		}
		
		private Boolean deleted = Boolean.FALSE;
		
		public Boolean getDeleted() {
			return deleted;
		}

		public void setDeleted(Boolean deleted) {
			this.deleted = deleted;
		}

		@PrePersist
		public void prePersist(){
			this.lastModifyTime = new Date();
			this.createTime = this.lastModifyTime;
			if(deleted == null || deleted){
				this.parent = null;
			}
			this.orgType = this.getClass().getSimpleName();
			preSave();
		}
		
		@PreUpdate
		public void preUpdate(){
			this.lastModifyTime = new Date();    
			preSave();
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

		@JsonIgnore   
		private Set<Group> groups = new HashSet<Group>();

		@ManyToMany(cascade = CascadeType.REFRESH, fetch = FetchType.LAZY)  
	    @JoinTable(name="organization_groups", inverseJoinColumns = @JoinColumn(name = "group_id"), joinColumns = @JoinColumn(name = "organization_id"))  
		public Set<Group> getGroups() {
			return groups;
		}


		public void setGroups(Set<Group> groups) {
			this.groups = groups;
		}
			



	@JsonIgnore 
	private Set<Organization> children = new HashSet<Organization>();
 
	@Override
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "parent")
	public Set<Organization> getChildren() {
		return children;
	}

	public void setChildren(Set<Organization> children) {
		this.children = children;
	}

	@JsonIgnore
	private Organization parent;

	@ManyToOne(fetch = FetchType.LAZY, cascade = { CascadeType.PERSIST,
			CascadeType.MERGE })
	public Organization getParent() {
		return parent;
	}

	public void setParent(Organization parent) {
		this.parent = parent;
	}


	@Override
	@Transient
	public boolean getIsParent(){
		return !children.isEmpty();
	}
	


	private String hierarchyId;
	public String getHierarchyId() {
		return hierarchyId;
	}

	@Override
	public void setHierarchyId(String hierarchyId) {
		this.hierarchyId = hierarchyId;
	}
	

	private void preSave(){
		if(parent != null){
			hierarchyId = parent.getHierarchyId()+ITree.SPLITER+getId();
		}else{
			hierarchyId = ITree.SPLITER+getId();
		}
			if(orgType.equals("Company")){
					companyId = id;
			}else{
				Organization tmp = parent;
				while(tmp != null && tmp.getOrgType() !=null && !tmp.getOrgType().equals("Company")){
					tmp = tmp.getParent();
				}
				if(tmp != null && tmp.getOrgType()!=null &&  tmp.getOrgType().equals("Company")){
					this.companyId = tmp.getId();
				}
			}
	}
	
	@Transient@JsonIgnore
	public List<Organization> getParents(){
		List<Organization> list = new LinkedList<Organization>();
		Organization the = getParent();
		while (the != null){
			list.add(the);
			the = the.getParent();
		}
		return list;
	}
	
	@Transient@JsonIgnore
	public List<Organization> getBreadcrumbs(){
		LinkedList<Organization> list = new LinkedList<Organization>();
		Organization the = this;
		while (the != null && the.getOrgType() != null && !the.getOrgType().equals("Company")){
			list.addFirst(the);
			the = the.getParent();
		}
		if( (the != null && the.getOrgType() != null && the.getOrgType().equals("Company"))){
			list.addFirst(the);
		}
		return list;
	}
	
	@Transient@JsonIgnore
	public String getBreadcrumbString(){
		List<Organization> list = getBreadcrumbs();
		StringBuffer sb = new StringBuffer();
		for(Organization org :list){
			sb.append("/");
			sb.append(org.getName());
		}
		return sb.toString();
	}
	@Transient
	public String getIconSkin(){
		return orgType;
	}
	
	@Transient
	public OrganizationData getOrganizationData(){
		OrganizationData data = new OrganizationData();
		data.setId(this.getId());
		data.setName(this.getName());
		data.setCompanyId(this.getCompanyId());
		data.setCreateTime(this.getCreateTime());
		data.setDeleted(this.getDeleted());
		data.setHierarchyId(this.getHierarchyId());
		data.setLastModifyTime(this.getLastModifyTime());
		data.setOrgType(this.getOrgType());
		if(this.getParent() != null){
			data.setParentId(this.getParent().getId());
			data.setParentName(this.getParent().getName());
		}
		data.setVirtual(this.getVirtual());
		return data;
	}
}