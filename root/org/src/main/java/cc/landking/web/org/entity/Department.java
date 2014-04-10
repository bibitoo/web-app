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
import cc.landking.web.org.entity.Employee;


@Entity
public class Department extends Organization {
	

		public Department(String id) {
			super(id);
		}
		public Department() {
		}


		@JsonBackReference  
		private Employee leader;
		
		@ManyToOne(cascade = CascadeType.REFRESH, fetch = FetchType.EAGER, optional = true) 
		@JoinColumn(name="leaderId") 
		public Employee getLeader() {
			return leader;
		}
	
	
		public void setLeader(Employee leader) {
			this.leader = leader;
		}









}