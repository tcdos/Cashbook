<!--#Include file="Config.Asp" -->
<!--#Include file="Code/Code.Check.Asp" -->
<!--#Include file="Code/Code.DbControl.Asp" -->
<!--#Include file="Code/Code.Public.Asp" -->
<!--#Include file="Code/Code.Page.Asp" -->
<!--#Include file="Code/Code.System.Asp" -->
<!--#Include file="Code/Code.Main.Asp" -->
<%
Call CheckLogin()
If Action="Del" then
	Call CashDel()
End If
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
<script type="text/javascript" src="Script/jQuery.js"></script>
<script type="text/javascript" src="Script/CheckForm.js"></script>
<script type="text/javascript" src="Script/Date.js"></script>
<script type="text/javascript"> 
$(function(){
    var x = 10;  
	var y = 20;
	$("a.tooltip").mouseover(function(e){
       	this.myTitle = this.title;
		this.title = "";	
	    var tooltip = "<div id='tooltip'>"+ this.myTitle +"<\/div>";
		$("body").append(tooltip);	
		$("#tooltip")
			.css({
				"top": (e.pageY + y) + "px",
				"left": (e.pageX  + x) + "px"
			}).show("fast");
    }).mouseout(function(){		
		this.title = this.myTitle;
		$("#tooltip").remove();
    });
});
</script>
</head>
<body onload="Pages();">
<div id="CashPage">
<div id="MainPage">
    <div id="MainContain">
        <div id="MainHead">
            <div id="MainLogo"><a href="Main.Asp" title="小钱袋子 - 您的理财小助手"></a></div>
            <div id="MainNav">
            	<ul>
                	<li><a href="Main.Asp" title="账单列表" class="on">账单列表</a></li>
                    <li><a href="Class.Asp" title="分类设置">分类设置</a></li>
                    <li><a href="Pay.Asp" title="支付方式">支付方式</a></li>
                    <li><a href="Count.Asp" title="财务分析">财务分析</a></li>
                    <li><a href="User.Asp" title="帐号管理">帐号管理</a></li>
                    <li><a href="Add.Asp" title="我要记账">我要记账</a></li>
                    <li class="Out"><a href="Login.Asp?Action=Exit" title="退出登录" onClick="return confirm('确定退出登录吗？');">退出</a></li>
                </ul>
            </div>
            <div class="clear"></div>
        </div>
        <div id="MainBody">
            <div id="MainWel"><strong><%=Session("UserName")%></strong>：您好，欢迎使用小钱袋子。您可以使用[筛选账单]功能查看指定日期的账单。(<%=ShowTime(Now(),3)%>)<span class="MainSelect"><a href="javascript:show('SelPannel')">&raquo; 筛选账单</a></span><div class="MainSelectForm" id="SelPannel" style="display:none;"><form name="PostForm" action="?st=<%GetValue("st")%>&et=<%GetValue("et")%>" method="get" onSubmit="return validator(this)">请选择日期：从 <input name="st" id="st" type="text" style="width:85px;" class="inputText" valid="required" errmsg="请输入起始日期！" onclick="HS_setDate(this);" > 到 <input name="et" id="et" type="text" style="width:85px;" class="inputText" valid="required" errmsg="请输入结束日期！" onclick="HS_setDate(this);" > <input type="submit" value="查看" class="CountBtn" /></form></div></div>
            <div id="MainList"><%Call CashList(GetValue("ClassID"),GetValue("Date"),GetValue("st"),GetValue("et"))%></div>
        </div>
        <div id="MainFoot">&copy; 2011-<%=Year(now())%> ecash.tcdos.com All Rights Reserved</div>
    </div>
</div>
</div>
</body>
</html>
<% Call CloseConn() %>