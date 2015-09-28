<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Form requesting a Handle or internal item ID for item editing
  -
  - Attributes:
  -     invalid.id  - if this attribute is present, display error msg
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>


<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.core.ConfigurationManager" %>

<dspace:layout style="submission" titlekey="jsp.tools.get-item-id.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin">
<br/>
	<%-- <h1>Edit or Delete Item</h1> --%>
	<h1><fmt:message key="jsp.tools.get-item-id.heading"/>
	<dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.site-admin\") + \"#items\"%>"><fmt:message key="jsp.morehelp"/></dspace:popup>
	</h1>
    
  
<%
    if (request.getAttribute("invalid.id") != null) { %>
    <%-- <p><strong>The ID you entered isn't a valid item ID.</strong>  If you're trying to
    edit a community or collection, you need to use the --%>
    <%-- <a href="<%= request.getContextPath() %>/dspace-admin/edit-communities">communities/collections admin page.</a></p> --%>
	<p class="alert alert-warning"><fmt:message key="jsp.tools.get-item-id.info1">
        <fmt:param><%= request.getContextPath() %>/dspace-admin/edit-communities</fmt:param>
    </fmt:message></p>
<%  } %>

    <%-- <p>Enter the Handle or internal item ID of the item you want to edit or
    delete.  <dspace:popup page="/help/site-admin.html#items">More help...</dspace:popup></p> --%>
<br/>
    
	<div><fmt:message key="jsp.tools.get-item-id.info2"/></div>
    <br/><br/>
    <form method="get" action="">
    	<div class="row">
            <label class="col-md-2" for="thandle"><fmt:message key="jsp.tools.get-item-id.handle"/></label>            
           	<span class="col-md-3"><input class="form-control" type="text" name="handle" id="thandle" value="<%= ConfigurationManager.getProperty("handle.prefix") %>/" size="12"/></span>
			<%-- <input type="submit" name="submit" value="Find" /> --%>
			<input class="btn btn-primary" type="submit" name="submit" value="<fmt:message key="jsp.tools.get-item-id.find.button"/>" />
		</div>
        <br/>
		<div class="row">
			<label class="col-md-2" for="thandle"><fmt:message key="jsp.tools.get-item-id.internal"/></label>
            <span class="col-md-3"><input class="form-control" type="text" name="item_id" id="titem_id" size="12"/></span>
			<%-- <input type="submit" name="submit" value="Find"> --%>
			<input class="btn btn-primary" type="submit" name="submit" value="<fmt:message key="jsp.tools.get-item-id.find.button"/>" />
 		</div>               
    </form>
</dspace:layout>
    
                                         <script>
    /* makes header bar dark */
    var header = document.getElementsByTagName('header')[0];
    var nav = document.getElementsByTagName('nav')[0];
    header.style.backgroundColor = "black";
        nav.style.paddingTop = "12px";
    </script>
