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


@Entity
public class Group extends Organization {
	





	public Group() {}


	public Group(String id) {
		super(id);
	}


	@JsonBackReference  
	private Set<Organization> organizations = new HashSet<Organization>();

	@ManyToMany(cascade = CascadeType.REFRESH, fetch = FetchType.LAZY)  
    @JoinTable(name="organization_groups", inverseJoinColumns = @JoinColumn(name = "organization_id"), joinColumns = @JoinColumn(name = "group_id"))  
	public Set<Organization> getOrganizations() {
		return organizations;
	}


	public void setOrganizations(Set<Organization> organizations) {
		this.organizations = organizations;
	}
		




}