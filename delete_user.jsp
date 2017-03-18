<!--@author CQQ
	作用：删除某用户的所有信息
	传递参数：cno
	注意：有外键约束
	处理对象：customer，news_sub， loginin
	查询操作：select, delete
	注意：外键约束与销售量更新
-->

<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%
request.setCharacterEncoding("utf-8");
%>
<%@ include file="connect.jsp" %>
<%
	String warning = "";
	String name = "";
	String id = "";
	String hint = "";
	///////////////删除用户///////////
	try{
		Connection con = DriverManager.getConnection(connectString,user, pwd);
		  //执行删除语句 
		  id = request.getParameter("cno");
		  String user_name = null;
		  Statement stmt=con.createStatement();
		  String find_name = "select gna from customer where cno = '"+id+"';" ;
		  ResultSet rs=stmt.executeQuery(find_name);
		  if(rs.next()){
			   name = rs.getString("gna");//用户名字 
		   }
		  //外键约束 
		  //删除客户购买信息 
		  Statement stmt0 = con.createStatement();
		  String str0 = "delete from news_sub where cno =  '"+id+"' ;";
		  stmt0.execute(str0);
		  //删除客户信息 
		  Statement stmt1=con.createStatement();
		  String str1 = "delete from customer where cno =  '"+id+"';";
		  stmt1.execute(str1);
		  //删除客户
		  Statement stmt2=con.createStatement();
		  String str2 = "delete from loginin where cno =  '"+id+"';";
		  int rs2 = stmt2.executeUpdate(str2);	
		  //判断是否删除成功	   
		  if (rs2>0){
			 hint = "删除成功！";
		  }
		  else{
			 hint = "删除失败！";	
		  }		  
		  stmt2.close();
		  stmt1.close();
		  stmt0.close();
		  stmt.close();	
		  con.close();
	}
	catch(Exception e){
	  	 warning = e.getMessage();
	}
%>
 
<html>
<head>
<title>管理员页面</title>
<style>
   th,td{
      text-align: center;
      width: 120px; 
      height: 21px;
      valign: middle;
   }
   table {
     margin: 0px auto;
   }
   a{
      text-align: center;
   }
   button{
     margin: 0px 47%;
   }
</style>
</head>
<body>
<br><br><br><br><br>
<h1 style="text-align: center;">删除用户<%=name%></h1>
<div style="text-align: center;"><p><%=hint%></p><div>
<br>
<p style="text-align: center;"><a href="user_paper_details.jsp">返回</a></p> 
</body>
</html>
