<!--@author QW & LSW
	作用：注册响应
	处理对象： customer， loginin， userId_produce
	查询操作：select， insert, delete
	注意：更新userId_produce表中属性值
-->

<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%
    request.setCharacterEncoding("utf-8");
    int msg = -1;
    String warning = "";
    //通过表单提交获得用户输入的注册信息'
    String name = request.getParameter("name");//id
    String password = request.getParameter("pwd");//密码
    String Name = request.getParameter("Name");//姓名
    String phone = request.getParameter("phone");//手机号
    String address = request.getParameter("address");//地址
    String postcode = request.getParameter("post");//邮编
%>
<%@ include file="connect.jsp" %>
<%
    if(request.getMethod().equalsIgnoreCase("post")){
 	   Connection con = DriverManager.getConnection(connectString,user, pwd);
 	   Statement stmt = con.createStatement();
 	   //如果注册信息合法则插入数据库，否则提示用户重新输入，同时判断用户id不可重复
 	   try{
 		   String sql="insert into loginin(cno,pwd) values(\""+name+"\",\""+password+"\")";
 		   int cnt = stmt.executeUpdate(sql);
 		   if(cnt>0){
 			   msg = 1;
 		   }
 		   else{
 			  msg = 0;
 		   }
 		  String sql2="insert into customer(cno,gna,gte,gad,gpo) values(\""+name+"\",\""+Name+"\",\""+phone
 				  +"\",\""+address+"\",\""+postcode+"\")";
 		  int cnt2 = stmt.executeUpdate(sql2);
		  if(cnt2<0){
 			 msg = -1;
 		  }
 		  stmt.close();
 		  Statement stmt2 = con.createStatement();
 		  ResultSet rs2 = stmt2.executeQuery("Select * from userId_produce;");
 		  short post = 0;
 		  String pre = "";
 		  if (rs2.next()){
	    	 if (post < 32768){// 2^15即short的最大值
	    	 	post++;
	    		sql = "Update userId_produce set postfix_num="+post+" where prefix_letter='"+pre+"';";
	    		int es = stmt2.executeUpdate(sql2);
	    		if (es < 0){
	    			msg = 0;	
	    		}
	    	 }
	    	 else{
	    		int len = pre.length();
	    		if (pre.charAt(len) != 'Z'){
	    			char c = (char)((int)pre.charAt(len) + 1);// 'A'+1
	    			pre = pre.substring(0, len-1).concat(String.valueOf(c));
	    		}
	    		else{
	    			pre = pre+"A";
	    		}
	    		sql = "Delete from userId_produce where 1=1; Insert into userId_produce Values('"+pre+"','00001');";
	    		Statement stmt3 = con.createStatement();
	    		int es2 = stmt3.executeUpdate(sql);
	    		if (es2 < 0){
	    			msg = 0;
	    		}
	    	 }
 		  }
	   	  stmt2.close();con.close();
	}catch(Exception e){
	   	warning = e.getMessage();
	}
}
%>
<!DOCTYPE HTML>
<html>
<head>
<title>注册结果</title>
<style>
</style>
</head>
<body>
  <div class="container" style="text-align: center;">
     <%
       if(msg==1){
    	   out.print("<a href="+"\"user.jsp?cno=name\">"+"注册成功，请点击此处跳转</a>");
       }
       else if(msg==0){
    	   out.print("<a href="+"\"zhuce.jsp\">"+"注册失败，该用户ID已存在，请点击此处返回</a>");
       }
       else
    	   out.print("<a href="+"\"zhuce.jsp\">"+"个人信息不能为空</a>"); 
     %>
  </div>
</body>
</html>