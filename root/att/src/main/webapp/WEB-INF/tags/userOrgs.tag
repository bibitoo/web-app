<%@tag import="cc.landking.web.core.utils.UserUtils,java.util.List"%><%@tag pageEncoding="UTF-8"%><%
List<String> orgs = UserUtils.getCurrentUserOrganizations();
if(orgs != null && orgs.size()>0){
	String var = "[";
	for(int i=0;i<orgs.size();i++){
		String orgid = orgs.get(i);
		if(i>0){
			 var += ",";
		}
		 var += "\""+orgid+"\"";
	}
	 var += "]";
	out.print(var);
}else{
	out.print("[]");
}
%>