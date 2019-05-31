"use strict";
console.log("Reply Module")
var replyService = (function(){
	
	function basicAjax(info){
		$.ajax({
			type:info.type,
			url:info.url,
			data : JSON.stringify(info.reply||""),
			contentType : "application/json; charset=utf-8",
			success : function(result,  status, xhr){
				if (info.callback) info.callback(result);
			},
			error: function(xhr,status,er){
				if (info.error) info.error(er);
			}
		});
	}
	function getAjax(info){
		$.getJSON(info.url,
			function(data){
				if (info.callback) info.callback(data);
			}).fail(function(xhr,status,err){
				if (info.error) info.error(err);
			})
	}
	
	function add(info){
		info.type = "post";
		basicAjax(info);
	}
	function  getList(info){
		getAjax(info);
	}
	function remove(info){
		info.type = "delete";
		basicAjax(info);
	}
	function update(info){
		info.type = "put";
		basicAjax(info);
	}
//	sdf
	function get(info){
		getAjax(info);
	}
	function displayTime(timeValue){
		console.log("hh");
		console.log(timeValue);
		var today = new Date();
		
		var gap = today.getTime() - timeValue;
		console.log("뺀거");
		console.log(gap);
		var dateObj = new Date(timeValue);
		console.log(dateObj);
		var str = "";
		
		if (gap < (1000 * 60 * 60 * 24)) {
			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();
			
			return [(hh > 9 ? '' : '0') + hh,':',(mi > 9 ? '' : '0')+mi,
				':',(ss > 9 ? '' : '0')+ss].join('');
		}else{
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth() +1;
			var dd = dateObj.getDate();
			
			return [yy,'/',(mm> 9 ? '':'0')+mm,'/',
				(dd > 9 ? '' : '0')+dd].join('');
		}
	}
	
	return {add:add,
		getList:getList,
		remove:remove,
		update:update,
		get:get,
		displayTime:displayTime};
})();