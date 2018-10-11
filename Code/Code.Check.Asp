<%
'登陆检测
Sub CheckLogin()
	Dim UserName, UserPassword
	Dim Sql_Chk,Rs_Chk
	UserName=Session("UserName")
	UserPassword=Session("UserPassword")
	if UserName="" or UserPassword="" then
		Call CloseConn()
		Response.redirect "Login.Asp"
		Response.End 
		Exit Sub
	end if
	Sql_Chk = "Select UserName,PassWord from [TC_User] where UserName='"&UserName&"' and PassWord='"&UserPassword&"'"
	Call OpenConn()
	Set Rs_Chk = Server.CreateObject("ADODB.RecordSet")
	Rs_Chk.Open Sql_Chk,conn,1,1
	if Rs_Chk.bof and Rs_Chk.eof then
		Session("UserName")=""
		Session("UserPassword")=""
		Rs_Chk.close
		set Rs_Chk=nothing
		Call CloseConn()
		Response.Redirect "Login.Asp"
		Response.End
		Exit Sub
	end if
	Rs_Chk.close
	set Rs_Chk=nothing
End Sub
%>
