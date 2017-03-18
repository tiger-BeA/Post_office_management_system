<!--@author LSW
	作用：新添报纸
	处理对象：news_info , news_count
	查询操作：insert
	注意：报纸销售量表的insert操作和初始化
-->
<%@ page language="java" contentType="text/html; charset=utf-8"
    import = "java.util.*,java.sql.*" pageEncoding="utf-8"%>
<%
	request.setCharacterEncoding("utf-8");
	String pno = "", pna = "", psi = "", pdw = "", msg = "";
	float ppr = 0.0f;
%>
<%@ include file="connect.jsp" %>
<%
	if (request.getMethod().equalsIgnoreCase("post"))
	{
		if (request.getParameter("saveButton") != null){
			pno = request.getParameter("pno");
			pna = request.getParameter("pna");
			psi = request.getParameter("psi");
			pdw = request.getParameter("pdw");
			ppr = Float.parseFloat(request.getParameter("ppr"));
			try{
				Connection con = DriverManager.getConnection(connectString,user, pwd);
				Statement stmt1 = con.createStatement();
				int rs1 = stmt1.executeUpdate("Insert into news_info values('"+pno+"','"+pna+"',"+ppr+",'"+psi+"','"+pdw+"')");
				Statement stmt2 = con.createStatement();
				int rs2 = stmt2.executeUpdate("Insert into news_count values('"+pno+"',0,0.0)");
				if (rs1>0 && rs2>0){
					msg = "保存成功！3秒后自动返回...";
					out.println("<meta http-equiv=\"refresh\" content=\"1 url=paper_detail.jsp\"> ");
				}
				else{
					msg = "保存失败！请重试";
				}
				stmt1.close();stmt2.close();
			}catch(Exception ex){
				msg = ex.getMessage();
			}
		}
		else if (request.getParameter("clearButton") != null){
			pno = "";
			pna = "";
			psi = "";
			pdw = "";
			ppr = 0.0f;
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>添加新报纸</title>
<style>
body{
	text-align: center;
}
</style>
</head>
<body>
<h1>添加新报纸</h1>
<form action="paper_detail_add.jsp" method="post">
	<p>
		报纸编号：<input name="pno" value="<%=pno%>" required oninvalid="setCustomValidity('请输入报纸编号');" oninput="setCustomValidity('');"/> <br/><br/>
		报纸名称：<input name="pna" value="<%=pna%>" required oninvalid="setCustomValidity('请输入报纸名称');" oninput="setCustomValidity('');"/><br/><br/>
		报纸单价：<input name="ppr" value="<%=ppr%>" required oninvalid="setCustomValidity('请输入报纸单价');" oninput="setCustomValidity('');"/><br/><br/>
		版面规格：<input name="psi" value="<%=psi%>" required oninvalid="setCustomValidity('请输入版面规格');" oninput="setCustomValidity('');"/><br/><br/>
		出版单位：<input name="pdw" value="<%=pdw%>" required oninvalid="setCustomValidity('请输入出版单位');" oninput="setCustomValidity('');"/><br/><br/>
		<button type="submit" name="saveButton">保存</button>&nbsp;&nbsp;
		<button type="submit" name="clearButton">清空</button><br><br>
		<a href="http://localhost:8008/data/paper_detail.jsp">取消</a>
	</p>
</form>
<br><br>
<%=msg %>
</body>
</html>