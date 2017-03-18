<!--@author CQQ
	作用：显示某用户的所有订单和用户信息
	处理对象： customer， news_sub
	查询操作：select
	传递参数： cno,pno
-->
<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%
request.setCharacterEncoding("utf-8");
//订单信息 
String warning = "";
String cno = ""; 
String pno = "";
String time = "";
int num = 0;
float total = 0.0f;

//用户信息 
String gna = "";
String gte = "";
String gad = "";
String gpo = "";
String order = "";

//选择排序的方式 
String[] select = new String[5];

//表格 
StringBuilder table=new StringBuilder("");

%>
<%@ include file="connect.jsp" %>
<%

	   ///////////////用户购买过的报纸///////////
	   try{
		   Connection con = DriverManager.getConnection(connectString,user, pwd);
	   	     //用户信息
			 cno = request.getParameter("cno");
			 Statement stmt0 = con.createStatement();
			 ResultSet rs0 = stmt0.executeQuery("select * from customer where cno = '"+ cno + "' "+";");  
		     if(rs0.next()){
					gna = rs0.getString("gna");
					gte = rs0.getString("gte");
					gad = rs0.getString("gad");
					gpo = rs0.getString("gpo");
			 }
	   		rs0.close();
		    stmt0.close();
		    
		    //点击了改变排序方式的确认按钮 
			if (request.getParameter("order_set")!=null){
				//获取从form的hidden的input传入的cno 
			    cno = request.getParameter("this_cno");
			    //把相应的值放在第一个用户信息表格 
			    Statement stmt4 = con.createStatement();
			    ResultSet rs4 = stmt4.executeQuery("select * from customer where cno = '"+ cno + "' "+";");  
		        if(rs4.next()){
					gna = rs4.getString ("gna");
					gte = rs4.getString("gte");
					gad = rs4.getString ("gad");
					gpo = rs4.getString ("gpo");
			    }
		   	    rs4.close();
				stmt4.close();
				
				//查看选择的顺序是哪一个，并给order赋值相应的内容，用于查询 
				String temp = request.getParameter("order");
				if (temp.equals("最新购买时间")){
					order = "order by time DESC;";
					select[0] = "selected";
					select[1] = "";
					select[2] = "";
					select[3] = "";
					select[4] = "";
				}
				else if (temp.equals("最早购买时间")){
					order = "order by time ASC;";
					select[0] = "";
					select[1] = "selected";
					select[2] = "";
					select[3] = "";
					select[4] = "";
				}
				else if(temp.equals("总价由多到少")){
					order = "order by total DESC;";
					select[0] = "";
					select[1] = "";
					select[2] = "selected";
					select[3] = "";
					select[4] = "";
				}
				else if(temp.equals("总价由少到多")){
					order = "order by total ASC;";
					select[0] = "";
					select[1] = "";
					select[2] = "";
					select[3] = "selected";
					select[4] = "";
				}			
				else {
					order = "order by pno ASC;";
					select[0] = "";
					select[1] = "";
					select[2] = "";
					select[3] = "";
					select[4] = "selected";
				}
			}
		   
		   //按顺序查询用户所买过的报纸 
	   	   Statement stmt = con.createStatement();
		   ResultSet rs=stmt.executeQuery("select * from news_sub where cno = '"+ cno + "' "+order+";");
 		   table.append("<tr><td>报纸编号</td>"+
	                 "<td>购买数量</td>"+
	                 "<td>总价格</td>"+
					 "<td>购买时间</td><td> - </td></tr>"); 
			

		   while(rs.next()){
				pno = rs.getString ("pno");//报纸编号 
				num = rs.getInt ("num");//购买数量 
				total = rs.getFloat ("total");//总价格 
				time = rs.getString ("time");//购买时间 
				

				
			   table.append("<tr>");
		       table.append("<td>"+pno + "</td>");
		       table.append("<td>"+num+ "</td>");
	           table.append("<td>"+total+ "</td>");
	           table.append("<td>"+time+ "</td>");
	           //把主键都作为参数传递给函数，跳转到另一个界面去执行sql语句 
	           table.append("<td>"+
			   "<form name=\"operation\" method=\"post\"> "+
				   "<button name=\"updateButton\" type=\"button\" onclick=\"updateFunc('"+pno+"',"+num+","+total+",'"+time+"')\">修改</button>"+"  " +
				   "<button name=\"deleteButton\" type=\"button\" onclick=\"deleteFunc2('"+pno+"','"+time+"')\">删除</button>"+
				   "</form></td>");
				table.append("</tr>");
		   }
           rs.close();
	  	   stmt.close();
	       con.close();
	   }
	   catch(Exception e){
		  warning = e.getMessage();
	   }

%>
 

<html>
<head>
<title> <%=gna%> 顾客报纸订阅详情</title>
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

<table border="1">
	<caption><h1><%=gna%>顾客信息</h1></caption>
	<tr>
		<th>ID</th>
		<th>姓名</th>
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
</table><br>

<form name="operation" method="post">
	<button name="deleteButton" id="deleteButton" onclick="deleteFunc()">删除</button>
</form>


<h1><%=gna%>顾客购买记录</h1>
<form action="user_buy_paper.jsp" method="post">
	按&nbsp;<select name="order">
		<option <%=select[0] %>>最新购买时间</option>
		<option <%=select[1] %>>最早购买时间</option>
		<option <%=select[2] %>>总价由多到少</option>
		<option <%=select[3] %>>总价由少到多</option>
		<option <%=select[4] %>>报纸编号顺序</option>
	</select>&nbsp;查看&nbsp;&nbsp; 
	<input name="this_cno" value=<%=cno%> type="hidden">
	<button name="order_set" type="submit">确定</button>
</form>

<div id="information">
  <table border="1" id="user_buy_paper">
  <%=table%>
  </table>
  <br><br>
</div>
<div align="center"><a href="user_paper_details.jsp">返回</a></div><br>

<script>
//跳转到update界面，url中含有所有主键的信息 
function updateFunc(pno,num,total,time){
	window.location.href = "update_buy_paper.jsp?cno=<%=cno %>&pno="+pno+"&num="+num+"&total="+total+"&time="+time; 
}
//弹框，进行管理员身份确认后才能删除用户信息内容 
function delete_rec(){
	var delete_msg = confirm("请确认是否删除客户<%=gna%>的全部信息？");
	if (delete_msg){
		while(1){
			var password = prompt("请输入您的密码进行确认:");
			if(password == null){
				return false;
			}
			else if(password == "admin"){
				return true;
			}
			else
			{
			   alert("密码错误请重新输入！");
			}
		}
	}
	return false;	
}

//跳转到delete用户的界面，删除用户信息 
function deleteFunc(){
	if(delete_rec() == true){
		document.operation.action = "delete_user.jsp?cno=<%=cno%>";
		document.operation.submit(); 
	}
}

//弹框，进行管理员身份确认后才能删除订单内容 
function delete_rec2(){
	var delete_msg = confirm("请确认是否删除这一条购买记录？");
	if (delete_msg){
		while(1){
			var password = prompt("请输入您的密码进行确认:");
			if(password == null){
				return false;
			}
			else if(password == "admin"){
				return true;
			}
			else
			{
			   alert("密码错误请重新输入！");
			}
		}
	}
	return false;	
}
//跳转到delete订单的界面，删除订单信息 
function deleteFunc2(pno,time){
	if(delete_rec2() == true){
		window.location.href = "delete_buy_paper.jsp?cno=<%=cno %>&pno="+pno+"&time="+time; 
	}
}

</script>
</body>
</html>


