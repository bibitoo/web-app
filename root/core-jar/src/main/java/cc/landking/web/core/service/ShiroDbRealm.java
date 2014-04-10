package cc.landking.web.core.service;

import javax.annotation.PostConstruct;

import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authc.credential.HashedCredentialsMatcher;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Autowired;

import cc.landking.web.core.entity.User;
import cc.landking.web.core.utils.Encodes;

public class ShiroDbRealm extends AuthorizingRealm {

	protected IUserService userService;
	
	/**
	 * 认证回调函数,登录时调用.
	 */
	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(
			AuthenticationToken authcToken) throws AuthenticationException {
		UsernamePasswordToken token = (UsernamePasswordToken) authcToken;
		User user = userService.findUserByLoginName(token.getUsername());
		if ((user != null)  && (!user.isForbidden())) {
			
			LandkingUser suser = new LandkingUser(user.getId(), user.getLoginName(),
					user.getName());
			suser.getRoles().addAll(user.getRoleList());
			byte[] salt = Encodes.decodeHex(user.getSalt());
			userService.resetUserRole(suser);

			return new SimpleAuthenticationInfo(suser, user.getPassword(),
					ByteSource.Util.bytes(salt), getName());
		} else {
			return null;
		}
	}


	/**
	 * 授权查询回调函数, 进行鉴权但缓存中无用户的授权信息时调用.
	 */
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(
			PrincipalCollection principals) {
		LandkingUser suser = (LandkingUser) principals.getPrimaryPrincipal();
		SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
		info.addRoles(suser.getRoles());
		return info;
		
	}

	/**
	 * 设定Password校验的Hash算法与迭代次数.
	 */
	@PostConstruct
	public void initCredentialsMatcher() {
		HashedCredentialsMatcher matcher = new HashedCredentialsMatcher(
				UserService.HASH_ALGORITHM);
		matcher.setHashIterations(UserService.HASH_INTERATIONS);

		setCredentialsMatcher(matcher);
	}

	@Autowired
	public void setUserService(IUserService userService) {
		this.userService = userService;
	}



}
