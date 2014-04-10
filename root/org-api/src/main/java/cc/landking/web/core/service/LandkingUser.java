package cc.landking.web.core.service;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.google.common.base.Objects;

public class LandkingUser implements Serializable {
	private static final long serialVersionUID = -1373760761780840081L;
	protected String id;
	protected String loginName;
	protected String name;
	protected List<String> roles = new ArrayList<String>();

	protected List<String> companies = new ArrayList<String>();

	public List<String> getCompanies() {
		return companies;
	}

	public void setCompanies(List<String> companies) {
		this.companies = companies;
	}
	
	protected String defaultCompanyId;

	public String getDefaultCompanyId() {
		return defaultCompanyId;
	}

	public void setDefaultCompanyId(String defaultCompanyId) {
		this.defaultCompanyId = defaultCompanyId;
	}

	protected List<String> organizations = new ArrayList<String>();
	
	protected String companyId ;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getLoginName() {
		return loginName;
	}

	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}

	public void setName(String name) {
		this.name = name;
	}

	public List<String> getOrganizations() {
		return organizations;
	}

	public void setOrganizations(List<String> organizations) {
		this.organizations = organizations;
	}


	public String getCompanyId() {
		return companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}

	public List<String> getRoles() {
		return roles;
	}

	public void setRoles(List<String> roles) {
		this.roles = roles;
	}

	public boolean isAdmin() {
		for (String role : roles) {
			if (role.equals("admin")) {
				return true;
			}
		}
		return false;
	}
	public LandkingUser() {
	}
	
	public LandkingUser(String loginName) {
		this.loginName = loginName;
	}

	public LandkingUser(String id, String loginName, String name) {
		this.id = id;
		this.loginName = loginName;
		this.name = name;
	}

	public String getName() {
		return name;
	}

	/**
	 * 本函数输出将作为默认的<shiro:principal/>输出.
	 */
	@Override
	public String toString() {
		return loginName;
	}

	/**
	 * 重载hashCode,只计算loginName;
	 */
	@Override
	public int hashCode() {
		return Objects.hashCode(loginName);
	}

	/**
	 * 重载equals,只计算loginName;
	 */
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		LandkingUser other = (LandkingUser) obj;
		if (loginName == null) {
			if (other.loginName != null)
				return false;
		} else if (!loginName.equals(other.loginName))
			return false;
		return true;
	}
	
	public void writeProperties(LandkingUser o){
		o.setId(this.getId());
		o.getCompanies().clear();
		o.getCompanies().addAll(this.getCompanies());
		o.setCompanyId(this.getCompanyId());
		o.setDefaultCompanyId(this.getDefaultCompanyId());
		o.setLoginName(this.getLoginName());
		o.setName(this.getName());
		o.getOrganizations().clear();
		o.getOrganizations().addAll(this.getOrganizations());
		o.setCurrentEmployeeId(this.getCurrentEmployeeId());
		o.getRoles().addAll(this.getRoles());
		
	}
	
	protected String currentEmployeeId;
	
	public void setCurrentEmployeeId(String currentEmployeeId) {
		this.currentEmployeeId = currentEmployeeId;
	}

	public String getCurrentEmployeeId() {

		return currentEmployeeId;
	}
}
