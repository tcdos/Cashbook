<!--#Include file="Config.Asp" -->
<!--#Include file="Code/Code.DbControl.Asp" -->
<!--#Include file="Code/Code.Public.Asp" -->
<!--#Include file="Code/Code.Md5.Asp" -->
<!--#Include file="Code/Code.Login.Asp" -->
<%
Call StopSql()
Select Case Action
	Case "Login" 
		Call UserLogin()
	Case "Exit"
		Call UserLogout()
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
<link href="Style/Skin.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="Script/eCash.js"></script>
<script type="text/javascript" src="Script/CheckForm.js"></script>
</head>
<body onload="myfocus();">
<div id="LoginPannel">
	<form name="PostForm" method="post" Action="?Action=Login" onSubmit="return validator(this)">
	<div id="LoginHead"><a href="Default.Asp"></a></div>
	<div id="LoginBody">
		<div class="LoginFromItem"><div class="LoginFromItemTxt">帐号：</div><div class="LoginFromItemInput"><input name="UserName" type="text" class="inputText" maxlength="20" valid="required" errmsg="请输入帐号！"></div></div>
		<div class="LoginFromItem"><div class="LoginFromItemTxt">密码：</div><div class="LoginFromItemInput"><input name="PassWord" type="password" class="inputText" maxlength="20" valid="required" errmsg="请输入密码！"></div></div>
		<div class="LoginFromItem"><div class="LoginFromItemTxt">验证码：</div><div class="LoginFromItemInput"><input name="CheckCode" type="text" class="inputText" style="width:80px;" maxlength="20" valid="required|isInt" errmsg="请输入验证码！|请输入正确的验证码！"> <img src="<%=tcWebPath%>Code/Code.CheckCode.Asp" alt="验证码,看不清楚?请点击刷新验证码" style="cuRsor: pointer;" onClick="this.src='<%=tcWebPath%>Code/Code.CheckCode.Asp?'+Math.random();"></div></div>		
		<div class="LoginFromItem"><input name="submit" class="btnSubmit" type="submit" value="登 录"></div>
	</div>
	</form>
</div>
</body>
</html>