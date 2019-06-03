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
									<i class="fa fa-comments fa-fw"></i> Reply
									<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">
										New Reply
									</button>
								</div>
								<!-- /.panel-heading -->
								<!-- Modal -->
								<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-header">
												<button class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
												<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
											</div>
											<div class="modal-body">
												<div class="form-group">
													<label>Reply</label>
													<input type="text" class="form-control" name="reply" value="New Reply!!!" />
												</div>
												<div class="form-group">
													<label>Replyer</label>
													<input type="text" class="form-control" name="replyer" value="replyer" />
												</div>
												<div class="form-group">
													<label>Reply Date</label>
													<input type="text" class="form-control" name="replyDate" value="" />
												</div>
											</div>
											<div class="modal-footer">
												<button id="modalModBtn" class="btn btn-warning">Modify</button>
												<button id="modalRemoveBtn" class="btn btn-danger">Remove</button>
												<button id="modalRegisterBtn" class="btn btn-primary">Register</button>
												<button id="modalCloseBtn" class="btn btn-default">Close</button>
											</div>
										</div>
										<!-- /.modal-content -->
									</div>
									<!-- /.modal-dialog -->
								</div>
								<!-- /.modal -->
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
								<div class="panel-footer">
								
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
/* sdf */
$(document).ready(function() {
	var bnoValue = '<c:out value="${board.bno}" />'
	var replyUL  = $(".chat");
	var pageNum = 1;
	
	showList(1);
	function showList(page){
		
		replyService.getList({
			url:"/replies/pages/"+bnoValue+"/"+(page||1),
			callback:function(data){
				var replyCnt = data.replyCnt;
				var list = data.list;
				
				if (page == -1) {
					pageNum = Math.ceil(replyCnt/10.0);
					showList(pageNum);
					return;
				}
				
				var str ="";
				if (list == null || list.length == 0) {
					replyUL.html("작성된 글이 없음");
					return;
				}
				for (var i = 0,len = list.length || 0; i < len; i++) {
					str += '<li class="left clearfix" data-rno="'+list[i].rno+'">';
					str += '<div><div class="header"><strong class="primary-font">['+list[i].rno+'] '+list[i].replyer+'</strong>'
					str += '<small class="pull-right text-muted">'+replyService.displayTime(list[i].replyDate)+'</small></div>';
					str += '<p>'+list[i].reply+'</p></div></li>';
				}
				
				replyUL.html(str);
			}
		});
	}
	/* 모달 이벤트 영역 */
	var modal = $(".modal");
	var modalInputReply = modal.find("input[name='reply']");
	var modalInputReplyer = modal.find("input[name='replyer']");
	var modalInputReplyDate = modal.find("input[name='replyDate']");
	
	var modalModBtn = $("#modalModBtn");
	var modalRemoveBtn = $("#modalRemoveBtn");
	var modalRegisterBtn = $("#modalRegisterBtn");
	
	$("#addReplyBtn").click(function(){
		modal.find("input").val("");
		modalInputReplyDate.closest("div").hide();
		modal.find("button[id !='modalCloseBtn']").hide();
		
		modalRegisterBtn.show();
		
		$(".modal").modal("show");
	});
	
	modalRegisterBtn.click(function(e){
		var reply = {
				reply:modalInputReply.val(),
				replyer:modalInputReplyer.val(),
				bno:bnoValue
		};
		replyService.add({
				reply:reply,
				url:'/replies/new'
				,callback:function(result){
					alert(result);
					
					modal.find("input").val("");
					modal.modal("hide");
					
					showList(-1);
				}});
		
	});
	
	$(".chat").on("click","li",function(e){
		var rno = $(this).data("rno");
		
		/* 댓글 호출 */
		replyService.get({
			url:"/replies/"+rno,
			callback:function(reply){
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer)
				.attr("readonly","readonly");
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate));
				modal.data("rno",reply.rno);
				
				modal.find("button[id !='modalCloseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();
				
				$(".modal").modal("show");
			}
		});
		/* 댓글 수정 */
		modalModBtn.click(function(e){
			replyService.update({
				reply:{rno:modal.data("rno"),bno:bnoValue,reply:modalInputReply.val()},
				url:'/replies/'+modal.data("rno"),
				callback:function(result){
					alert(result);
					modal.modal("hide");
					showList(1);
				}
			});
		});
		
		/* 댓글 삭제 */
		modalRemoveBtn.click(function(e){
			replyService.remove({
				url:"/replies/"+modal.data("rno"),
				callback:function(count){
					if (count === "success") {
						alert("REMOVE");
						modal.modal("hide");
						showList(1);
					}
				},
				error:function(err){
					console("에러는?");
					console(err);
					alert("ERROR...");
				}
			});
		});
		
	});
	/* 모달 이벤트 영역 */
	
	/* 페이지 리스트 */
	var replyPageFooter = $(".panel-footer");
	
	function showReplyPage(replyCnt){
		var endNum = Math.ceil(pageNum / 10.0);
	}
	/* 페이지 리스트 */
	
	/* 화면 이동 */	
	var operForm = $('#operForm');
	$("button[data-oper='modify']").click(function(e){
		operForm.attr("actioin","/board/modify").submit();
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