<%@tag import="cc.landking.web.core.utils.UserUtils,java.util.List"%><%@tag pageEncoding="UTF-8"%><%
String lkCureUserid = UserUtils.getCurrentUserId();
if(lkCureUserid != null){
	request.setAttribute("lkCureUserid", lkCureUserid);
	String lkCompanyId = UserUtils.getUserCompanyId();
	if(lkCureUserid != null){
		request.setAttribute("lkCompanyId", lkCompanyId);
	}
}%>${lkCompanyId}