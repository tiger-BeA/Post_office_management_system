<!--@author QW
	作用：在线订购页面
	处理对象：news_info
	查询操作：select
-->

<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%
request.setCharacterEncoding("utf-8");
StringBuilder table=new StringBuilder("");//存储报纸的表格信息
table.append("<table border=\"1\" id=\"news_info\"><caption align=\"top\">可订购报刊列表</caption><tr><th>编号</th>"
		   +"<th>名称</th><th>单价(元/份)</th><th>规格</th><th>出版社</th>"+"<th>购买数量</th>"+"</th></tr>");
String warning = "";
int msg = 0;
int count = 0;
String user_id = request.getParameter("id");  //用户编号
%>
<%@ include file="connect.jsp" %>
<%
	   try{
		   Connection con = DriverManager.getConnection(connectString,user, pwd);
		   Statement stmt = con.createStatement();
		   //查询可供订购的报纸信息插入到表格中供顾客浏览，并提供输入订购数量的输入框
		   ResultSet rs=stmt.executeQuery("select * from news_info;");
		  // out.print("select * from customer where cno='"+user_name+"';");
		   while(rs.next()){
			   table.append(String.format(
						  "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>",
						  rs.getString("pno"),rs.getString("pna"),rs.getString("ppr"),rs.getString("psi"),rs.getString("pdw"),
						  "<input type=\"number\" name=\"points"+count+""+"\" min=\"0\" value=\"0\"/>"
						  )
						  );
			   count++;
		   }
		   table.append("</table>");
		   rs.close();
	   }catch(Exception e){
		   warning = e.getMessage();
		  // out.print(warning);
		   }
%>
<html>
<head>
<title>订购系统</title>
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
   form{
     text-align: center;
   }
</style>
</head>
<body>
  <h1 style="text-align: center;">在线订购页面</h1><br><br>
  <form action="sub_ans.jsp?id=<%=user_id %>&&count=<%=count %>" method="post">
      <%=table %>
      <br><br>
      <input type="submit" name="submit1" value="确认购买"/>
      <input type="submit" name="submit2" value="返回" onclick="javascript:history.back(-1);" /><br><br>
  </form>
</body>
</html>