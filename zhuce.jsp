<!--@author QW & LSW
	作用：注册请求
	处理对象： customer， loginin， userId_produce
	查询操作：select， insert
	注意：用户ID即cno是系统自动生成的，由userId_produce表中属性值组合得到
-->

<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%request.setCharacterEncoding("utf-8");
	StringBuilder UserID_Builder = new StringBuilder();
	String UserId = "",pre = "";
	short post = 0;
%>
<%@ include file="connect.jsp" %>
<%
    try{
    	Connection con = DriverManager.getConnection(connectString,user, pwd);
  	    Statement stmt1 = con.createStatement();
  	    ResultSet rs1 = stmt1.executeQuery("Select * from userId_produce;");
  	    if (rs1.next()){
  	    	pre = rs1.getString("prefix_letter");
  	    	post = rs1.getShort("postfix_num");// SmallInt类型
  	    	UserID_Builder.append(pre);
  			for (int i=0; i<5-String.valueOf(post).length(); i++){
  				UserID_Builder.append("0");
  			}
  			UserID_Builder.append(String.valueOf(post));// 数字固定为5位，不够前面补0
  	    }
  	  	UserId = UserID_Builder.toString();
  	  	rs1.close();stmt1.close();con.close();
    }catch(Exception ex){
    	ex.printStackTrace();
    }
%>
<html>
<head>
<title>注册</title>
<style>
  div{
    text-align: center;
    width: 320px;
    border:1px solid #000;
    margin: 0 auto;
    padding: 20px;
  }
  span{
    color: blue;
    text-decoration: underline;
  }
  span:hover{
    color: red;  
  }
  form{
  	text-align:right;
  	position: relative;
  	margin-right:40px;
  	padding-bottom:20px;
  }
  form #submit1{
  	position:absolute;
  	left:170px;
  	bottom:0px;
  }
</style>
<script>
function isValid(){
	var flag = true;
	var phoneRole = /^1(3|4|5|7|8)\d{9}$/;
	var TelRole = /^1(3|4|5|7|8)\d{9}$/;
	var postRole = /^[1-9][0-9]{5}$/;
	var phone = document.update.phone.value;
	var post = document.update.post.value;
	if (document.update.pwd.value != document.update.pwd2.value){
		alert("密码输入不一致，请确认");
		flag = false;
	}
	else if (!(phoneRole.test(phone) || TelRole.test(phone))){
		alert("无效的手机号码，请重填");
		flag = false;
	}
	else if (!(postRole.test(post))){
		alert("无效的邮编，请重填");
		flag = false;
	}
	return flag;
}
</script>
</head>
<body>
  <h1 style="text-align: center;">用户注册界面</h1>
  <div id="container">
  <form name="update" action="zhuce_ans.jsp"  method="post" onsubmit="return isValid();">
     用户名：<input type="text" name="name" value="<%=UserId%>" readonly> <br><br>
     密码： <input type="password" name="pwd" value="" required oninvalid="setCustomValidity('请输入密码');" oninput="setCustomValidity('');"/><br><br>
     确认密码： <input type="password" name="pwd2" value="" required oninvalid="setCustomValidity('请再次输入密码');" oninput="setCustomValidity('');"/><br><br>
     姓名：  <input type="text" name="Name" value="" required oninvalid="setCustomValidity('请输入姓名');" oninput="setCustomValidity('');"/><br><br>
     电话：  <input type="text" name="phone" value="" required oninvalid="setCustomValidity('请输入电话');" oninput="setCustomValidity('');"/><br><br>
     地址：  <input type="text" name="address" value="" required oninvalid="setCustomValidity('请输入地址');" oninput="setCustomValidity('');"/><br><br>
     邮编：  <input type="text" name="post" value="" required oninvalid="setCustomValidity('请输入邮编');" oninput="setCustomValidity('');"/><br><br>
   <input type="submit" name="submit1" id="submit1" value="注册"/>
  </form>
  <span onclick="window.location='Login.jsp?'">已有账号？去登录</span>
  </div>


</body>
</html>