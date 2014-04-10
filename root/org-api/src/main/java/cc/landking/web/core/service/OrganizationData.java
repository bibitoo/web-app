package cc.landking.web.core.service;

import java.util.Date;


import org.springframework.format.annotation.DateTimeFormat;


public class OrganizationData {
	protected String id ;


	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	public OrganizationData(String id) {
		this.id = id;
	}

	public OrganizationData() {
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

	private Date createTime;

	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	private Date lastModifyTime;

	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getLastModifyTime() {
		return lastModifyTime;
	}

	public void setLastModifyTime(Date lastModifyTime) {
		this.lastModifyTime = lastModifyTime;
	}

	private String parentId;

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	private String parentName;

	public String getParentName() {
		return parentName;
	}

	public void setParentName(String parentName) {
		this.parentName = parentName;
	}

	private String hierarchyId;

	public String getHierarchyId() {
		return hierarchyId;
	}

	public void setHierarchyId(String hierarchyId) {
		this.hierarchyId = hierarchyId;
	}

}