<!--#Include file="Config.Asp" -->
<!--#Include file="Code/Code.Check.Asp" -->
<!--#Include file="Code/Code.DbControl.Asp" -->
<!--#Include file="Code/Code.Public.Asp" -->
<!--#Include file="Code/Code.System.Asp" -->
<!--#Include file="Code/Code.Count.Asp" -->
<%Call CheckLogin()%>
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
<script type="text/javascript" src="Script/Date.js"></script>
</head>
<body onload="myfocus();">
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
					<li><a href="Count.Asp" title="财务分析" class="on">财务分析</a></li>
					<li><a href="User.Asp" title="帐号管理">帐号管理</a></li>
					<li><a href="Add.Asp" title="我要记账">我要记账</a></li>
					<li class="Out"><a href="Login.Asp?Action=Exit" title="退出登录" onClick="return confirm('确定退出登录吗？');">退出</a></li>
				</ul>
			</div>
			<div class="clear"></div>
		</div>
		<div id="MainBody">
			<div id="MainWel"><strong><%=Session("UserName")%></strong>：您好，欢迎使用小钱袋子。您私人的财务统计报表，快看看您的小钱袋子里还有多少银子吧。(<%=ShowTime(Now(),3)%>)</div>
			<div id="MainList">
				<div id="MainCountList">
					<div class="MainCountBdoy">
						<div class="MainCountSelectList"><a href="?st=&et=">全部统计</a></div>
						<div class="MainCountSelectList"><a href="?st=<%=ShowTime(Date()-1,2)%>&et=<%=ShowTime(Date()-1,2)%>">昨日统计</a></div>
						<div class="MainCountSelectList"><a href="?st=<%=ShowTime(Now(),2)%>&et=<%=ShowTime(Now(),2)%>">今日统计</a></div>
						<div class="MainCountSelectList"><a href="?st=<%=ShowTime(LastMonth_st,2)%>&et=<%=ShowTime(LastMonth_et,2)%>">上月统计</a></div>
						<div class="MainCountSelectList"><a href="?st=<%=ShowTime(ThisDay_st,2)%>&et=<%=ShowTime(ThisDay_et,2)%>">最近30天</a></div>
						<div class="MainCountSelectList"><a href="?st=<%=ShowTime(ThisMonth_st,2)%>&et=<%=ShowTime(ThisMonth_et,2)%>">本月统计</a></div>
						<div class="MainCountSelectList"><a href="?st=<%=Year(Now())-1%>-1-1&et=<%=Year(Now())-1%>-12-31">上年统计</a></div>
						<div class="MainCountSelectList"><a href="?st=<%=Year(Now())%>-1-1&et=<%=Year(Now())%>-12-31">本年统计</a></div>
						<div class="MainCountSelectList"><a href="javascript:show('SelPannel')">个性统计</a></div>
						<div class="clear"></div>
						<div class="MainCountSelectForm" id="SelPannel" style="display:none;"><form name="PostForm" action="?st=<%GetValue("st")%>&et=<%GetValue("et")%>" method="get" onSubmit="return validator(this)">请选择日期：从 <input name="st" id="st" type="text" style="width:85px;" class="inputText" valid="required" errmsg="请输入起始日期！" onclick="HS_setDate(this);" > 到 <input name="et" id="et" type="text" style="width:85px;" class="inputText" valid="required" errmsg="请输入结束日期！" onclick="HS_setDate(this);" > <input type="submit" value="统计" class="CountBtn" /></form></div>
					</div>				
					<%=CountTip()%>
					<div Class="MainCountHead">统计概况</div>
					<div class="MainCountBdoy">
						<div class="MainCountList">所有总收入：<span class="MainCount_in"><%=FormatNumber(GetBigClassCount(1,GetValue("st"),GetValue("et")),2)%></span></div> 
						<div class="MainCountList">所有借入：<span class="MainCount_out"><%=FormatNumber(GetBigClassCount(3,GetValue("st"),GetValue("et")),2)%></span></div>
						<div class="MainCountList">所有负债：<span class="MainCount_out"><%=FormatNumber((GetBigClassCount(3,GetValue("st"),GetValue("et"))-GetBigClassCount(4,GetValue("st"),GetValue("et"))),2)%></span></div>
						<div class="MainCountList">所有总支出：<span class="MainCount_out"><%=FormatNumber(GetBigClassCount(2,GetValue("st"),GetValue("et")),2)%></span></div>
						<div class="MainCountList">所有借出：<span class="MainCount_in"><%=FormatNumber(GetBigClassCount(4,GetValue("st"),GetValue("et")),2)%></span></div>
						<div class="MainCountList">所有结余：<span class="MainCount_total"><%=FormatNumber((GetBigClassCount(1,GetValue("st"),GetValue("et"))+GetBigClassCount(3,GetValue("st"),GetValue("et"))-GetBigClassCount(2,GetValue("st"),GetValue("et"))-GetBigClassCount(4,GetValue("st"),GetValue("et"))),2)%></span></div>
						<div class="clear"></div>
					</div>
					<div Class="MainCountHead">收入分类统计</div>
					<div class="MainCountBdoy"><% Call CountClassList(1) %></div>											
					<div Class="MainCountHead">支出分类统计</div>
					<div class="MainCountBdoy"><% Call CountClassList(2) %></div>																			
					<div Class="MainCountHead">资金流入(借)分类统计</div>
					<div class="MainCountBdoy"><% Call CountClassList(3) %></div>
					<div Class="MainCountHead">资金流出(贷)分类统计</div>
					<div class="MainCountBdoy"><% Call CountClassList(4) %></div>			
				</div>
			</div>
		</div>
		<div id="MainFoot">&copy; 2011-<%=Year(now())%> ecash.tcdos.com All Rights Reserved</div>
	</div>
</div>
</div>
</body>
</html>
<% Call CloseConn() %>