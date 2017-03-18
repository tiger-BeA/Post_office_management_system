<!--@author LSW
	作用：报纸信息的查询,提交按钮的判断
	处理对象：news_info , news_count
	查询操作：select
	注意：删除按钮点击，是否提交根据弹出确认框的结果决定
-->

<%@ page language="java" contentType="text/html; charset=utf-8"
	import="java.util.*,java.sql.*"
    pageEncoding="utf-8"%>
<%
	request.setCharacterEncoding("utf-8");
	
	String pno = "", pna = "", psi = "", pdw = "";
	float total = 0.0f, ppr = 0.0f;
	int num = 0;
	StringBuilder table_inf = new StringBuilder();
	String table_inf_String = "";
	String[] select = new String[4];
%>
<%@ include file="connect.jsp" %>
<%
	try{
		Connection con = DriverManager.getConnection(connectString,user, pwd);
		pno = request.getQueryString();
		Statement stmt1 = con.createStatement();
		ResultSet rs1 = stmt1.executeQuery("select * from news_info where pno='"+pno+"';");
		if (rs1.next()){
			pna = rs1.getString("pna");
			ppr = rs1.getFloat("ppr");
			psi = rs1.getString("psi");
			pdw = rs1.getString("pdw");
		}
		rs1.close();stmt1.close();
		
		Statement stmt2 = con.createStatement();
		ResultSet rs2 = stmt2.executeQuery("select * from news_count where pno='"+pno+"';");
		if (rs2.next()){
			num = rs2.getInt("num");
			total = rs2.getFloat("total");
		}
		rs2.close(); stmt2.close();
		
		String order = "";
		if (request.getParameter("order_set")!=null){
			String temp = request.getParameter("order");
			if (temp.equals("最新购买时间")){
				order = "order by time ASC;";
				select[0] = "selected";
				select[1] = "";
				select[2] = "";
				select[3] = "";
			}
			else if (temp.equals("最早购买时间")){
				order = "order by time DESC;";
				select[0] = "";
				select[1] = "selected";
				select[2] = "";
				select[3] = "";
			}
			else if(temp.equals("总价由多到少")){
				order = "order by total DESC;";
				select[0] = "";
				select[1] = "";
				select[2] = "selected";
				select[3] = "";
			}
			else{
				order = "order by total ASC;";
				select[0] = "";
				select[1] = "";
				select[2] = "";
				select[3] = "selected";
			}
		}
		Statement stmt3 = con.createStatement();
		ResultSet rs3 = stmt3.executeQuery("select * from news_sub where pno='"+pno+"' "+order);
		while(rs3.next()){
			table_inf.append(String.format("<tr><td>%s</td><td>%s</td><td><a href='paper_ask_user_detail.jsp?%s&%s'>%s</a></td><td>%s</td><td>%s</td></tr>",
					rs3.getString("time"),String.valueOf(rs3.getFloat("total")/rs3.getInt("num")),rs3.getString("cno"),pno,rs3.getString("cno"),
					String.valueOf(rs3.getInt("num")),String.valueOf(rs3.getFloat("total"))));
		}
		table_inf_String = table_inf.toString();
		rs3.close(); stmt3.close();
		con.close();
	}catch(Exception ex){
		ex.printStackTrace();
	}
%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><%=pna%>报纸订阅详情</title>
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
	<caption><h1>《<%=pna%>》订阅详情</h1></caption>
	<tr>
		<th>报纸编号</th>
		<th>报纸名称</th>
		<th>报纸单价</th>
		<th>版面规格</th>
		<th>出版单位</th>
		<th>总销量</th>
		<th>总售额</th>
	</tr>
	<tr>
		<td><%=pno%></td>
		<td><%=pna%></td>
		<td><%=ppr%></td>
		<td><%=psi%></td>
		<td><%=pdw%></td>
		<td><%=num%>份</td>
		<td><%=total%>元</td>
	</tr>
</table>
<br/><br/>
<form name="operation" method="post">
	<button name="updateButton" type="submit" onclick="updateFunc()">修改</button>
	<button name="deleteButton" id="deleteButton" onclick="deleteFunc()">删除</button>
</form>
<br/><br/>
<h2>订单详情</h2>
<form action="paper_detail_inf.jsp?<%=pno%>" method="post">
	按&nbsp;<select name="order">
		<option <%=select[0] %>>最新购买时间</option>
		<option <%=select[1] %>>最早购买时间</option>
		<option <%=select[2] %>>总价由多到少</option>
		<option <%=select[3] %>>总价由少到多</option>
	</select>&nbsp;查看&nbsp;&nbsp;
	<button name="order_set" type="submit">确定</button>
</form>
<table>
	<tr>
		<th>购买时间</th>
		<th>报纸单价</th>
		<th>购买用户</th>
		<th>购买数量</th>
		<th>总价</th>
	</tr>
	<%=table_inf_String %>
</table><br><br>
<a href="paper_detail.jsp">返回</a>

<script>
function deleteFunc(){
	if(delete_rec() == true){
		document.operation.action = "paper_detail_deleteOrUpdate.jsp?<%=pno%>";
		cocument.operation.submit();
	}
}

function updateFunc(){
	document.operation.action = "paper_detail_deleteOrUpdate.jsp?<%=pno%>";
	cocument.operation.submit();
}
function delete_rec(){
	var delete_msg = confirm("请确认是否删除《<%=pna%>》的全部信息？");
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
</script>
</body>
</html>