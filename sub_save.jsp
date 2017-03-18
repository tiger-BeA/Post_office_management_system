<!--@author QW
	作用：保存订购结果
	处理对象：customer，news_count， news_info, new_table
	查询操作：select, update， insert
	注意：订单产生同时，备份到new_table表中
-->

<%@ page language="java" import="java.util.*,java.sql.*,java.text.*,java.util.Date" 
         contentType="text/html; charset=utf-8"
%>
<%
	request.setCharacterEncoding("utf-8");
	String warning = "";//存储sql语句的报错信息，用于debug
	int msg = 0;
	DecimalFormat df = new DecimalFormat("0.00");
	SimpleDateFormat df2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
	String user_id = request.getParameter("id");  //用户编号
	String count = request.getParameter("count");  //报纸种类
	String array = request.getParameter("array"); //每种报纸的购买量
	String url = "<meta http-equiv=\"refresh\" content=\"1 url=user.jsp?cno="+user_id+"\""+"/>"; //跳转的url
	String [] flag = array.split(",");
	int index = 0;
	double money = 0d;
	//***************************链接到数据库***********************************//
%>
<%@ include file="connect.jsp" %>
<%
   try{
	   Connection con = DriverManager.getConnection(connectString,user, pwd);
	   Statement stmt0 = con.createStatement();
	   Statement stmt = con.createStatement();
	   Statement stmt2 = con.createStatement();
	   Statement stmt3 = con.createStatement();
	   ResultSet temp=stmt.executeQuery("select * from news_count;");
	   int old_num [] = new int [Integer.parseInt(count)];
	   double old_total [] = new double [Integer.parseInt(count)];
	   int i = 0;
	   while(temp.next()){
		   old_num[i] = Integer.parseInt(temp.getString("num"));
		   old_total[i] = Double.parseDouble(temp.getString("total"));
		   i++;
	   }
	   temp.close();
	   
	   ResultSet rs=stmt.executeQuery("select * from news_info;");
	   while(rs.next()){
		  if(!flag[index].equals("0")){
			  String pno = rs.getString("pno");
			  String pna = rs.getString("pna");
			  String psi = rs.getString("psi");
			  String pdw = rs.getString("pdw");
			  String ppr = rs.getString("ppr");
			  ///////更新news_count表也就是该报纸的累计销量和销售额//////
			  String fmt="update news_count set num ='"+(Integer.parseInt(flag[index])+old_num[index])+""+"',total='"+(float)(Integer.parseInt(flag[index])*Double.parseDouble(ppr)+old_total[index])+""+"' where pno='"+pno+"';";//更新数据库
			  //System.out.println(fmt);
 			  boolean cnt = stmt2.execute(fmt);
			  //////将本次购买的订单信息插入到news_sub表中
 			  String fmt2="insert into news_sub(cno,pno,num,total,time) values(\""+user_id+"\",\""+pno+"\",\""+flag[index]
 	 				  +"\",\""+df.format(Double.parseDouble(flag[index])*Double.parseDouble(ppr))+""+"\",\""+df2.format(new Date())+"\")";
 	 		   //System.out.print(fmt);
 			  int cnt2 = stmt2.executeUpdate(fmt2);
 			  //查询购买人的信息
 			 ResultSet rs2=stmt0.executeQuery("select * from customer where cno='"+user_id+"';");
 			 String gna = "";
 			 String gte = "";
 			 String gad = "";
 			 String gpo = "";
 			 if(rs2.next()){
 				gna = rs2.getString("gna");
	 			gte = rs2.getString("gte");
	 			gad = rs2.getString("gad");
	 			gpo = rs2.getString("gpo");
 			 }
 			 rs2.close();
 			 //将本次的订单详细信息插入到backup表中作为订单信息备份，包括购买报纸的信息和购买人的信息，以及购买时间等
 			  String fmt3="insert into backup(pno,pna,ppr,psi,pdw,cno,gna,gte,gad,gpo,num,total,time) values(\""
 			          +pno+"\",\""+pna+"\",\""+ppr+"\",\""+psi+"\",\""+pdw+"\",\""+user_id+"\",\""+gna+"\",\""+gte+"\",\""+gad+"\",\""+gpo
 					 +"\",\""+flag[index]+"\",\""+df.format(Double.parseDouble(flag[index])*Double.parseDouble(ppr))+""+"\",\""+df2.format(new Date())+"\")";
 			 int cnt3 = stmt3.executeUpdate(fmt3);
		  }
		  index++;
	   }
	   rs.close();
	   stmt0.close();
	   stmt.close();
	   stmt2.close();
	   stmt3.close();
   }catch(Exception e){
	   warning = e.getMessage();
	  // out.print(warning);
	   }
%>
<html>
<head>
<title>订购结果</title>
<style>
</style>
</head>
<body>
<%=warning %>
<a style="text-align:center;">购买成功，正在返回...</a>
<%=url %>
</body>
</html>