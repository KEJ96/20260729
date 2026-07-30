<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="cf" uri="/WEB-INF/tags/cf" %>
<%@ taglib prefix="menu" uri="/WEB-INF/tags/menu" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:message var="datePattern" code="message.format.date.pattern"></spring:message>

<c:set var="listparam" value="${cf:queryString(param,'paginationInfo.currentPageNo') }"  />
<c:set var="detailparam" value="${cf:queryString(param,'') }"  />
<c:url var="excelUrl" value="listExcel.do?${listparam }" />
<c:url var="listUrl" value="list.do" />
<c:url var="insertUrl" value="insert.do"></c:url>

<script type="text/javascript">
	// main iso001
</script>

<form:form modelAttribute="searchVO" action="${listUrl }" method="get" onsubmit="return doSubmit()" cssClass="searchForm">

	<div class="search_area">
		<table>
			<caption>조회 조건</caption>
			<colgroup>
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr>
				<th scope="row">결재업무</th>
				<td>
					<form:select path="searchApvlType">
						<form:option value="">전체</form:option>
						<form:options items="${apvlTypeList}" itemLabel="catNm" itemValue="catCd" />
					</form:select>
				</td>
				<th scope="row">문서명</th>
				<td>
					<form:input path="searchApvlTitl" />
					<div class="btn_search01">
						<span class="btn_pack_l type07"><button type="button" name="search" onclick="clickSubmit()" >조회</button></span>
					</div>
				</td>
			</tr>
		</table>
	</div>

	<div class="button_area">
		<div style="float:left">
			전체 <strong><c:out value="${searchVO.paginationInfo.totalRecordCount }" /></strong>건&nbsp;
		</div>
		<form:select path="paginationInfo.recordCountPerPage" onchange="changeRecodeCount()">
			<form:option value="15">15</form:option>
			<form:option value="30">30</form:option>
			<form:option value="50">50</form:option>
			<form:option value="100">100</form:option>
		</form:select>
	</div>
	<div class="list">
		<table>
			<caption>결재반려문서 목록</caption>
			<colgroup>
				<col width="5%" />
				<col width="25%" />
				<col width="*%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
			</colgroup>
			<tr>
				<th scope="col">순번</th>
				<th scope="col">구분</th>
				<th scope="col">문서명</th>
				<th scope="col">기안자</th>
				<th scope="col">기안일자</th>
				<th scope="col">반려자</th>
				<th scope="col">반려일자</th>
			</tr>
			<c:choose>
				<c:when test="${list eq null or empty list }">
					<tr><td colspan="7" class="listnodata"><spring:message code="message.result.search.notexist" /></td></tr>
				</c:when>
				 <c:otherwise>
					<c:forEach var="vo" items="${list }" varStatus="i">
						<c:url var="detailUrl" value="detail.do">
							<c:param name="apvlNo" value="${vo.apvlNo }"></c:param>
						</c:url>
						<tr>
							<td><c:out value="${(searchVO.paginationInfo.totalRecordCount-searchVO.paginationInfo.firstRecordIndex-i.count)+1 }" /></td>
							<td class="tleft">${vo.typeVO.catNm }</td>
							<td class="tleft"><a href="javascript:void(0);" onclick="detailApvl('<c:out escapeXml="false" value="${detailUrl }" />')"><c:out escapeXml="false" value="${vo.apvlTitl }"/></a></td>
							<td><c:out value="${vo.regName }" /></td>
							<td><fmt:formatDate value="${vo.regDate }" pattern="${datePattern }"/></td>
							<td><c:out value="${vo.lineVO.apvlUserName }" /></td>
							<td><fmt:formatDate value="${vo.lineVO.apvlLineDate }" pattern="${datePattern }"/></td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</table>
	</div>
</form:form>

<div class="paging_area">
	<ul class="paging">
		<ui:pagination paginationInfo="${searchVO.paginationInfo }" type="image" jsFunction="goPage"/>
	</ul>
</div>

<script type="text/javascript">
$(document).ready(function(){
});

$(document).bind('deptSelect', setDept);

//부서정보 설정
function setDept(evt){
	dept_setSearchDeptData(evt.procType, evt.dept);
}

function goPage(page){
	var url = 'list.do?paginationInfo.currentPageNo='+page+'${listparam}';
	location.href = url;
}

function doSubmit(){
	if(!fn_form_validation(document.forms.searchVO)){
		return false;
	}
	return true;
}

function clickSubmit(){
	$('#searchVO').submit();
}

function changeRecodeCount(){
	$('#searchVO').submit();
}
</script>
