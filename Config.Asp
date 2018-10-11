<%@language="Vbscript" codepage="65001"%>
<%Option Explicit
Session.CodePage=65001
Response.ChaRset="utf-8"
Response.Buffer = True
Server.ScriptTimeout=3600
Dim tcWebPath:tcWebPath="/"
Dim DbType:DbType="Access"
Dim ACDbName:ACDbName=tcWebPath&"Dll/Data.eCash.DLL"
Dim MSDbName:MSDbName="" 
Dim MSDbUN:MSDbUN="" 
Dim MSDbPW:MSDbPW="" 
Dim MSDbIP:MSDbIP="(local)" 
Dim Conn,Action:Action=Trim(Request("Action"))
Dim strFileName,CurrentPage,totalPut,MaxPerPage:MaxPerPage=15
Dim iCount:iCount=0
%>