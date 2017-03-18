<!--@author LSW
	作用：建立数据库连接
-->
<%
	String connectString = "jdbc:mysql://172.18.59.232/newspaper"
			   + "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
	String user="admin"; String pwd="admin";
	Class.forName("com.mysql.jdbc.Driver");
%>
