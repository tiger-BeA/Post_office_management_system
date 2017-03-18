<!--@author QW
	作用：保存修改后的用户信息
	处理对象： customer
	查询操作：update
-->

<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%
    request.setCharacterEncoding("utf-8");
    int msg = -1;
    String warning = "";
    String id = request.getParameter("user_id");//id
    
    String url = "\"updateUser.jsp?id="+id+"\"";
    String password = request.getParameter("pwd");//密码
    String Name = request.getParameter("Name");//姓名
    String phone = request.getParameter("phone");//手机号
    String address = request.getParameter("address");//地址
    String post = request.getParameter("post");//邮编
%>
<%@ include file="connect.jsp" %>
<%
    //判断用户修改后的信息是否合法，如果合法那么修改数据库中对应信息并返回，不合法提示用户重新输入
    if(request.getMethod().equalsIgnoreCase("post")){
 	   Connection con = DriverManager.getConnection(connectString,user, pwd);
 	   Statement stmt = con.createStatement();
 	   if(password.equals("")||Name.equals("")||phone.equals("")||address.equals("")||post.equals("")){
 		   //System.out.print("输入存在空值");
 		   msg = 0;
 	   }
 	   else{
 		  try{
 	 		   String fmt="update customer set gna='"+Name+"',gte ='"+phone+"',gad ='"+address+"',gpo ='"+post+"' WHERE cno='"+id+"';";//更新数据库
 	 		   //System.out.print(fmt);
 			   boolean cnt = stmt.execute(fmt);
 	 		   if(!cnt){
 	 			   msg = 1;
 	 		   }
 	 		   else{
 	 			   msg = 0;
 	 		   }
 	 		   stmt.close();
 	 		   con.close();
 	 		   }catch(Exception e){
 	 			   warning = e.getMessage();
 	 			   }   
 	   }
 	}
%>
<!DOCTYPE HTML>
<html>
<head>
<title>个人信息更新结果</title>
</head>
<body>
<%=warning %>
<% 
       if(msg==1){
    	   out.print("<a href="+"\"user.jsp?cno="+id+"\">"+"更新成功，请点击此处返回</a>");
       }
       if(msg==0)
    	   out.print("<p onclick=\"javascript:history.back(-1);\">"+"更新信息不能为空,请点击此处返回</p>"); 
     %>
</body>
</html>