<%
'帐号列表
Sub UserList()
	Dim rs_UserList,sql_UserList
	Dim ID,UserName,NickName,PassWord,LastLoginTime,LastLoginIP,LoginTimes
	Call OpenConn()
	sql_UserList = "Select ID,UserName,NickName,LastLoginTime,LastLoginIP from [TC_User] where UserName<>'' order by ID desc"
	Call SetRS(rs_UserList,sql_UserList,1,1)
	if rs_UserList.bof and rs_UserList.eof then
		rs_UserList.close
		Set rs_UserList=Nothing
		Exit Sub
	else
		Response.Write "<table class=""DataTab"" width=""523"" id=""tab"">" & vbCrLf
		Response.Write "<thead>" & vbCrLf
		Response.Write "<tr>" & vbCrLf
		Response.Write "<th width=""85"">帐号</th>" & vbCrLf
		Response.Write "<th width=""85"">昵称</th>" & vbCrLf
		Response.Write "<th width=""153"">最后登录时间</th>" & vbCrLf
		Response.Write "<th width=""120"">最后登录IP</th>" & vbCrLf
		Response.Write "<th width=""80"">操作</th>" & vbCrLf
		Response.Write "</tr>" & vbCrLf
		Response.Write "</thead>" & vbCrLf
		Response.Write "<tbody>" & vbCrLf
		Do While Not rs_UserList.eof
			ID=rs_UserList("ID")
			UserName=rs_UserList("UserName")
			NickName=rs_UserList("NickName")
			LastLoginTime=rs_UserList("LastLoginTime")
			LastLoginIP=rs_UserList("LastLoginIP")
			Response.Write "<tr>" & vbCrLf
			Response.Write "<th>"&UserName&"</th>" & vbCrLf
			Response.Write "<th>"&NickName&"</th>" & vbCrLf
			Response.Write "<th>"&ShowTime(LastLoginTime,3)&"</th>" & vbCrLf
			Response.Write "<th><a href=""http://www.ip138.com/ips8.asp?action=2&ip="&LastLoginIP&""" target=""_blank"">"&LastLoginIP&"</a></th>" & vbCrLf
			Response.Write "<th><a href=""User.Asp?ID="&ID&"&Action=Del"" title=""删除"" onClick=""return confirm('确定删除吗？此操作将不能恢复！');""><img src=""Images/del.gif""></a> <a href=""User.Asp?ID="&ID&"&Action=Edit"" title=""编辑""><img src=""Images/edit.gif""></a></th>" & vbCrLf
			Response.Write "</tr>" & vbCrLf			
			If rs_UserList.EOF Then Exit Do
			rs_UserList.MoveNext
		Loop
		rs_UserList.close
		Set rs_UserList=Nothing	
		Response.Write "</tbody>" & vbCrLf
		Response.Write "</table>" & vbCrLf	
	end if
End Sub

'添加与编辑帐号
Sub UserEdit(ID)
	Dim Rs_Edit,Sql_Edit
	Dim UserName,NickName
	Dim btnTxt
	Call OpenConn()
	if ID<>"" Then
		Sql_Edit="Select ID,UserName,NickName from [TC_User] where ID="&ID
		Call SetRs(Rs_Edit,Sql_Edit,1,1)
		if Rs_Edit.bof and Rs_Edit.eof then
			Rs_Edit.close
			Set Rs_Edit=nothing
			Call Alert("该记录不存在，请返回！","")
			Exit Sub
		else			
			ID=Rs_Edit("ID")
			UserName=Rs_Edit("UserName")
			NickName=Rs_Edit("NickName")
			Rs_Edit.close
			set Rs_Edit=nothing
		end if
		btnTxt="编辑"
	else
		btnTxt="添加"
	end if
	Response.Write "<form action=""?Action=Save&ID="&ID&""" method=""post"" name=""PostForm"" onSubmit=""return validator(this)"">" & vbCrLf
	Response.Write "<div class=""EditFromItemSpace""></div>" & vbCrLf
	Response.Write "<div class=""EditFromItem"">帐号：<input name=""UserName"" value="""&UserName&""" type=""text"" class=""inputText"" maxlength=""50"" valid=""required"" errmsg=""请输入帐号！""></div>" & vbCrLf
	Response.Write "<div class=""EditFromItem"">昵称：<input name=""NickName"" value="""&NickName&""" type=""text"" class=""inputText"" maxlength=""50"" valid=""required"" errmsg=""请输入昵称！""></div>" & vbCrLf	
	Response.Write "<div class=""EditFromItem"">密码：<input name=""UserPassword"" value="""" type=""password"" class=""inputText"" maxlength=""50"" valid=""required"" errmsg=""请输入密码！""></div>" & vbCrLf
	Response.Write "<div class=""EditFromItem"">确认：<input name=""ChkPassword"" value="""" type=""password"" class=""inputText"" maxlength=""50"" valid=""required"" errmsg=""请输入确认密码！""></div>" & vbCrLf
	Response.Write "<div class=""EditFromItem""><input name=""submit"" class=""btnSubmit"" type=""submit"" value="""&btnTxt&"""></div>" & vbCrLf
	Response.Write "<div class=""EditFromItemSpace""></div>" & vbCrLf
	Response.Write "</form>" & vbCrLf	
End Sub

'保存帐号
Sub UserSave()
	CheckComeUrl()
	Dim Rs_Save,Sql_Save
	Dim ID,UserName,NickName,UserPassword,ChkPassword
	ID=Request.QueryString("ID")
	UserName=ReplaceStr(GetValue("UserName"))
	NickName=ReplaceStr(GetValue("NickName"))
	UserPassword=GetValue("UserPassword")
	ChkPassword=GetValue("ChkPassword")
	if UserName="" or NickName="" or UserPassword="" or ChkPassword="" then
		Call Alert("帐号信息不完整[帐号、昵称、密码与确认密码]，请返回！","")
		Exit Sub
	end if
	if UserPassword<>ChkPassword then
		Call Alert("密码与确认密码不一致，请返回！","")
		Exit Sub
	end if	
	
	Call OpenConn()
	if ID<>"" then
		Sql_Save="Select ID,UserName,NickName,Password from [TC_User] where ID="&ID
		Call SetRs(Rs_Save,Sql_Save,1,3)
	else
		Sql_Save="Select ID,UserName,NickName,Password from [TC_User] "
		Call SetRs(Rs_Save,Sql_Save,1,3)
		Rs_Save.AddNew
	end if
	Rs_Save("UserName")=UserName
	Rs_Save("NickName")=NickName
	Rs_Save("Password")=Left(Md5(UserPassword&"@ZJYS#"),15)
	Rs_Save.update
	Rs_Save.close
	set Rs_Save=nothing
	Call CloseConn()
	Call Alert("更新成功，请返回！","User.Asp")
End Sub

'删除帐号
Sub UserDel()
	Dim ID
	Dim Sql_User
	ID=IsSafeID(GetValue(("ID")))
	Call OpenConn()	
	Sql_User="Delete From [TC_User] Where ID="&ID
	conn.Execute(Sql_User)
	Call CloseConn()
	Call Alert("删除成功，请返回！","User.Asp")
End Sub

%>