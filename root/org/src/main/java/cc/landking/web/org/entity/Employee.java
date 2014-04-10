package cc.landking.web.org.entity;

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
import cc.landking.web.core.entity.User;
import cc.landking.web.org.entity.Post;
import cc.landking.web.org.entity.Group;


@Entity
public class Employee extends Organization {
	

		
		public Employee(String id) {
		super(id);
	}
		public Employee() {}

		@JsonBackReference  
		private List<Department> manageDepartment = new ArrayList<Department>();
		
		@OneToMany(mappedBy = "leader", fetch = FetchType.LAZY, orphanRemoval = true, cascade = { CascadeType.REFRESH, CascadeType.PERSIST,CascadeType.MERGE, CascadeType.REMOVE, CascadeType.REFRESH })
		public List<Department> getManageDepartment(){
			return manageDepartment;
		}
		public void setManageDepartment(List<Department> manageDepartment){
			this.manageDepartment = manageDepartment;
		}

		@JsonBackReference  
		private Post post;
		
		@ManyToOne(cascade = CascadeType.REFRESH, fetch = FetchType.EAGER, optional = true) 
		@JoinColumn(name="postId") 
		public Post getPost() {
			return post;
		}
	
	
		public void setPost(Post post) {
			this.post = post;
		}
		
		private String userid;



		public String getUserid() {
			return userid;
		}
		public void setUserid(String userid) {
			this.userid = userid;
		}

		private User user;

		@Transient@JsonIgnore  
		public User getUser() {
			return user;
		}
		public void setUser(User user) {
			this.user = user;
		}
		

}