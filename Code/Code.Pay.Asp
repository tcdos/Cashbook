<%
'支付方式列表
Sub PayList()
	Dim rs_PayList,sql_PayList
	Dim ID,ClassName
	Call OpenConn()
	sql_PayList = "Select ID,ClassName from [TC_PayClass] where ClassName<>'' order by ID asc"
	Call SetRS(rs_PayList,sql_PayList,1,1)
	if rs_PayList.bof and rs_PayList.eof then
		rs_PayList.close
		Set rs_PayList=Nothing
		Exit Sub
	else
		Response.Write "<div class=""MainClassListBdoy"">"
		Do While Not rs_PayList.eof 
			ID=rs_PayList("ID")
			ClassName=rs_PayList("ClassName")
			Response.Write "<div class=""MainClassListItemTxt"">"&GetSubStr(ClassName,16,False)&"</div><div class=""MainClassListItemDel""><a href=""?ID="&ID&"&Action=Del"" title=""删除"" onClick=""return confirm('确定删除吗？此操作将不能恢复！');""></a></div><div class=""MainClassListItemEdit""><a href=""?ID="&ID&"&Action=Edit"" title=""编辑""></a></div>" & vbCrLf			
			If rs_PayList.EOF Then Exit Do
			rs_PayList.MoveNext
		Loop
		Response.Write "</div>"
		rs_PayList.close
		Set rs_PayList=Nothing	
	end if
End Sub

'添加与编辑支付方式
Sub PayEdit(ClassID)
	Dim Rs_Edit,Sql_Edit
	Dim ID,ClassName
	Dim btnTxt
	Call OpenConn()
	if ClassID<>"" Then
		Sql_Edit="Select ID,ClassName from [TC_PayClass] where ID="&ClassID
		Call SetRs(Rs_Edit,Sql_Edit,1,1)
		if Rs_Edit.bof and Rs_Edit.eof then
			Rs_Edit.close
			Set Rs_Edit=nothing
			Call Alert("该记录不存在，请返回！","")
			Exit Sub
		else			
			ID=Rs_Edit("ID")
			ClassName=Rs_Edit("ClassName")
			Rs_Edit.close
			set Rs_Edit=nothing
		end if
		btnTxt="编辑"
	else
		btnTxt="添加"
	end if
	Response.Write "<form action=""?Action=Save&ID="&ID&""" method=""post"" name=""PostForm"" onSubmit=""return validator(this)"">" & vbCrLf
	Response.Write "<div class=""EditFromItemSpace""></div>" & vbCrLf
	Response.Write "<div class=""EditFromItem"">名称：<input name=""ClassName"" value="""&ClassName&""" type=""text"" class=""inputText"" maxlength=""250"" valid=""required"" errmsg=""请输入名称！""></div>" & vbCrLf
	Response.Write "<div class=""EditFromItem""><input name=""submit"" class=""btnSubmit"" type=""submit"" value="""&btnTxt&"""></div>" & vbCrLf
	Response.Write "<div class=""EditFromItemSpace""></div>" & vbCrLf
	Response.Write "</form>" & vbCrLf
End Sub

'保存支付方式
Sub PaySave()
	CheckComeUrl()
	Dim Rs_Save,Sql_Save
	Dim ID,ClassName
	ID=Request.QueryString("ID")
	ClassName=ReplaceStr(GetValue("ClassName"))	
	if ClassName="" then
		Call Alert("分类信息不完整[名称]，请返回！","")
		Exit Sub
	end if
	Call OpenConn()
	if ID<>"" then
		Sql_Save="Select ID,ClassName from [TC_PayClass] where ID="&ID
		Call SetRs(Rs_Save,Sql_Save,1,3)
	else
		Sql_Save="Select ID,ClassName from [TC_PayClass] "
		Call SetRs(Rs_Save,Sql_Save,1,3)
		Rs_Save.AddNew
	end if
	Rs_Save("ClassName")=ClassName
	Rs_Save.update
	Rs_Save.close
	set Rs_Save=nothing
	Call CloseConn()
	Call Alert("更新成功，请返回！","Pay.Asp")
End Sub

Sub PayDel()
	Dim ID
	Dim Sql_PayClass
	ID=IsSafeID(GetValue(("ID")))
	Call OpenConn()	
	Sql_PayClass="Delete From [TC_PayClass] Where ID="&ID
	conn.Execute(Sql_PayClass)
	Call CloseConn()
	Call Alert("删除成功，请返回！","Pay.Asp")
End Sub
%>