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
public class Company extends Department {

	public Company(String id) {
		super(id);
	}
	public Company() {
	}

}