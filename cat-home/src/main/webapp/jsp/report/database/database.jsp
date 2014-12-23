<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="a" uri="/WEB-INF/app.tld"%>
<%@ taglib prefix="w" uri="http://www.unidal.org/web/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="res" uri="http://www.unidal.org/webres"%>
<jsp:useBean id="ctx" type="com.dianping.cat.report.page.database.Context" scope="request"/>
<jsp:useBean id="payload" type="com.dianping.cat.report.page.database.Payload" scope="request"/>
<jsp:useBean id="model" type="com.dianping.cat.report.page.database.Model" scope="request"/>

<a:body>
<res:useJs value="${res.js.local['baseGraph.js']}" target="head-js"/>
<div class="report">
	<div class="breadcrumbs" id="breadcrumbs">
	<span class="text-danger title">【报表时间】</span><span class="text-success">&nbsp;&nbsp;${w:format(model.startTime,'yyyy-MM-dd HH:mm:ss')} to ${w:format(model.endTime,'yyyy-MM-dd HH:mm:ss')}</span>
	<!-- #section:basics/content.searchbox -->
	<div class="nav-search nav" id="nav-search">
		<c:forEach var="nav" items="${model.navs}">
			&nbsp;[ <a href="${model.baseUri}?op=view&date=${model.date}&domain=${model.domain}&step=${nav.hours}&product=${payload.product}&timeRange=${payload.timeRange}&${navUrlPrefix}">${nav.title}</a> ]&nbsp;
		</c:forEach>
		&nbsp;[ <a href="${model.baseUri}?${navUrlPrefix}&op=view&product=${payload.product}&timeRange=${payload.timeRange}">now</a> ]&nbsp;
	</div></div>
	<table>
		<tr style="text-align: left">
			<th>
				<div class="navbar-header pull-left position" style="width:350px;">
							<form id="wrap_search" style="margin-bottom:0px;">
								<div class="input-group">
									<input id="search" type="text" value="${payload.product}" class="search-input form-control ui-autocomplete-input" placeholder="input database for search" autocomplete="off"/>
									<span class="input-group-btn">
										<button class="btn btn-sm btn-pink" type="button" id="search_go">
											Go!
										</button> 
									</span>
								</div>
							</form>
						</div>
						
				&nbsp;&nbsp;时间段 
				<c:forEach var="range" items="${model.allRange}">
					<c:choose>
						<c:when test="${payload.timeRange eq range.duration}">
							&nbsp;&nbsp;&nbsp;[ <a href="?op=view&date=${model.date}&domain=${model.domain}&product=${payload.product}&timeRange=${range.duration}" class="current">${range.title}</a> ]
						</c:when>
						<c:otherwise>
							&nbsp;&nbsp;&nbsp;[ <a href="?op=view&date=${model.date}&domain=${model.domain}&product=${payload.product}&timeRange=${range.duration}">${range.title}</a> ]
						</c:otherwise>
						</c:choose>
				</c:forEach>
			</th>
		</tr>
	</table>
    <div class="col-xs-12" style="padding-left:0px;">
       	<c:forEach var="item" items="${model.lineCharts}" varStatus="status">
      			<div style="float:left;">
      				<div id="${item.id}" class="metricGraph"></div>
      			</div>
		</c:forEach>
	</div>
</div>
</a:body>
	
	<script type="text/javascript">
		function databaseChange(){
			var date='${model.date}';
			var domain='${model.domain}';
			var product=$('#search').val();
			var timeRange=${payload.timeRange};
			var href = "?op=view&date="+date+"&domain="+domain+"&product="+product+"&timeRange="+timeRange;
			window.location.href=href;
		}
	
		$(document).ready(function() {
			$('i[tips]').popover();
			$('#System_report').addClass('active open');
			$('#system_database').addClass('active');
			
			$.widget( "custom.catcomplete", $.ui.autocomplete, {
				_renderMenu: function( ul, items ) {
					var that = this,
					currentCategory = "";
					$.each( items, function( index, item ) {
						if ( item.category != currentCategory ) {
							ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
							currentCategory = item.category;
						}
						that._renderItemData( ul, item );
					});
				}
			});
			
			var data = [];
			<c:forEach var="item" items="${model.productLines}">
						var item = {};
						item['label'] = '${item.id}';
						item['category'] = '数据库';
						data.push(item);
			</c:forEach>
					
			$( "#search" ).catcomplete({
				delay: 0,
				source: data
			});
			
			$("#search_go").bind("click",function(e){
				databaseChange();
			});
			$('#wrap_search').submit(
				function(){
					databaseChange();
					return false;
				}		
			);
			
			<c:forEach var="item" items="${model.lineCharts}" varStatus="status">
				var data = ${item.jsonString};
				graphMetricChart(document.getElementById('${item.id}'), data);
			</c:forEach>

			var hide =${payload.hideNav};
			
			if(hide){
				$('.opNav').slideUp();
				$('#switch').html("显示");
			}
		});
		
		function showOpNav() {
			var b = $('#switch').html();
			if (b == '隐藏') {
				$('.opNav').slideUp();
				$('#switch').html("显示");
			} else {
				$('.opNav').slideDown();
				$('#switch').html("隐藏");
			}
		}
	</script>
</script>
