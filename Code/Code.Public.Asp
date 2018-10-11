<%
'弹出系统提示
Sub Alert(Message,GoUrl)
    Message = replace(Message,"'","\'")
    If GoUrl="" then
        Response.Write ("<script language=javascript>alert('" & Message & "');history.go(-1)</script>")
    Else
        Response.Write ("<script language=javascript>alert('" & Message & "');location='" & GoUrl &"';</script>")
    End If
    Response.End()
End Sub

'数值型参数过滤处理
Function IsSafeID(ID)
	if  Instr(ID,"'") > 0 or (not isNumeric(ID)) or Instr(ID,"%") > 0  then
		Call Alert("数值型参数含有非法字符，请返回！","")
		Response.End() 
		Exit Function 
	else
		IsSafeID=Clng(ID)
	end if
End Function

'字符型参数过滤处理
Function IsSafeStr(strChar)
    Dim strBadChar, arrBadChar, i
    strBadChar = "',%,^,&,?,(,),<,>,[,],{,},/,\,;,:," & Chr(34) & ",*,|,"",.,#"
    arrBadChar = Split(strBadChar, ",")
    If strChar <> "" Then
        For i = 0 To UBound(arrBadChar)
            If InStr(strChar, arrBadChar(i)) > 0 Then
                Call Alert("字符型参数含有非法字符，请返回！","")
				Response.End() 
                Exit Function
            End If
        Next
		IsSafeStr=strChar
	End If
End Function

'非安全字符过滤处理
Function ReplaceStr(str)
	Str=replace(Str,"<","＜")
	Str=replace(Str,">","＞")
	Str=replace(Str,"(","（")
	Str=replace(Str,")","）")
	Str=replace(Str,"'","’")
	Str=replace(Str,";","；")
	Str=replace(Str,"?","？")
	Str=replace(Str,",","，")
	Str=replace(Str,"%","％")
	Str=replace(Str,"+","＋")
	Str=replace(Str,"<BR>","VbCrlf")
	ReplaceStr=Str
End Function

'获取表单元素
Function GetValue(ThisValue) 
	GetValue=Trim(Request(ThisValue))
End Function

'获取截取后的字符串
Function GetSubStr(ByVal str, ByVal strlen, bShowPoint)
    If str = "" or isNull(str) or isEmpty(str) Then
        GetSubStr = ""
        Exit Function
    End If
    Dim l, t, c, i, strTemp
    str = Replace(Replace(Replace(Replace(str, "&nbsp;", ""), "&quot;", Chr(34)), "&gt;", ">"), "&lt;", "<")
    l = Len(str)
    t = 0
    strTemp = str
    strlen = CLng(strlen)
    For i = 1 To l
        c = Abs(Asc(Mid(str, i, 1)))
        If c > 255 Then
            t = t + 2
        Else
            t = t + 1
        End If
        If t >= strlen Then
            strTemp = Left(str, i)
            Exit For
        End If
    Next
    strTemp = Replace(Replace(Replace(Replace(strTemp, " ", "&nbsp;"), Chr(34), "&quot;"), ">", "&gt;"), "<", "&lt;")
    If strTemp <> str And bShowPoint = True Then
        strTemp = strTemp & "..."
    End If
    GetSubStr = strTemp
End Function

'获取字符串长度
Function GetStrLen(str)
	If str = "" or isNull(str) or isEmpty(str) Then
		GetStrLen = 0
	Else
		Dim i, n, k, chrA
		k = 0
		n = Len(str)
		For i = 1 To n
		chrA = Mid(str, i, 1)
		If Asc(chrA) >= 0 And Asc(chrA) <= 255 Then
			k = k + 1
		Else
			k = k + 2
		End If
		Next
		GetStrLen = k
	End If
End Function

'格式化时间
Function ShowTime(s_Time, n_Flag)
	Dim y, m, d, h, mi, s
	Dim mm, dd, hh, mim, ss
	ShowTime = ""
	If IsDate(s_Time) = False Then Exit Function
	y = cstr(year(s_Time))
	m = cstr(month(s_Time))
	d = cstr(day(s_Time))
	h = cstr(hour(s_Time))
	mi = cstr(minute(s_Time))
	s = cstr(second(s_Time))
	If len(m) = 1 Then mm = "0"&m else mm=m
	If len(d) = 1 Then dd = "0"&d else dd=d
	If len(h) = 1 Then hh = "0"&h else hh=h
	If len(mi) = 1 Then mim = "0"&mi else mim=mi
	If len(s) = 1 Then ss = "0"&s else ss=s
	Select Case n_Flag
	Case 1
		ShowTime = y & "-" & m & "-" & d & " " & h & ":" & mi & ":" & s
	Case 2
		ShowTime = y & "-" & m & "-" & d
	Case 3
		ShowTime = y & "-" & mm & "-" & dd & " " & hh & ":" & mim & ":" & ss		
	Case 4
		ShowTime = y & "-" & mm & "-" & dd		
	End Select
End Function

'星期函数
Function EnWeekName(ByVal vDate)
	Dim WeekNames
    WeekNames = Split(",Sun,Mon,Tue,Wed,Thu,Fri,Sat", ",")
    EnWeekName = WeekNames(Weekday(vDate))
End Function

' 获取客户端IP
Function GetIP() 
	Dim uIpAddr 
	uIpAddr = Request.ServerVariables("HTTP_X_FORWARDED_FOR") 
		If uIpAddr = "" Then uIpAddr = Request.ServerVariables("REMOTE_ADDR") 
	GetIP = uIpAddr 
End function

' 获取前一页面路径
Function GetPageUrl()
	Dim url,a,b,c
	url=Request.ServerVariables("HTTP_REFERER")
	a=InstrRev(url,"/")
	b=len(url)
	c=Right(url,b-a)
	GetPageUrl=c
End Function

'防止Sql攻击
Sub StopSql()
	Dim Sql_InjData,Sql_Inj,Sql_Get,Sql_Data,Sql_Post 
	Sql_InjData = "'|%|or|asc|insert|select|delete|update|count|chr|mid|exec|char|master|truncate|declare|delete from|drop table|(script)|on(mouseover|mouseon|mouseout|click|dblclick|blur|focus|change)|eval|netlocalgroup|xp_cmdshell"
	Sql_Inj = split(Sql_InjData,"|")
	If Request.QueryString<>"" Then
		For Each Sql_Get In Request.QueryString
			For Sql_Data=0 To Ubound(Sql_Inj)
				If instr(Request.QueryString(Sql_Get),Sql_Inj(Sql_Data))<>0 Then
					Call Alert("很抱歉，由于您提交的内容中含有危险的Sql注入代码，致使本次操作无效！","")
					Response.End
				End If
			Next
		Next
	End If
	If Request.Form<>"" Then
		For Each Sql_Post In Request.Form
			For Sql_Data=0 To Ubound(Sql_Inj)
				If instr(Request.Form(Sql_Post),Sql_Inj(Sql_Data))>0 Then
					Call Alert("很抱歉，由于您提交的内容中含有危险的Sql注入代码，致使本次操作无效！","")
					Response.End
				End If
			Next
		Next
	End If 
End Sub	

'禁止从外部提交数据
Sub CheckComeUrl()
    Dim ComeUrl, TrueSiteUrl
	ComeUrl=Cstr(Request.ServerVariables("HTTP_REFERER"))
	TrueSiteUrl=Cstr(Request.ServerVariables("SERVER_NAME"))
	If ComeUrl = "" Then
		Call Alert("对不起，为了系统安全，不允许直接输入地址访问本系统的后台管理页面！","")
		Response.End
	else
		if mid(ComeUrl,8,len(TrueSiteUrl))<>TrueSiteUrl then
			Call Alert("对不起，为了系统安全，不允许从外部提交数据！","")
			Response.End
		end if
	End If
End Sub
%>