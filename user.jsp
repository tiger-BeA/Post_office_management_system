<!--@author CQQ
	作用：显示某用户的详细信息和订单情况
	处理对象： customer， news_info
	查询操作：select
	传递参数： cno, pno
-->

<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%
request.setCharacterEncoding("utf-8");
String warning = "";
int msg = 0;
String name = null;
String phone = null;
String adress = null;
String post = null;
String user_name = request.getParameter("cno");
String update_url = "\"updateUser.jsp?id="+user_name+"\"";
String sub_url = "\"subUser.jsp?id="+user_name+"\"";
StringBuilder table=new StringBuilder("");

%>
<%@ include file="connect.jsp" %>
<%
	   ///////////////查询用户个人信息///////////
	   try{
		   Connection con = DriverManager.getConnection(connectString,user, pwd);
		   Statement stmt = con.createStatement();
		   ResultSet rs1=stmt.executeQuery("select * from customer where cno='"+user_name+"';");
		  // out.print("select * from customer where cno='"+user_name+"';");
		   if(rs1.next()){
			   name = rs1.getString("gna");
			   phone = rs1.getString("gte");
			   adress = rs1.getString("gad");
			   post = rs1.getString("gpo");
		   }
		   rs1.close();
		   ResultSet rs2=stmt.executeQuery("select * from news_sub where cno='"+user_name+"';");
		   ArrayList<String> news_sub = new ArrayList<String>();//存储订单信息
		   while(rs2.next()){
			   String pno = rs2.getString ("pno");//报纸编号
			   String num = rs2.getString ("num");//订购数量
			   String total = rs2.getString ("total");//总金额
			   String time = rs2.getString ("time");//订购时间
			   news_sub.add(pno+","+num+","+total+","+time);
		   }
		   int row = news_sub.size()+1;
		   table.append("<table border=\"1\" id=\"news\"><caption align=\"top\">已完成订单</caption><tr><th>报纸名称</th>"
		   +"<th>单价</th><th>规格</th><th>出版社</th><th>数量</th><th>总金额</th>"+"<th>订购时间</th><th rowspan="
		   +row+"\">"+"<a href="+sub_url+"id=\"sub\">继续订购</a>"+"</th></tr>");
		   Iterator<String> it1 = news_sub.iterator();
		   for(String temp:news_sub){
	            String str[] = temp.split(",");
	            ResultSet rs3=stmt.executeQuery("select * from news_info where pno='"+str[0]+"';");
	            String pna = null;
	            String ppr = null;
	            String psi = null;
	            String pdw = null;
	            if(rs3.next()){
	            	pna = rs3.getString("pna");//报纸名称
	            	ppr = rs3.getString("ppr");//报纸单价
	            	psi = rs3.getString("psi");//规格
	            	pdw = rs3.getString("pdw");//出版社
	            }
	            table.append(String.format(
						  "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>",
						  pna,ppr,psi,pdw,str[1],str[2],str[3]
						  )
						  );
	            rs3.close();
	        }
		   table.append("</table>");
		   rs2.close();
		   stmt.close();
		   con.close();
	   }catch(Exception e){
		   warning = e.getMessage();
	   }
%>
 

<html>
<head>
<title>用户功能界面</title>
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
<h1 style="text-align: center;">欢迎使用邮政订报系统！</h1>
<div id="information">
  <table border="1" id="person">
  <caption align="top">个人信息</caption>
  <tr>
    <th>ID</th>
    <th>用户名</th>
    <th>电话</th>
    <th>地址</th>
    <th>邮编</th>
    <th>-</th>
  </tr>
  <tr>
    <td><%=user_name %></td>
    <td><%=name %></td>
    <td><%=phone %></td>
    <td><%=adress %></td>
    <td><%=post %></td>
    <td><a href=<%=update_url %> id="update">修改个人信息</a></td>
  </tr>
  </table>
  <br><br><br>
  
  <%=table %>
  <%=warning %>
  <br><br>
</div>
<div align="center"><button type="button" onclick="window.location='Login.jsp'">退出登录</button></div>
 </body>
</html>