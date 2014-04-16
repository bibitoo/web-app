package cc.landking.web.core.service;

import java.util.List;

import javax.jws.WebService;
@WebService
public interface OrganizationSpiService {
	
	public LandkingUser getUser(String loginName,String companyId);

	public OrganizationData getById(String id);
	
	public List<String> findOrganizations(String orgId);
	

	public  List<OrganizationData>  findCompanies(String userid);
	
	public  List<OrganizationData>  findCompaniesByUser(String userid);
}
