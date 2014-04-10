package cc.landking.web.core.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;

import org.apache.commons.lang3.builder.ToStringBuilder;

/**
 * 统一定义id的实体基类.
 * 
 * @author sunzhen
 */
//JPA 基类的标识
@MappedSuperclass
public abstract class AbstractIdEntity implements Serializable{
	
	public static String LIST_SPLITER=";";

	protected String id = IDGenerator.UUID();

	@Id
	@Column(length = 36) 
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this,new NoCollectionStyle());
	}

}
