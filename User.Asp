<!--#Include file="Config.Asp" -->
<!--#Include file="Code/Code.Check.Asp" -->
<!--#Include file="Code/Code.DbControl.Asp" -->
<!--#Include file="Code/Code.Public.Asp" -->
<!--#Include file="Code/Code.Md5.Asp" -->
<!--#Include file="Code/Code.User.Asp" -->
<%
Call CheckLogin()
Select Case Action
	Case "Save" 
		Call UserSave()
	Case "Del"
		Call UserDel()
End Select
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>小钱袋子 - 您的理财小助手 - [ecash.tcdos.com]</title>
<meta http-equiv="Content-Type" content="text/html; chaRset=utf-8">
<meta http-equiv="Content-Language" content="zh-cn"> 
<meta name="keywords" content="小钱袋子,天草工作室,tcdos.com">
<meta name="Description" content="小钱袋子，您的理财小助手！">
<meta name="Author" content="Http://www.tcdos.com">
<script type="text/javascript" src="Script/CheckForm.js"></script>
<script type="text/javascript" src="Script/eCash.js"></script>
<link href="Style/Skin.css" rel="stylesheet" type="text/css">
</head>
<body onload="Pages();">
<div id="CashPage">
<div id="MainPage">
    <div id="MainContain">
        <div id="MainHead">
            <div id="MainLogo"><a href="Main.Asp" title="小钱袋子 - 您的理财小助手"></a></div>
            <div id="MainNav">
            	<ul>
                	<li><a href="Main.Asp" title="账单列表">账单列表</a></li>
                    <li><a href="Class.Asp" title="分类设置">分类设置</a></li>
                    <li><a href="Pay.Asp" title="支付方式">支付方式</a></li>
                    <li><a href="Count.Asp" title="财务分析">财务分析</a></li>
                    <li><a href="User.Asp" title="帐号管理" class="on">帐号管理</a></li>
                    <li><a href="Add.Asp" title="我要记账">我要记账</a></li>
                    <li class="Out"><a href="Login.Asp?Action=Exit" title="退出登录" onClick="return confirm('确定退出登录吗？');">退出</a></li>
                </ul>
            </div>
            <div class="clear"></div>
        </div>
        <div id="MainBody">
        	<div id="MainWel"><strong><%=Session("UserName")%></strong>：您好，欢迎使用小钱袋子。您可以添加新的账本管理员与修改密码。(<%=ShowTime(Now(),3)%>)</div>
            <div id="MainList">
                <div class="MainUserList"><% Call UserList() %></div>
                <div id="MainAddUserForm"><div class="MainAddUserFormHead">添加与编辑管理员</div><% Call UserEdit(Trim(Request.QueryString("ID"))) %></div>
                <div class="clear"></div>                
            </div>
        </div>
        <div id="MainFoot">&copy; 2011-<%=Year(now())%> ecash.tcdos.com All Rights Reserved</div>
    </div>
</div>
</div>
</body>
</html>
<% Call CloseConn() %>