<!--@author QW
	作用：修改用户信息
	处理对象： customer， login
	查询操作：select
-->

<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%
request.setCharacterEncoding("utf-8");
String msg = "";
String id = request.getParameter("id");
String url = "\"updateUser_ans.jsp?user_id="+id+"\"";
String password = null;
String name = null;
String phone = null;
String address = null;
String post = null;
%>
<%@ include file="connect.jsp" %>
<%
   try{
	   Connection con = DriverManager.getConnection(connectString,user, pwd);
	   Statement stmt = con.createStatement();
	   //从数据库中查询用户的相关信息作为初始值提供在修改框中
	   String fmt="select * from customer where cno='"+id+"'";
	   String fmt2="select * from loginin where cno='"+id+"'";
	   ResultSet rs=stmt.executeQuery(fmt);
	   if(rs.next()){
		   name = rs.getString("gna");
		   phone = rs.getString("gte");
		   address = rs.getString("gad");
		   post = rs.getString("gpo");
	   }
	   rs.close();
	   ResultSet rs2=stmt.executeQuery(fmt2);
	   if(rs2.next())password = rs2.getString("pwd");		   
	   rs2.close();		 
	   stmt.close();
	   con.close();
	   }
   catch(Exception e){
		   msg = e.getMessage();
		   
   }
%>
<html>
<head>
<title>修改用户信息</title>
<style>
  div{
    text-align: center;
    width: 300px;
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
  <h1 style="text-align: center;">修改个人信息</h1>
  <div id="container">
  <%=msg %>
  <form action=<%=url %>  method="post" name="update" onsubmit="return validate();">
       新密码：&nbsp;<input type="password" name="pwd" value=<%=password %> required/><br><br>
       确认密码：<input type="password" name="enpwd" value=<%=password %> required/><br><br>
       姓名：&nbsp;&nbsp;<input type="text" name="Name" value=<%=name %> required/><br><br>
       电话：&nbsp;&nbsp;<input type="text" name="phone" value=<%=phone %> required/><br><br>
       地址：&nbsp;&nbsp;<input type="text" name="address" value=<%=address %> required/><br><br>
       邮编：&nbsp;&nbsp;<input type="text" name="post" value=<%=post %> required/><br><br>
   <input type="submit" class="submit1" name="submit1" value="修改" />
   <input type="button" class="submit1"  name="submit2" value="返回" onclick="javascript:history.back(-1);"/>
  </form>
  <script language="javascript">
    function validate(){
    	if(document.update.pwd.value!=(document.update.enpwd.value)){
    		alert("两次密码输入不一致，请确认");
    		return false;
    	}
    	return true;
    }
  </script>
  </div>
</body>
</html>