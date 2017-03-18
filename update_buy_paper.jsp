<!--@author QW
	作用：修改用户购买报纸的信息
	处理对象： news_info, new_table, news_count
	查询操作：select, update
-->

<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%
request.setCharacterEncoding("utf-8");
String warning = "";
String cno = ""; 
String pno = "";
String num = "";
String total = "";
String time = null;
String msg = "";
//news_count报纸销量表格的值
int news_num = 0;
float news_total = 0.0f; 

//获取请求中的内容 
cno = request.getParameter("cno");
pno  = request.getParameter("pno");
num = request.getParameter("num");
total = request.getParameter("total");
time = request.getParameter("time");

//获取没有修改之前的订单的订报数量和总价
int before_num = 0;
float before_total = 0.0f; 

//修改后的订单的订报数量和总价
int after_num = 0;
float after_total = 0.0f; 


//链接数据库 
StringBuilder table=new StringBuilder("");
%>
<%@ include file="connect.jsp" %>
<%
	try{
		 Connection con = DriverManager.getConnection(connectString,user, pwd);
		 //获取没有修改之前的订单的订报数量和总价
		 Statement stmt0 = con.createStatement();
	     String str0 = "select * from news_sub where cno ='"+ cno+"' and pno = '"+pno+"' and time = '"+time+"';";
	     ResultSet rs0 = stmt0.executeQuery(str0);
	     if(rs0.next()){
		 	before_num = rs0.getInt("num");//修改前的订单的订报数量
		 	before_total = rs0.getFloat("total");//订单的总价 
	     }
	     stmt0.close();
	     
	     //修改后的订单的订报数量和总价
		 after_num = Integer.parseInt(num);
		 after_total = Float.parseFloat(total);
		 
		 //执行sql语句，update订单内容 
		 Statement stmt1 = con.createStatement();
	     String str = "update news_sub set cno = '"+cno+"' , pno = '"+pno+"', num = "+num
	     +", total = "+total+", time= '"+time+"' where cno ='"+ cno+"' and pno = '"+pno+"' and time = '"+time+"';";
	     int cnt = stmt1.executeUpdate(str);
	     stmt1.close();
	
	    //执行sql语句，update历史信息内容 
		Statement stmt4 = con.createStatement();
	     String str4 = "update new_table set cno = '"+cno+"' , pno = '"+pno+"', num = "+num
	     +", total = "+total+", time= '"+time+"' where cno ='"+ cno+"' and pno = '"+pno+"' and time = '"+time+"';";
	     int cnt4 = stmt4.executeUpdate(str4);
	     stmt4.close();
	     
	     //改变了订单的内容需要到报纸销售量表格news_count更新订报的数量和总销量
	     //获取当前的报纸销量和报纸销售金额 
	     Statement stmt2 = con.createStatement();
		 String str2 = "select * from news_count where pno='"+pno+"';"; 
		 ResultSet rs2 = stmt2.executeQuery(str2);
		 if(rs2.next()){
		 	news_num = rs2.getInt("num");//目前的报纸销量 
		 	news_total = rs2.getFloat("total");//目前的报纸销售金额 
		 }
		 stmt2.close();
		 
		 //更新报纸销量和报纸销售金额 
		 news_num = news_num - before_num + after_num;
		 news_total = news_total - before_total + after_total;
		 Statement stmt3 = con.createStatement();
	     String str3 = "update news_count set num = "+news_num+" , total = "+news_total+
		 " where pno ='"+pno+"';";
	     int cnt3 = stmt3.executeUpdate(str3);
	     stmt3.close();
		 
	
	     stmt1.close();	
	     con.close();
	}
	catch (Exception e){
		 msg = e.getMessage();
	}
%>

<!DOCTYPE HTML>
<html>
<head>
<title>修改用户购买的报纸</title>
</head>
<body>
	<div class="container" align=center>
		<h1>修改用户购买的报纸</h1>
		<form action="update_buy_paper.jsp" method="post">
用户编号：<input name="cno" id="cno" type="text" value = "<%=cno%>" readonly style="background:#f3f3f3"><br/><br/>
报纸编号：<input name="pno"  id="pno"  type="text" value = "<%=pno%>" readonly style="background:#f3f3f3"><br/><br/>
购买时间：<input name="time"  id="time"  type="text" value = "<%=time%>" readonly style="background:#f3f3f3"><br/><br/> 
订报数量：<input name="num"  id="num"  type="text" value = "<%=num%>" ><br/><br/>
总共价格：<input name="total"  id="total"  type="text" value = "<%=total%>"><br/><br/>
		      <input name="submit1" type="submit" value="修改">     
			  <input name="submit2" type="reset" value="复位">     
			  <input name="submit3" type="reset" onclick="resetInput()" value="清空">
			  <br/><br/>
		</form>
		
<script type="text/javascript">
function resetInput(){
     document.getElementById("cno").setAttribute("value","");           
	 document.getElementById("pno").setAttribute("value",""); 
	 document.getElementById("num").setAttribute("value","");           
	 document.getElementById("total").setAttribute("value",""); 
	 document.getElementById("time").setAttribute("value","");           
}
</script>
		<div align=center> 
			<a href="user_buy_paper.jsp?cno=<%=cno%>">返回</a> 
		</div>
  	</div>
</body>
</html>
