<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Default navigation bar
--%>

<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="java.util.Map" %>
<%
    // Is anyone logged in?
    EPerson user = (EPerson) request.getAttribute("dspace.current.user");

    // Is the logged in user an admin
    Boolean admin = (Boolean)request.getAttribute("is.admin");
    boolean isAdmin = (admin == null ? false : admin.booleanValue());

    // Get the current page, minus query string
    String currentPage = UIUtil.getOriginalURL(request);
    int c = currentPage.indexOf( '?' );
    if( c > -1 )
    {
        currentPage = currentPage.substring( 0, c );
    }

    // E-mail may have to be truncated
    String navbarEmail = null;

    if (user != null)
    {
        navbarEmail = user.getEmail();
    }
    
    // get the browse indices
    
	BrowseIndex[] bis = BrowseIndex.getBrowseIndices();
    BrowseInfo binfo = (BrowseInfo) request.getAttribute("browse.info");
    String browseCurrent = "";
    if (binfo != null)
    {
        BrowseIndex bix = binfo.getBrowseIndex();
        // Only highlight the current browse, only if it is a metadata index,
        // or the selected sort option is the default for the index
        if (bix.isMetadataIndex() || bix.getSortOption() == binfo.getSortOption())
        {
            if (bix.getName() != null)
    			browseCurrent = bix.getName();
        }
    }
 // get the locale languages
    Locale[] supportedLocales = I18nUtil.getSupportedLocales();
    Locale sessionLocale = UIUtil.getSessionLocale(request);
%>


       <div class="navbar-header" >
         <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
           <span class="icon-bar"></span>
           <span class="icon-bar"></span>
           <span class="icon-bar"></span>
         </button>
         <a class="navbar-brand" id="logotype" href="<%= request.getContextPath() %>/"><h1 id="headerTextH1">Repositorio Institucional</h1><h2 id="headerTextH2">Universidad Autónoma de Occidente</h2></a>
       </div>
       <nav class="collapse navbar-collapse bs-navbar-collapse" role="navigation" id="gralOpts">
         <ul class="nav navbar-nav">
           <!--<li class="<%= currentPage.endsWith("/home.jsp")? "active" : "" %>"><a href="<%= request.getContextPath() %>/"><span class="glyphicon glyphicon-home"></span> <fmt:message key="jsp.layout.navbar-default.home"/></a></li>-->
             
             <!-- BROWSE ! -->
             
            <li class="dropdown" id="compactableBrowseBtn">
             <a href="#" class="dropdown-toggle" data-toggle="dropdown"><!--<fmt:message key="jsp.layout.navbar-default.browse"/> --> C&C<!--<b class="caret"></b>--><img  class="dropdownIcon pull-right" src="<%= request.getContextPath() %>/image/dropdownIcon.png"/> </a>
               
             <ul class="dropdown-menu">
               <li><a href="<%= request.getContextPath() %>/community-list"><fmt:message key="jsp.layout.navbar-default.communities-collections"/></a></li>
				<li class="divider"></li>
        <li class="dropdown-header"><fmt:message key="jsp.layout.navbar-default.browseitemsby"/></li>
				<%-- Insert the dynamic browse indices here --%>
				
				<%
					for (int i = 0; i < bis.length; i++)
					{
						BrowseIndex bix = bis[i];
						String key = "browse.menu." + bix.getName();
					%>
				      			<li><a href="<%= request.getContextPath() %>/browse?type=<%= bix.getName() %>"><fmt:message key="<%= key %>"/></a></li>
					<%	
					}
				%>
				    
				<%-- End of dynamic browse indices --%>

            </ul>
          </li><!-- BROWSE ! -->

          <li class="<%= ( currentPage.endsWith( "/help" ) ? "active" : "" ) %>"><dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.index\") %>"><img id="helpIconWhite" src="<%= request.getContextPath() %>/image/helpIconw.png" style="float:left"><img id="helpIconBlack" src="<%= request.getContextPath() %>/image/helpIcon.png" style="float:left"><div id="helpText" style="margin-left:20px;"><fmt:message  key="jsp.layout.navbar-default.help"/></div></dspace:popup></li>
       </ul>

 <% if (supportedLocales != null && supportedLocales.length > 1)
     {
 %>
    <div class="nav navbar-nav">
	 <ul class="nav navbar-nav">
      <li class="dropdown">
       <a href="#" class="dropdown-toggle" data-toggle="dropdown"><fmt:message key="jsp.layout.navbar-default.language"/><b class="caret"></b></a>
        <ul class="dropdown-menu">
 <%
    for (int i = supportedLocales.length-1; i >= 0; i--)
     {
 %>
      <li>
        <a onclick="javascript:document.repost.locale.value='<%=supportedLocales[i].toString()%>';
                  document.repost.submit();" href="<%= request.getContextPath() %>?locale=<%=supportedLocales[i].toString()%>">
         <%= supportedLocales[i].getDisplayLanguage(supportedLocales[i])%>
       </a>
      </li>
 <%
     }
 %>
     </ul>
    </li>
    </ul>
  </div>
 <%
   }
 %>
 
       <div class="nav navbar-nav navbar-right">
		<ul class="nav navbar-right">
         <li class="dropdown">
         <%
    if (user != null)
    {
		%>
		<a href="#" class="dropdown-toggle cabin fadeBackground" id="loggedUser" data-toggle="dropdown"><span class="glyphicon glyphicon-user"></span> <fmt:message key="jsp.layout.navbar-default.loggedin">
		      <fmt:param><b><%= StringUtils.abbreviate(navbarEmail, 20) %></b></fmt:param>
		  </fmt:message> <b class="caret pull-right"></b></a>
		<%
    } else {
		%> <!-- Login Btn -->
             <a href="#" class="dropdown-toggle btn-primary" id="loginBtn" style="color:#fff" data-toggle="dropdown"><img src="<%= request.getContextPath() %>/image/userIcon.png"/> <fmt:message key="jsp.layout.navbar-default.sign"/> <!--<b class="caret"></b>--><img style="margin-top:5px;" class="dropdownIcon pull-right" src="<%= request.getContextPath() %>/image/dropdownIcon.png"/></a>
	<% } %>             
             <ul class="dropdown-menu">
               <li><a href="<%= request.getContextPath() %>/mydspace"><fmt:message key="jsp.layout.navbar-default.users"/></a></li>
               <li><a href="<%= request.getContextPath() %>/subscribe"><fmt:message key="jsp.layout.navbar-default.receive"/></a></li>
               <li><a href="<%= request.getContextPath() %>/profile"><fmt:message key="jsp.layout.navbar-default.edit"/></a></li>

		<%
		  if (isAdmin)
		  {
		%>
			   <li class="divider"></li>  
               <li><a href="<%= request.getContextPath() %>/dspace-admin"><fmt:message key="jsp.administer"/></a></li>
		<%
		  }
		  if (user != null) {
		%>
		<li><a href="<%= request.getContextPath() %>/logout"><span class="glyphicon glyphicon-log-out"></span> <fmt:message key="jsp.layout.navbar-default.logout"/></a></li>
		<% } %>
             </ul>
           </li>
          </ul>
          
	</div>
    </nav>
        <div class="searchBar">
            
            <%-- Search Box --%>
                <div class="container">
	<form method="get" action="<%= request.getContextPath() %>/simple-search" class="navbar-form">
	    <div class="form-group">
              <button type="submit" class="btn btn-primary fadeBackground" id="navSearchBarBtn"><img src="<%= request.getContextPath() %>/image/searchIcon.svg" onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/image/searchIcon.png'"/><!--<span class="glyphicon glyphicon-search"></span>--> </button>
          <input type="text" class="form-control" id="navSearchBar" placeholder="<fmt:message key="jsp.layout.navbar-default.search"/>" name="query" id="tequery" size="25"/>
        </div>
      
<%--               <br/><a href="<%= request.getContextPath() %>/advanced-search"><fmt:message key="jsp.layout.navbar-default.advanced"/></a>
<%
			if (ConfigurationManager.getBooleanProperty("webui.controlledvocabulary.enable"))
			{
%>        
              <br/><a href="<%= request.getContextPath() %>/subject-search"><fmt:message key="jsp.layout.navbar-default.subjectsearch"/></a>
<%
            }
%> --%>
	</form>
     <ul class="nav navbar-nav" id="browseBtn">
               <!-- BROWSE ! -->   
           <li class="dropdown" >
             <a href="#" class="dropdown-toggle cabin" data-toggle="dropdown" style="color:#fff"><!--<fmt:message key="jsp.layout.navbar-default.browse"/> --> <b>Communities</b>&<b>Colections</b><!--<b class="caret"></b>--><img  class="dropdownIcon" src="<%= request.getContextPath() %>/image/dropdownIcon.png"/></a>
               
             <ul class="dropdown-menu" style="top:123%; right:0px;">
               <li><a href="<%= request.getContextPath() %>/community-list"><fmt:message key="jsp.layout.navbar-default.communities-collections"/></a></li>
				<li class="divider"></li>
        <li class="dropdown-header"><fmt:message key="jsp.layout.navbar-default.browseitemsby"/></li>
				<%-- Insert the dynamic browse indices here --%>
				
				<%
					for (int i = 0; i < bis.length; i++)
					{
						BrowseIndex bix = bis[i];
						String key = "browse.menu." + bix.getName();
					%>
				      			<li><a href="<%= request.getContextPath() %>/browse?type=<%= bix.getName() %>"><fmt:message key="<%= key %>"/></a></li>
					<%	
					}
				%>
				    
				<%-- End of dynamic browse indices --%>

            </ul>
          </li><!-- BROWSE ! -->
                    </ul>
                    
    </div><!-- cierraContainer -->
    </div>
