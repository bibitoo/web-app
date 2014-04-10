<%@tag pageEncoding="UTF-8"%>
<%@ attribute name="value" type="java.util.Date" required="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:formatDate value="${value}" type="both" 
      pattern="yyyy-MM-dd" />