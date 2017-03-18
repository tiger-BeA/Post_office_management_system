<!--@author QW
	作用：用户/管理员登陆
-->
<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<html>
<head>
<title>登陆</title>
<style>
  div{
    text-align: center;
    width: 250px;
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
</style>
</head>
<body>
  <h1 style="text-align: center;">在线邮局订报系统</h1>
  <div id="container">
  <form  action="login_ans.jsp" method="post" name="myform">
     用户名：<input type="text" name="name"/><br><br>
     密码：  <input type="password" name="pwd"/><br><br>
   <input type="submit" name="submit1" value="用户登陆"/>
   <input type="submit" name="submit2" value="管理员登录"/><br><br>
  </form>
  <span onclick="window.location='zhuce.jsp'">还没有账号？去注册</span>
  </div>
</body>
</html>