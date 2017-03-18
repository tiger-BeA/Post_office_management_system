<!--@author LSW
	作用：报纸信息的删/改操作
	处理对象：news_info , news_count
	查询操作：select， delete，update
	注意：判断提交按键是删除还是修改
-->

<%@ page language="java" contentType="text/html; charset=utf-8"	
	import = "java.util.*,java.sql.*"  pageEncoding="utf-8"%>
<%
	request.setCharacterEncoding("utf-8");
	String pno = request.getQueryString();
	String pna = "", psi = "", pdw = "", msg = "";
	float ppr = 0.0f;
	boolean ifUpdate = false;
%>
<%@ include file="connect.jsp" %>
<%
	if (request.getMethod().equalsIgnoreCase("post")){
		try{
			Connection con = DriverManager.getConnection(connectString,user, pwd);
			if (request.getParameter("updateButton")!=null || request.getParameter("clearButton")!=null){
				ifUpdate = true;
				Statement stmt1 = con.createStatement();
				ResultSet rs1 = stmt1.executeQuery("select * from news_info where pno='"+pno+"';");
				if (rs1.next()){
					pna = rs1.getString("pna");
					ppr = rs1.getFloat("ppr");
					psi = rs1.getString("psi");
					pdw = rs1.getString("pdw");
				}
				rs1.close(); stmt1.close();
			}
			else if (request.getParameter("deleteButton") != null){
				ifUpdate = false;
				Statement stmt1 = con.createStatement();
				int rs1 = stmt1.executeUpdate("delete from news_info where pno='"+pno+"';");
				if (rs1>0){
					out.println("删除成功！  3秒后自动返回");
					out.println("<meta http-equiv=\"refresh\" content=\"1 url=paper_detail.jsp\"> ");
				}
				else{
					out.println("删除失败！  3秒后自动返回");
					out.println("<meta http-equiv=\"refresh\" content=\"1 url=paper_detail_inf.jsp\"> ");
				}
				stmt1.close();
			}
			
			if (request.getParameter("saveButton") != null){
				Statement stmt2 = con.createStatement();
				pna = request.getParameter("pna");
				ppr = Float.parseFloat(request.getParameter("ppr"));
				psi = request.getParameter("psi");
				pdw = request.getParameter("pdw");
				int rs2 = stmt2.executeUpdate("update news_info set pna='"+pna+"', ppr="+ppr+
												",psi='"+psi+"',pdw='"+pdw+"' where pno='"+pno+"';");
				if (rs2>0){
					msg = "保存成功！3秒后自动返回...";
					out.println("<meta http-equiv=\"refresh\" content=\"1 url=paper_detail_inf.jsp?"+pno+"\"> ");
				}
				else{
					msg = "保存失败！3秒后自动返回...";
					out.println("<meta http-equiv=\"refresh\" content=\"1 url=paper_detail.jsp\"> ");
				}
				stmt2.close();
			}
			con.close();
		}catch(Exception e){
			msg = e.getMessage();
		}
	}
%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>修改《<%=pna%>》信息</title>
<style>
	body{
		text-align: center;
	}
</style>
</head>
<body>
<% if (ifUpdate==true){ %>
<h1>修改《<%=pna%>》信息</h1>
<form action="paper_detail_deleteOrUpdate.jsp?<%=pno%>" method="post">
	<p>
		报纸编号：<input name="pno" value="<%=pno%>" readonly="readonly"/> <br/><br/>
		报纸名称：<input name="pna" value="<%=pna%>" required oninvalid="setCustomValidity('请输入报纸名称');" oninput="setCustomValidity('');"/><br/><br/>
		报纸单价：<input name="ppr" value="<%=ppr%>" required oninvalid="setCustomValidity('请输入报纸单价');" oninput="setCustomValidity('');"/><br/><br/>
		版面规格：<input name="psi" value="<%=psi%>" required oninvalid="setCustomValidity('请输入版面规格');" oninput="setCustomValidity('');"/><br/><br/>
		出版单位：<input name="pdw" value="<%=pdw%>" required oninvalid="setCustomValidity('请输入出版单位');" oninput="setCustomValidity('');"/><br/><br/>
		<button type="submit" name="saveButton">保存</button>&nbsp;&nbsp;
		<button type="submit" name="clearButton">重置</button><br><br>
		<a href="http://localhost:8008/data/paper_detail_inf.jsp?<%=pno%>">返回</a>
	</p>
</form>
<%}%>
<%=msg %>

</body>
</html>