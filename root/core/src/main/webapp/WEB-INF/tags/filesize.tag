<%@tag pageEncoding="UTF-8"%>
<%@ attribute name="size" type="java.lang.Long" required="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%

Object sizeObj = getJspContext().getAttribute("size");
if(sizeObj instanceof java.lang.Long){
	//out.print(sizeObj);
// 	out.print(cc.landking.web.core.utils.AppUtils.byteCountToDisplaySize(size));
// out.print("/");
	out.print(cc.landking.web.core.utils.AppUtils.humanReadableByteCount(size,false));
// 	out.print("/");
// 	out.print(cc.landking.web.core.utils.AppUtils.humanReadableByteCount(size,true));
}
%>
