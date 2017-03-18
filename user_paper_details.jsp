<!--@author CQQ
	作用：管理员页面
	处理对象： customer， news_count
	查询操作：select
	传递参数： cno, pno
-->
<%@ page language="java" contentType="text/html; charset=utf-8"
import="java.util.*,java.sql.*"  pageEncoding="utf-8"%>

<%  request.setCharacterEncoding("utf-8");
	String warning = "";
	StringBuilder table = new StringBuilder();
	String tableString = "";
	String id = ""; 
	String name ="";
	String phone = "";
	String adress = "";
	String post = "";
	StringBuilder table1 = new StringBuilder("");
%>
<%@ include file="connect.jsp" %>
<%
	try{
		Connection con = DriverManager.getConnection(connectString,user, pwd);
		Statement stmt1 = con.createStatement();
		table.append("<table><caption><h1>管理员-报纸订阅</h1></caption><tr><th>报纸编号</th><th>报纸名称</th><th>当前报纸单价</th><th>版面规格</th><th>出版单位</th><th>订报数量</th><th>其他</th></tr>");
		ResultSet rs1=stmt1.executeQuery("select * from news_info;");
		while(rs1.next()){
			Statement stmt2 = con.createStatement();
			ResultSet rs2=stmt2.executeQuery("select * from News_count where pno='"+rs1.getString("pno")+"'");
			String pno_num = "";
			if (rs2.next()){
				pno_num = rs2.getString("num");
			}
	  		table.append(String.format("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></td>",
	  				rs1.getString("pno"),rs1.getString("pna"),String.valueOf(rs1.getFloat("ppr")),rs1.getString("psi"),rs1.getString("pdw"),pno_num,
	  				"<a href='paper_detail_inf.jsp?"+rs1.getString("pno")+"'><详情></a>"
	  			)
	  		);
	  		stmt2.close(); rs2.close();
	 	}
		table.append("</table");
	 	rs1.close(); stmt1.close(); 
	 	 ///////////////查询用户个人信息///////////
	 	Statement stmt3 = con.createStatement();
	 	ResultSet rs3 = stmt3.executeQuery("select * from customer;");
		   table1.append("<tr><td>ID</td>"+
	                 "<td>用户名</td>"+
	                 "<td>电话</td>"+
	                 "<td>地址</td><td>邮编</td><td>-</td></tr>"); 
					
		   while(rs3.next()){
		       //获取数据库中的数据 
		       id = rs3.getString ("cno");//用户ID
			   name = rs3.getString("gna");//用户名字 
			   phone = rs3.getString("gte");//用户电话 
			   adress = rs3.getString("gad");//用户地址 
			   post = rs3.getString("gpo");//用户邮编 
			   //插入table1中 
			   table1.append("<tr>");
		       table1.append("<td>"+id+ "</td>");
		       table1.append("<td>"+name+ "</td>");
	           table1.append("<td>"+phone+ "</td>");
	           table1.append("<td>"+adress+ "</td>");
	           table1.append("<td>"+post+ "</td>");
	           table1.append("<td>"+"<p><a href=\"user_buy_paper.jsp?cno="+id+"\">详情</a>"+"</p></td>");
	           table1.append("</tr>");
		   }
		   rs3.close();
	  	   stmt3.close();
	 	   con.close();
	} catch(Exception e){
		warning = e.getMessage();
	}
%>

<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>管理员-报纸订阅</title>
<style type="text/css">
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
	a{
		text-decoration: none;
	}
	#tag{
		float:left;
		height:100%;
	}
	#tag div{
		height:50%;
		width:4rem;
		font-size: 2rem;
	}
	#user_detail_tag{
		background-color: #aaa;
	}
	#newspaper_detail_tag{
		background-color: #229977;
	}
	#user_detail_tag:hover,#newspaper_detail_tag:hover{
		cursor: pointer;
	}
	#user_detail{
		display: none;
	}
	#addButton{
		margin:0px auto;
		color:#000;
		display:block;
		width:6rem;
		padding:0.3rem;
		border:1px solid #555;
		background-color: #f0f0f0;
		border-radius:0.3rem;
	}
	#addButton:hover{
		color: blue;
	}
</style>
</head>
<body>
	<div id="tag">
		<div id="newspaper_detail_tag">
			报<br>纸<br>管<br>理<br>
		</div>
		<div id="user_detail_tag">
			用<br>户<br>管<br>理<br>
		</div>
	</div>
	
	<div id="newspaper_detail">
		<%=table%>
		<br><br>
		<a id="addButton" href="paper_detail_add.jsp">增加新报纸</a>
	</div>
	
	<div id="user_detail">
	<h1>管理员-用户信息</h1>
       <table border="1">
        <%=table1%>
       </table><br><br>
	</div>
	
	<script>
		var user = document.getElementById("user_detail");
		var news = document.getElementById("newspaper_detail");
		var userTag = document.getElementById("user_detail_tag");
		var newsTag = document.getElementById("newspaper_detail_tag");
		newsTag.onclick = function(){
			user.style.display = "none";
			userTag.style.backgroundColor = "#aaa";
			news.style.display = "block";
			newsTag.style.backgroundColor = "#229977";
		}
		userTag.onclick = function(){
			user.style.display = "block";
			userTag.style.backgroundColor = "#229977";
			news.style.display = "none";
			newsTag.style.backgroundColor = "#aaa";
		}
	</script>
</body>
</html>
