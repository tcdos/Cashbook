<%
'建立链接对象
Sub OpenConn()
	If IsObject(Conn)=True Then Exit Sub
	Dim ConnStr
	If UCase(DbType)="MSSQL" Then
		ConnStr="Provider=Sqloledb;User ID="&MSDbUN& ";Password="&MSDbPW&";Initial Catalog="&MSDbName&";Data Source="&MSDbIP&";"
	Else
		ConnStr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="&Server.MapPath(ACDbName)&";Persist Security info=false;Jet OLEDB:Database Password="
	End If
	Set Conn=Server.CreateObject("ADODB.Connection")
	Conn.Open ConnStr
	If Err.Number <> 0 Then
		Err.Clear
		Set Conn=Nothing
		Response.Write("<center>数据库连接出错</center>")
		Response.End
	End If
End Sub

'关闭链接对象
Sub CloseConn()
    On Error Resume Next
    If IsObject(Conn) Then
        Conn.Close
        Set Conn=Nothing
    End If
	Response.Write "<!--" & vbCrLf
	Response.Write "版权所有: 天草工作室" & vbCrLf
	Response.Write "程序开发: 天草" & vbCrLf
	Response.Write "技术支持: www.tcdos.com // 1114757635" & vbCrLf
	Response.Write "-->" & vbCrLf
End Sub

'建立记录集
Sub SetRs(Rs_Name,Sql_Name,n,m)
	Set Rs_Name=Server.CreateObject("AdoDB.RecordSet") 
	If Sql_Name<>"" then
		Rs_Name.open Sql_Name,Conn,n,m
	Else
		Call Alert("Sql语句不能为空！","")
		Response.End()
		Exit Sub
	End if
End Sub
%>