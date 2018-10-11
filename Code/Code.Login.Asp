<%
'验证登录
Sub UserLogin() 
	CheckComeUrl()
    Dim Sql,Rs
    Dim UserName,Password,CheckCode
	UserName=IsSafeStr(GetValue("UserName"))
	Password=Left(Md5(GetValue("Password")&"@ZJYS#"),15)
	CheckCode=GetValue("CheckCode")
	If UserName="" or Password="" or CheckCode="" then
		Call Alert("登录信息[帐号/密码/验证码]不完整，请返回！","")
		Exit Sub
	end If
	If Trim(Session("CheckCode")) = "" Then
		Call Alert("您在登录页面停留的时间过长，导致验证码失效。请刷新后重新登录。","")
		Exit Sub
	End If
    If CheckCode<>Trim(Session("CheckCode")) Then
		Call Alert("您输入的验证码和系统产生的不一致[可能是因为验证码失效]。请刷新后重新输入。","")
		Exit Sub
    End If
    Sql = "Select UserName,PassWord,LastLoginIP,LastLoginTime,LoginTimes From [TC_User] Where UserName='"&UserName&"'"
	Call OpenConn()
	Call SetRs(Rs,Sql,1,3)
	If Rs.bof And Rs.eof Then
		Conn.Execute "Insert into [TC_LoginLog] ([UserName],[IP],[LoginTime],[Blog]) values('"&LCase(UserName)&"','"&GetIP()&"','"&Now()&"','帐号错误')"
		Call Alert("帐号或密码错误！","")
		Rs.close
		Set Rs=nothing
		Call CloseConn()
		Exit Sub
	Else
		If Password<>Rs("PassWord") Then
			Conn.Execute "Insert into [TC_LoginLog] ([UserName],[IP],[LoginTime],[Blog]) values('"&LCase(UserName)&"','"&GetIP()&"','"&Now()&"','密码错误')"
			Call Alert("帐号或密码错误！","")
			Rs.close
			Set Rs=nothing
			Call CloseConn()
			Exit Sub
		End If
		Rs("LastLoginIP")=GetIP()
		Rs("LastLoginTime")=Now()
		Rs("LoginTimes")=Rs("LoginTimes") + 1	
		Rs.update
		Session("UserName")=Rs("UserName")
		Session("UserPassword")=Rs("PassWord")
		Rs.close
		Set Rs=nothing
		Conn.Execute "insert into [TC_LoginLog] ([UserName],[IP],[LoginTime],[Blog]) values('"&LCase(UserName)&"','"&GetIP()&"','"&Now()&"','登录成功')"
		Call CloseConn()
		Session("CheckCode")=""
		Response.Redirect "Add.Asp"
	End If
End Sub

'退出登陆
Sub UserLogout()
	Call OpenConn()
	Conn.Execute "Insert into [TC_LoginLog] ([UserName],[IP],[LoginTime],[Blog]) values('"&LCase(Session("UserName"))&"','"&GetIP()&"','"&Now()&"','退出登录')"
	Session("UserName")=""
	Session("UserPassword")=""
	Call CloseConn()
	Response.Redirect "Login.Asp"
End Sub
%>