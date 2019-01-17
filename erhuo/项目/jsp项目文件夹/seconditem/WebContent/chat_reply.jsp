<%@ page language="java" pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link rel="stylesheet" type="text/css" href="blackbox/css/blackbox.css" media="screen"/>
<script type="text/javascript" src="blackbox/js/jquery.blackbox.min.js"></script>
<script>
function sendmess(a,b,n){
    $.post("chat_back.jsp?type=sendmess",
    {
    	from:a,
    	to:b,
    	mess:n
    },
    function(data,status){
    });
  }
 
function popchat(a,b,c) {
	var box = new BlackBox();
    box.prompt("", function (data) {
        if (data) {
			sendmess(a,b,data);
            box.alert("消息发送成功");
        }
    }, {
        title: 'To：'+c,
        value: '发送',
        verify: function (data) {
            return data!=null;
        }
    })
}
</script>