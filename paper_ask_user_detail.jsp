<!--@author LSW
	作用：查询报纸订单中，订阅用户详细信息
	传递参数：cno
	处理对象：customer
	查询操作：select
-->
<%@ page language="java" contentType="text/html; charset=utf-8"
	import = "java.util.*, java.sql.*" pageEncoding="utf-8"%>
<%
	request.setCharacterEncoding("utf-8");	
	String[] queryString = request.getQueryString().split("&");
	String cno = queryString[0];
	String pno = queryString[1];
	String gna = "", gte = "", gad = "", gpo = "";
%>
<%@ include file="connect.jsp" %>
<%
	try{
		Connection con = DriverManager.getConnection(connectString,user, pwd);
		Statement stmt = con.createStatement();
		ResultSet rs = stmt.executeQuery("select * from customer where cno='"+cno+"';");
		if (rs.next()){
			gna = rs.getString("gna");
			gte = rs.getString("gte");
			gad = rs.getString("gad");
			gpo = rs.getString("gpo");
		}
		rs.close(); stmt.close(); con.close();
	}catch(Exception ex){
		ex.printStackTrace();
	}
%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><%=cno%>用户的详细信息</title>
<style>
	body{
			text-align: center;
		}
	table{
		margin:0px auto;
		text-align: center;
	}
	table, th, td{
		border: 1px solid #000;
	}
	th, td{
		padding: 0.5rem 1rem;
	}
	select{
		font-size:1rem;
	}
	button{
		font-size:0.9rem;
	}
</style>
</head>
<body>
<table>
	<caption><h1><%=cno%>用户的详细信息</h1></caption>
	<tr>
		<th>用户名</th>
		<th>客户姓名</th>
		<th>电话</th>
		<th>地址</th>
		<th>邮编</th>
	</tr>
	<tr>
		<td><%=cno%></td>
		<td><%=gna%></td>
		<td><%=gte%></td>
		<td><%=gad%></td>
		<td><%=gpo%></td>
	</tr>
</table>
<br><br>
<a href="paper_detail_inf.jsp?<%=pno%>">返回</a>
</body>
</html>