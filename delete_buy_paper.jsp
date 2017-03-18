<!--@author CQQ
	作用：删除某用户的某条订单记录
	传递参数：cno, pno, time
	处理对象：订单表news_sub，报纸销售量表news_count
	查询操作：select, delete, update
	注意：销售量更新
-->

<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%
//链接数据库 
request.setCharacterEncoding("utf-8");//解码方式 
%>
<%@ include file="connect.jsp" %>
<%
	String warning = "";
	String hint = ""; 
	String cno = "";
	//news_count报纸销量表格的值
	int news_num = 0;
	float news_total = 0.0f; 
	
	//获取没有修改之前的订单的订报数量和总价
	int before_num = 0;
	float before_total = 0.0f; 
	///////////////删除用户的一条购买记录///////////
	try{
		  Connection con = DriverManager.getConnection(connectString,user, pwd);
		  cno = request.getParameter("cno");
		  String pno = request.getParameter("pno");
		  String time = request.getParameter("time");
		  
		//获取没有删除之前的订单的订报数量和总价
		 Statement stmt = con.createStatement();
	     String str = "select * from news_sub where cno ='"+ cno+"' and pno = '"+pno+"' and time = '"+time+"';";
	     ResultSet rs = stmt.executeQuery(str);
	     if(rs.next()){
		 	before_num = rs.getInt("num");//修改前的订单的订报数量
		 	before_total = rs.getFloat("total");//订单的总价 
	     }
	     stmt.close();
	     
	     //获取当前的报纸销量和报纸销售金额 
	     Statement stmt2 = con.createStatement();
		 String str2 = "select * from news_count where pno='"+pno+"';"; 
		 ResultSet rs2 = stmt2.executeQuery(str2);
		 if(rs2.next()){
		 	news_num = rs2.getInt("num");//目前的报纸销量 
		 	news_total = rs2.getFloat("total");//目前的报纸销售金额 
		 }
		 stmt2.close();    
	     
		 //执行删除语句 
		 Statement stmt0=con.createStatement();
		 //删除客户购买信息 
		 String str0 = "delete from news_sub where cno =  '"+cno+"' and pno = '"+pno+"' and time='"+time+"';";
		 int rs0 = stmt0.executeUpdate(str0);	
		 //判断是否删除成功 
		 if(rs0>0){
		  	 hint = "删除成功！"; 
			 //更新报纸销量和报纸销售金额 
			 news_num = news_num - before_num ;
			 news_total = news_total - before_total;
			 Statement stmt3 = con.createStatement();
		     String str3 = "update news_count set num = "+news_num+" , total = "+news_total+
			 " where pno ='"+pno+"';";
		     int cnt3 = stmt3.executeUpdate(str3);
		     stmt3.close();
		  }
		  else{
		     hint = "删除失败！"; 
		  }
		  stmt0.close();	
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
<h1 style="text-align: center;">删除用户购买记录</h1>
<div style="text-align: center;"><p><%=hint%></p><div>
<br>
<div align=center> 
	<a href="user_buy_paper.jsp?cno=<%=cno%>">返回</a> 
</div>
</body>
</html>


