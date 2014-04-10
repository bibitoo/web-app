package cc.landking.web.file.entity;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;

import org.springframework.format.annotation.DateTimeFormat;

import cc.landking.web.core.entity.AbstractIdEntity;
import cc.landking.web.core.entity.ITree;
import cc.landking.web.core.utils.UserUtils;

import com.fasterxml.jackson.annotation.JsonIgnore;


@Entity
public class FileBase extends AbstractIdEntity  implements ITree<FileBase>{
	//大小
	protected Long size;
	
	public Long getSize() {
		return size;
	}

	public void setSize(Long size) {
		this.size = size;
	}

	//Attachment or Folder
	protected String fileBaseType ;
	
	
	public String getFileBaseType() {
		return fileBaseType;
	}

	public void setFileBaseType(String fileBaseType) {
		this.fileBaseType = fileBaseType;
	}

	@JsonIgnore 
	private Set<FileBase> children = new HashSet<FileBase>();
 
	@Override
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "parent")
	public Set<FileBase> getChildren() {
		return children;
	}

	public void setChildren(Set<FileBase> children) {
		this.children = children;
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
	
	//树层级
	@Override
	public void setHierarchyId(String hierarchyId) {
		this.hierarchyId = hierarchyId;
	}
	
	@Transient
	public void preSave(){
		if(parent != null){
			hierarchyId = parent.getHierarchyId()+ITree.SPLITER+getId();
		}else{
			hierarchyId = ITree.SPLITER+getId();
		}
		this.lastModifier = UserUtils.getCurrentUserId();
	}

	@JsonIgnore
	protected Folder parent;

	@ManyToOne(fetch = FetchType.LAZY, cascade = { CascadeType.PERSIST,
			CascadeType.MERGE })
	public Folder getParent() {
		return parent;
	}

	public void setParent(Folder parent) {
		this.parent = parent;
	}

	//系统代码
	private String systemCode;
	
	@Column(length = 200) 
	public String getSystemCode() {
		return systemCode;
	}
	
	public void setSystemCode(String systemCode) {
		this.systemCode = systemCode;
	}

	//名称
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


	private String creator;
		
			@Column(length = 36) 
		public String getCreator() {
			return creator;
		}

		public void setCreator(String creator) {
			this.creator = creator;
		}
		private String lastModifier;

		@Column(length = 36) 
	public String getLastModifier() {
			return lastModifier;
		}

		public void setLastModifier(String lastModifier) {
			this.lastModifier = lastModifier;
		}

		//拥有者（公司、个人）
	private String owner;
		
			@Column(length = 36) 
		public String getOwner() {
			return owner;
		}

		public void setOwner(String owner) {
			this.owner = owner;
		}
		private Boolean draft = Boolean.FALSE;
		

		public Boolean getDraft() {
			return draft;
		}

		public void setDraft(Boolean draft) {
			this.draft = draft;
		}

	//是否已删除
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
		this.fileBaseType = this.getClass().getSimpleName();
		this.creator = UserUtils.getCurrentUserId();
		preSave();
	}
	
	@PreUpdate
	public void preUpdate(){
		this.lastModifyTime = new Date();    
		preSave();
	}
	
 
	@Transient
	public boolean isDirectory(){
		return this.fileBaseType.equals("Folder");
	}


	//所属对象ID
	private String objectId;
		
			@Column(length = 36) 
		public String getObjectId() {
			return objectId;
		}

		public void setObjectId(String objectId) {
			this.objectId = objectId;
		}

		//区别关键字
	private String key;
		
			@Column(length = 50,name="f_key") 
		public String getKey() {
			return key;
		}

		public void setKey(String key) {
			this.key = key;
		}
		//所属项目ID
		private String project;

	public String getProject() {
			return project;
		}

		public void setProject(String project) {
			this.project = project;
		}
	//附件主题
	private String title;
	
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	//备注
	private String remark;

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	private String param1;
		
			@Column(length = 200) 
		public String getParam1() {
			return param1;
		}

		public void setParam1(String param1) {
			this.param1 = param1;
		}


	private String param2;
		
			@Column(length = 200) 
		public String getParam2() {
			return param2;
		}

		public void setParam2(String param2) {
			this.param2 = param2;
		}



}