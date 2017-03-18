<!--@author QW
	作用：检查登陆信息
	传递参数：cno
	处理对象：loginin
	查询操作：select
-->

<%@ page language="java" import="java.util.*,java.sql.*,java.util.Date,java.text.*" 
         contentType="text/html; charset=UTF-8"
%>
<%
	request.setCharacterEncoding("utf-8");
	String msg_temp = "";
	int flag = 0;
	int if_time = 0;//判断当前时间是否为系统维护时间
	String button1 = request.getParameter("submit1");
	String button2 = request.getParameter("submit2");
	String user_name = request.getParameter("name");
	String user_pwd = request.getParameter("pwd");
	
	Date time=new Date();
	SimpleDateFormat format=new SimpleDateFormat("HH");
	String x=format.format(time);
	if(Integer.parseInt(x)>=0&&Integer.parseInt(x)<7)if_time = 1;
	else
		if_time = 0;
	
		String msg ="";
%>
<%@ include file="connect.jsp" %>
<%
	if(button1!=null){
		try{
			  Connection con = DriverManager.getConnection(connectString,user, pwd);
			  Statement stmt=con.createStatement();
			  ResultSet rs=stmt.executeQuery("select user_pwd from loginin where cno=\""+user_name+"\"");
			  if(!rs.next()){
				  flag = -1;
			  }
			  else{
				  String passwd=rs.getString("user_pwd");
				  if(passwd.equals(user_pwd))flag = 1;
				  else
					  flag = 0;
			  }
			  rs.close();
			  stmt.close();
			  con.close();
			}
			catch (Exception e){
			  msg = e.getMessage();
			}
	}
	if(button2!=null){
		//管理员登录模式
		if(user_name.equals("admin") && user_pwd.equals("admin"))flag=2; 
		else
			flag = -1;
	}
    if(if_time==0){
  	  if(flag==-1||flag==0){
    	    msg_temp = "<a href=\""+"Login.jsp\">"+"用户名或者密码错误,点击此处返回</a>";
          }
    	 if(flag==1&&button1!=null){
    		 msg_temp = "<a style=\"display: block;\">"+"用户身份验证成功，正在跳转...</a>";
    		 out.print("<meta http-equiv=\"refresh\" content=\"1 url=user_name.jsp?cno="+user_name+"\">");
    	 } 
    }
    else{
  	  msg_temp = "<a href=\""+"Login.jsp\">"+"每日0点至6:59为系统维护时间，请在7:00至23:59时间段内登录</a>";
    }
    if(flag==2&&button2!=null){
    		 msg_temp = "<a>"+"管理员身份验证成功，正在跳转...</a>";
    		 out.print("<meta http-equiv=\"refresh\" content=\"1 url=user_paper_details.jsp\"> ");
    	 }
%>
<html>
<head>
<title>登录状态</title>
<style type="text/css">
body{
text-aligin:center;
}
</style>
</head>
<body>
<%=msg_temp %>
</body>
</html>