<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file = "../includes/header.jsp" %>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Tables</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Read Page</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
					<div class="form-group">
						<label>Bno</label>
						<input class="form-control" name="bno" value='<c:out value="${board.bno }" />' readonly="readonly"/>
					</div>
					<div class="form-group">
						<label>Title</label>
						<input class="form-control" name="title" value='<c:out value="${board.title}" />' readonly="readonly"/>
					</div>
					<div class="form-group">
						<label>Title</label>
						<textarea name="content" class="form-control" rows="3" readonly="readonly" >
							<c:out value="${board.content}" />
						</textarea>
					</div>
					<div class="form-group">
						<label>Writer</label>
						<input class="form-control" name="writer" value='<c:out value="${board.writer }" />' readonly="readonly" />
					</div>
					
					<button data-oper='modify' class="btn btn-default" 
					onclick="location.href='/board/modify?bno=<c:out value="${board.bno}" />'">Modify</button>
					
					<button data-oper='list' class="btn btn-info"
					onclick="location.href='/board/list'">List</button>
					
					<form action="/board/modify" id="operForm" method="get">
						<input type="hidden" id="bno" name="bno" value='<c:out value="${board.bno }" />' />
						<input type="hidden" id="pageNum" name="pageNum" value='<c:out value="${cri.pageNum }" />' />
						<input type="hidden" id="amount" name="amount" value='<c:out value="${cri.amount }" />' />
						<input type="hidden" id="keyword" name="keyword" value='<c:out value="${cri.keyword }" />' />
						<input type="hidden" id="type" name="type" value='<c:out value="${cri.type }" />' />
					</form>
					<br />
					<div class="row">
						<div class="col-lg-12">
							<!-- /.panel -->
							<div class="paner panel-default">
								<div class="panel-heading">
									<i class="fa fa-coments fa-fw">Reply</i>
								</div>
								<!-- /.panel-heading -->
								<div class="panel-body">
									<ul class="chat">
										<li class="left clearfix" data-rno="12">
											<div>
												<div class="header">
													<strong class="primary-font">user00</strong>
													<small class="pull-right text-muted">2019-05-31 15:48</small>
												</div>
												<p>Good job !</p>
											</div>
										</li>
										<!-- end reply -->
									</ul>
									<!-- /. end  ul -->
								</div>
								<!-- /.panel .chat-panel -->
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!--  end panel-body -->
	</div>
	<!-- end panel -->
<!-- /.row -->
<script type="text/javascript" src="/resources/js/reply.js"></script>
<script>
$(document).ready(function() {
	var bnoValue = '<c:out value="${board.bno}" />'
	var replyUL  = $(".chat");
	
	showList(1);
	function showList(page){
		replyService.getList({
			url:"/replies/pages/"+bnoValue+"/"+page,
			callback:function(list){
				var str ="";
				if (list == null || list.length == 0) {
					replyUL.html("작성된 글이 없음");
					return;
				}
				for (var i = 0,len = list.length || 0; i < len; i++) {
					str += '<li class="left clearfix" data-rno="'+list[i].rno+'">';
					str += '<div><div class="header"><strong class="primary-font">'+list[i].replyer+'</strong>'
					str += '<small class="pull-right text-muted">'+replyService.displayTime(list[i].replyDate)+'</small></div>';
					str += '<p>'+list[i].reply+'</p></div></li>';
				}
				replyUL.html(str);
			}
		});
	}
	//for replyService add test
	replyService.add({
		reply:{reply:"JS TEST",replyer:"tester",bno:bnoValue},
			url:'/replies/new'
			,callback:function(list){
				
			}});
	var operForm = $('#operForm');
	$("button[data-oper='modify']").click(function(e){
		operForm.attr("actioin","/board/modify").submit();
	});
	/* replyService.remove({
		url:"/replies/"+22,
		callback:function(count){
			if (count === "success") {
				alert("REMOVE");
			}
		},
		error:function(err){
			alert("ERROR...");
		}
	}); */
	replyService.update({
		reply:{rno:34,bno:bnoValue,reply:"Modified Reply...."},
		url:'/replies/'+34,
		callback:function(result){
			alert("수정완료");
		}
	});
	replyService.get({
		url:"/replies/"+10,
		callback:function(data){
			console.log(data);
		}
	});
	$("button[data-oper='list']").click(function(e){
		operForm.find("#bno").remove();
		operForm.attr("action","/board/list");
		console.log(operForm);
		operForm.submit();
	});
})

</script>
<%@ include file="../includes/footer.jsp" %>