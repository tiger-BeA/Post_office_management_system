<!--@author QW
	作用：用户完成订购后，显示订购结果
	处理对象： news_info
	查询操作：select
-->

<%@ page language="java" import="java.util.*,java.sql.*,java.text.DecimalFormat" 
         contentType="text/html; charset=utf-8"
%>
<%
request.setCharacterEncoding("utf-8");
StringBuilder table=new StringBuilder("");//存储报纸的表格信息
table.append("<table border=\"1\" id=\"news_info\"><caption align=\"top\">订单列表</caption><tr><th>报刊编号</th>"
		   +"<th>名称</th><th>单价(元/份)</th><th>规格</th><th>出版社</th>"+"<th>购买数量</th><th>金额</th>"+"</th></tr>");
String warning = "";
int msg = 0;
String user_id = request.getParameter("id");  //用户编号
String count = request.getParameter("count");  //报纸种类
String flag [] = new String[Integer.parseInt(count)];
StringBuilder array = new StringBuilder("");//每种报纸的购买量
for(int i=0;i<Integer.parseInt(count);i++){
	flag[i] = request.getParameter("points"+i+"");
	if(i!=Integer.parseInt(count)-1)array.append(flag[i]+",");
	else
		array.append(flag[i]);
}
String tag = array.toString();
int index = 0;
double money = 0d;
DecimalFormat df = new DecimalFormat("0.00");
%>
<%@ include file="connect.jsp" %>
<%
	   try{
		   Connection con = DriverManager.getConnection(connectString,user, pwd);
		   Statement stmt = con.createStatement();
		   //从数据库中查询出报纸的相关信息插入到表格当中
		   ResultSet rs=stmt.executeQuery("select * from news_info;");
		   while(rs.next()){
			   if(!flag[index].equals("0")){
				   table.append(String.format(
							  "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>",
							  rs.getString("pno"),rs.getString("pna"),rs.getString("ppr"),rs.getString("psi"),rs.getString("pdw"),
							  flag[index]+"",df.format(Double.parseDouble(flag[index])*Double.parseDouble(rs.getString("ppr")))+""
							  )
							  );   
				   money = money + Double.parseDouble(flag[index])*Double.parseDouble(rs.getString("ppr"));
			   }
			   index++;
		   }
		   table.append("<tr><td>总计(元)</td><td colspan=\"6\">"+df.format(money)+""+"</td></tr>");
		   table.append("</table>");
		   rs.close();
	   }catch(Exception e){
		   warning = e.getMessage();
		   }
%>
<html>
<head>
<title>订购结果</title>
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
  <h1 style="text-align: center;">请确认您的订单信息</h1><br><br>
  <div id="container">
    <form action="sub_save.jsp?id=<%=user_id %>&array=<%=tag %>&count=<%=count %>" method="post">
      <%=table %><br>
      <input type="submit" name="submit1" value="确认购买"/>
      <input type="button" name="submit2" value="返回" onclick="javascript:history.back(-1);"/>
    </form>
  </div>
</body>
</html>