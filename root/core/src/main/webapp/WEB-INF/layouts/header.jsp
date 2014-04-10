<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> 
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<fmt:bundle basename="i18n.message"/>
 <div class="navbar navbar-inverse navbar-fixed-top">
            <div class="navbar-inner">
                <div class="container">
                    <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="brand" href="http://doframe.com">DoFrame</a>
                    <div class="nav-collapse collapse">
                        <ul class="nav nav-pills">
                            <li class="active">
                                <a href="${ctx }/"><fmt:message key="nav.bar.home"/></a>
                            </li>
                            <li class="dropdown">
						        <a class="dropdown-toggle" data-toggle="dropdown" href="#"><fmt:message key="nav.bar.navigation"/> <b class="caret"></b></a>
						        <%@ include file="/WEB-INF/layouts/menu.jsp"%>
						      </li>
                           
                            <li>
                                <a href="http://doframe.com/contact.php"><fmt:message key="nav.bar.contack"/></a>
                            </li>
                        </ul>
                        
                        <div id="help" class="pull-right">
                        	
                        	 <ul class="nav nav-pills">
                        	    <li>
                        	    	<shiro:guest><a href="${ctx}/login"><fmt:message key="core.user.login"/></a></shiro:guest>
                        	    </li>
                        	 	<li  <shiro:user>class="dropdown"</shiro:user>>
                        	 		 <shiro:user>
											<a class=" dropdown-toggle" data-toggle="dropdown" href="#">
												<i class="icon-user"></i> <shiro:principal property="name"/>
												<span class="caret"></span>
											</a>
										
											<ul class="dropdown-menu">
												<shiro:hasRole name="admin">
													<li><a href="${ctx}/core/user/list"><fmt:message key="core.user.management"/></a></li>
													<li class="divider"></li>
												</shiro:hasRole>
												<li><a href="${ctx}/profile"><fmt:message key="user.profile" /></a></li>
												<li><a href="${ctx}/logout"><fmt:message key="user.logout"/></a></li>
											</ul>
									</shiro:user>
									<shiro:guest>
									<a href="${ctx }/register"><fmt:message key="core.user.registration"/></a>
									</shiro:guest>
                        	 	</li>
	                        	 <li class="dropdown">
							        <a class="dropdown-toggle" data-toggle="dropdown" href="#"><fmt:message key="nav.bar.help"/> <b class="caret"></b></a>
							        <ul class="dropdown-menu">
							          <li><a href="${ctx }/help">JQuery UI Help</a></li>
							           <li><a href="http://wrongwaycn.github.io/bootstrap/docs/index.html" target="_blank">Bootstrap Help</a></li>
							        </ul>
							      </li>
						      </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>


