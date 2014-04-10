package cc.landking.web.core.utils;

import java.util.List;

import javax.servlet.ServletRequest;

import org.apache.shiro.SecurityUtils;

import cc.landking.web.core.entity.Role;
import cc.landking.web.core.service.LandkingUser;

public class UserUtils {

	public  static List<String> getCurrentUserRoles(){
		LandkingUser user = (LandkingUser) SecurityUtils.getSubject().getPrincipal();
		return user.getRoles();
	}
	public  static List<String> getCurrentUserOrganizations(){
		LandkingUser user = (LandkingUser) SecurityUtils.getSubject().getPrincipal();
		return user.getOrganizations();
	}
	public static String getCurrentUserId(){
		if(SecurityUtils.getSubject()!=null && SecurityUtils.getSubject().getPrincipal()!=null){
			LandkingUser user = (LandkingUser) SecurityUtils.getSubject().getPrincipal();
			return user.getId();
		}else{
			return null;
		}
	}
	public static  void updateCurrentUserName(String userName) {
		LandkingUser user = (LandkingUser) SecurityUtils.getSubject().getPrincipal();
		user.setName(userName);
	}
	public static String getCurrentUserName() {
		LandkingUser user = (LandkingUser) SecurityUtils.getSubject().getPrincipal();
		return user.getLoginName();
	}
	public static LandkingUser getCurrentUser(){
		return  (LandkingUser) SecurityUtils.getSubject().getPrincipal();
	}
	public static String getUserCompanyId(){
		if(UserUtils.getCurrentUser() != null){
			return UserUtils.getCurrentUser().getCompanyId();
			
		}
		return null;
	}

	public static boolean isAdmin(){
		if(getCurrentUser()!= null){
			return getCurrentUser().isAdmin();
		}else{
			return false;
		}
	}
	public static boolean hasRole(String code){
		try {
			return UserUtils.getCurrentUserRoles().contains(code) ||
			UserUtils.getCurrentUserRoles().contains(Role.getRoleHash("core.user.role."+code));
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		
	}
	public static String getcurrentEmployeeId() {
		return getCurrentUser().getCurrentEmployeeId();
	}
}
