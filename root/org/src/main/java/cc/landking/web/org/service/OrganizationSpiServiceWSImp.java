package cc.landking.web.org.service;

import java.util.HashMap;
import java.util.List;

import javax.jws.WebService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import cc.landking.web.core.service.LandkingUser;
import cc.landking.web.core.service.OrganizationData;
import cc.landking.web.core.service.OrganizationSpiService;

@Component(value="organizationSpiServiceWSImp")
@WebService( endpointInterface = "cc.landking.web.core.service.OrganizationSpiService")
public class OrganizationSpiServiceWSImp extends SpringBeanAutowiringSupport
		implements OrganizationSpiService 
		{
	
	@Autowired private OrganizationService organizationService;
	

	public LandkingUser getUser(String loginName, String companyId) {
		
		return organizationService.getUser(loginName, companyId);
	}


	public OrganizationData getById(String id) {
		return organizationService.getById(id);
	}


	public List<String> findOrganizations(String orgId) {
		return organizationService.findOrganizations(orgId);
	}


	public HashMap<String, String> findCompanies(String userid) {
		return organizationService.findCompanies(userid);
	}


	public List<OrganizationData> findCompaniesByUser(String userid) {
		return organizationService.findCompaniesByUser(userid);
	}

}
