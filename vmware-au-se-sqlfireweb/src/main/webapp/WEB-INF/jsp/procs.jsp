<%--
  	Copyright (c) 2013 GoPivotal, Inc. All Rights Reserved.

	This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; only version 2 of the License, and no
    later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

	The full text of the GPL is provided in the COPYING file.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "https://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" type="text/css" href="../css/isqlfire.css" />
<link rel="stylesheet" type="text/css" href="../css/print.css" media="print" />
<script type="text/javascript">
  // <![CDATA[
  
  // js form validation stuff
  var confirmMsg  = 'Do you really want to ';
  // ]]>
</script>
<script src="../js/functions.js" type="text/javascript"></script>

<title><fmt:message key="sqlfireweb.appname" /> - Stored ${procType}(s)</title>
</head>
<body>
<c:choose>
  <c:when test="${procType == 'P'}">
    <c:set var="type" value="Procedure" />
  </c:when>
  <c:otherwise>
    <c:set var="type" value="Function" />
  </c:otherwise>
</c:choose>

<h2><fmt:message key="sqlfireweb.appname" /> - Stored ${type}(s)</h2>

<jsp:include page="toolbar.jsp" flush="true" />

<div class="notice">
Found ${records} ${type}(s).
</div>

<c:if test="${!empty procParams}">
<h3>Stored Procedure ${procName} Parameters</h3>
<table id="table_results" class="data">
 <thead>
   <tr>
    <th>Param Id#</th>
    <th>Column Name</th>
    <th>Type Name</th>
   </tr>
 </thead>
 <tbody>
	<c:forEach var="procrow" items="${procParams}">
		<tr class="${((loop.index % 2) == 0) ? 'even' : 'odd'}">
		  <td>${procrow.parameterId}</td>
		  <td>${procrow.columnName}</td>
		  <td>${procrow.typeName}</td>
		</tr>
	</c:forEach>
 </tbody>
</table>
<br />
</c:if>

<c:if test="${!empty result}">
<fieldset>
 <legend>Result</legend>
 <table class="formlayout">
  <tr>
   <td align="right">Command:</td>
   <td>${result.command} </td>
  </tr>
  <tr>
   <td align="right">Message:</td>
   <td> 
    <font color="${result.message == 'SUCCESS' ? 'green' : 'red'}">
      ${result.message}
    </font>
   </td>
  </tr>
 </table>
</fieldset>
<br />
</c:if>

<c:if test="${!empty arrayresult}">
<fieldset>
 <legend>Multi Submit Results</legend>
 <table class="formlayout">
  <c:forEach var="result" items="${arrayresult}">
    <tr>
     <td align="right">Command:</td>
     <td> ${result.command} </td>
    </tr>
    <tr>
     <td align="right">Message:</td>
     <td> 
      <font color="${result.message == 'SUCCESS' ? 'green' : 'red'}">
        ${result.message}
      </font>
     </td>
    </tr>
  </c:forEach>
 </table>
</fieldset>
<br />
</c:if>

<form action="procs" method="POST">
   <b>Filter ${type} Name </b>
   <input type="hidden" name="procType" value="${procType}" />
   <input type="TEXT" name="search" value="${search}" />
   <b>Schema : </b>
   <select name="selectedSchema">
	   <c:forEach var="row" items="${schemas}">
	   	<c:choose>
	   		<c:when test="${row == chosenSchema}">
	   		  <option value="${row}" selected="selected">${row}</option>
	   		</c:when>
	   		<c:otherwise>
	   		  <option value="${row}">${row}</option>
	   		</c:otherwise>
	   	</c:choose>
	   </c:forEach>
   </select>
   <input type="image" src="../themes/original/img/Search.png" />
</form>

<!-- Display previous/next set links -->
<c:if test="${estimatedrecords > sessionScope.prefs.recordsToDisplay}"> &nbsp; | &nbsp;
  <c:if test="${startAtIndex != 0}">
    <a href="procs?search=${param.search}&selectedSchema=${chosenSchema}&procType=${procType}&startAtIndex=${(startAtIndex - sessionScope.prefs.recordsToDisplay)}&endAtIndex=${startAtIndex}">
      <img src="../themes/original/img/Previous.png" border="0" />
    </a>
    &nbsp;
  </c:if>
  <c:if test="${estimatedrecords != endAtIndex}">
    <a href="procs?search=${param.search}&selectedSchema=${chosenSchema}&procType=${procType}&startAtIndex=${endAtIndex}&endAtIndex=${endAtIndex + sessionScope.prefs.recordsToDisplay}">
      <img src="../themes/original/img/Next.png" border="0" />
    </a>
  </c:if>
  &nbsp; <font color="Purple">Current Set [${startAtIndex + 1} - ${endAtIndex}] </font>
</c:if>

<p />

<form method="post" action="procs" name="tablesForm" id="tablesForm">
<input type="hidden" name="procType" value="${procType}" />
<input type="hidden" name="selectedSchema" value="${chosenSchema}" />
<table id="table_results" class="data">
 <thead>
   <tr>
    <th></th>
    <th>Schema</th>
    <th>Name</th>
    <th>Java Class Name</th>
    <th>Action</th>
   </tr>
 </thead>
 <tbody>
	<c:forEach var="entry" varStatus="loop" items="${procs}">
  	  <tr class="${((loop.index % 2) == 0) ? 'even' : 'odd'}">
		  <td align="center">
		      <input type="checkbox" 
		             name="selected_proc[]"
		             value="${entry['name']}"
		             id="checkbox_proc_${loop.index + 1}" />
		   </td>
		   <td align="center">${entry.schemaName}</td>
	  	   <td align="center">${entry.name}</td>
	  	   <td align="center">${entry.javaClassName}</td>
	  	   <td align="center">
    		<a href="procs?procName=${entry['name']}&procAction=DROP&procType=${procType}&selectedSchema=${chosenSchema}" onclick="return confirmLink(this, 'DROP ${type} ${entry['name']}?')">
             <img class="icon" width="16" height="16" src="../themes/original/img/b_drop.png" alt="Drop ${type}" title="Drop ${type}" />
            </a>&nbsp; 
            <c:if test="${procType == 'P'}">   
	    		<a href="procs?procName=${entry['name']}&procAction=DESC&procType=${procType}&selectedSchema=${chosenSchema}">
	             <img class="icon" width="16" height="16" src="../themes/original/img/b_dbstatistics.png" alt="Describe ${type}" title="Describe ${type}" />
	            </a>&nbsp;
            </c:if>       
	  	   </td>
  	   </tr>
	</c:forEach>
 </tbody>
</table>

<div class="clearfloat">
<img class="selectallarrow" src="../themes/original/img/arrow_ltr.png"
    width="38" height="22" alt="With selected:" />
<a href="procs?selectedSchema=${chosenSchema}&procType=${procType}"
    onclick="if (setCheckboxes('table_results', 'true')) return false;">
    Check All</a>

/
<a href="procs?selectedSchema=${chosenSchema}&procType=${procType}"
    onclick="if (unMarkAllRows('tablesForm')) return false;">
    Uncheck All</a>

<select name="submit_mult" onchange="this.form.submit();" style="margin: 0 3em 0 3em;">
    <option value="With selected:" selected="selected">With selected:</option>
    <option value="Drop" >Drop</option>
</select>


<script type="text/javascript">
<!--
// Fake js to allow the use of the <noscript> tag
//-->
</script>
<noscript>
    <input type="submit" value="Go" />
</noscript>
</div>

</form>

<p />

<br />

<jsp:include page="footer.jsp" flush="true" />

</body>
</html>