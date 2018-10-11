<%
'类别列表[二级类别]
Sub ClassList(FatherID)
	Dim rs_ClassList,sql_ClassList
	Dim ID,ClassName
	Call OpenConn()
	if FatherID=0 then
		sql_ClassList = "Select ID,ClassName from [TC_CashClass] where ClassName<>'' and FatherID=3 or FatherID=4 order by ID asc"
	else
		sql_ClassList = "Select ID,ClassName from [TC_CashClass] where ClassName<>'' and FatherID="&FatherID&" order by ID asc"
	end if
	Call SetRS(rs_ClassList,sql_ClassList,1,1)
	if rs_ClassList.bof and rs_ClassList.eof then
		rs_ClassList.close
		Set rs_ClassList=Nothing
		Exit Sub
	else
		Response.Write "<div class=""MainClassListBdoy"">"
		Do While Not rs_ClassList.eof 
			ID=rs_ClassList("ID")
			ClassName=rs_ClassList("ClassName")
			Response.Write "<div class=""MainClassListItemTxt"">"&GetSubStr(ClassName,16,False)&"</div><div class=""MainClassListItemDel""><a href=""?ID="&ID&"&Action=Del"" title=""删除"" onClick=""return confirm('确定删除吗？该操作将删除该分类与该分类下的所有记账记录！此操作将不能恢复！');""></a></div><div class=""MainClassListItemEdit""><a href=""?ID="&ID&"&Action=Edit"" title=""编辑""></a></div>" & vbCrLf
			If rs_ClassList.EOF Then Exit Do
			rs_ClassList.MoveNext
		Loop
		Response.Write "</div>"
		rs_ClassList.close
		Set rs_ClassList=Nothing	
	end if
End Sub

'添加与编辑类别[二级类别]
Sub ClassEdit(ClassID)
	Dim Rs_Edit,Sql_Edit
	Dim ID,ClassName,FatherID
	Dim btnTxt
	Call OpenConn()
	if ClassID<>"" Then
		Sql_Edit="Select ID,ClassName,FatherID from [TC_CashClass] where ID="&ClassID
		Call SetRs(Rs_Edit,Sql_Edit,1,1)
		if Rs_Edit.bof and Rs_Edit.eof then
			Rs_Edit.close
			Set Rs_Edit=nothing
			Call Alert("该记录不存在，请返回！","")
			Exit Sub
		else			
			ID=Rs_Edit("ID")
			ClassName=Rs_Edit("ClassName")
			FatherID=Rs_Edit("FatherID")
			Rs_Edit.close
			set Rs_Edit=nothing
		end if
		btnTxt="编辑"
	else
		btnTxt="添加"
	end if
	Response.Write "<form action=""?Action=Save&ID="&ID&""" method=""post"" name=""PostForm"" onSubmit=""return validator(this)"">" & vbCrLf
	Response.Write "<div class=""EditFromItemSpace""></div>" & vbCrLf
	Response.Write "<div class=""EditFromItem"">隶属："
	Response.Write "<select name=""FatherID"" class=""inputText"" style=""width:155px;"" valid=""required"" errmsg=""请选择隶属分类！"">"
	Response.Write "<option value="""">请选择隶属分类</option>" & vbCrLf
	Response.Write "<option value=""1"" "
	if FatherID=1 then response.write "Selected=""Selected""" 
	Response.Write ">收入</option><option value=""2"" "
	if FatherID=2 then response.write "Selected=""Selected""" 
	Response.Write ">支出</option><option value=""3"" "
	if FatherID=3 then response.write "Selected=""Selected""" 
	Response.Write ">借(资金流入)</option><option value=""4"" "
	if FatherID=4 then response.write "Selected=""Selected""" 
	Response.Write ">贷(资金流出)</option></select>"
	Response.Write "</div>" & vbCrLf
	Response.Write "<div class=""EditFromItem"">名称：<input name=""ClassName"" value="""&ClassName&""" type=""text"" class=""inputText"" maxlength=""250"" valid=""required"" errmsg=""请输入名称！""></div>" & vbCrLf
	Response.Write "<div class=""EditFromItem""><input name=""submit"" class=""btnSubmit"" type=""submit"" value="""&btnTxt&"""></div>" & vbCrLf
	Response.Write "<div class=""EditFromItemSpace""></div>" & vbCrLf
	Response.Write "</form>" & vbCrLf
End Sub

'保存类别[二级类别]
Sub ClassSave()
	CheckComeUrl()
	Dim Rs_Save,Sql_Save
	Dim ID,ClassName,FatherID
	ID=Request.QueryString("ID")
	FatherID=IsSafeID(GetValue("FatherID"))
	ClassName=ReplaceStr(GetValue("ClassName"))	
	if ClassName="" or FatherID="" then
		Call Alert("分类信息不完整[隶属/名称]，请返回！","")
		Exit Sub
	end if
	Call OpenConn()
	if ID<>"" then
		Sql_Save="Select ID,ClassName,FatherID from [TC_CashClass] where ID="&ID
		Call SetRs(Rs_Save,Sql_Save,1,3)
	else
		Sql_Save="Select ID,ClassName,FatherID from [TC_CashClass] "
		Call SetRs(Rs_Save,Sql_Save,1,3)
		Rs_Save.AddNew
	end if
	Rs_Save("ClassName")=ClassName
	Rs_Save("FatherID")=FatherID
	Rs_Save.update
	Rs_Save.close
	set Rs_Save=nothing
	Call CloseConn()
	Call Alert("更新成功，请返回！","Class.Asp")
End Sub

'删除类别[二级类别]
Sub ClassDel()
	Dim ID
	Dim Sql_Cash,Sql_CashClass
	ID=IsSafeID(GetValue(("ID")))
	Call OpenConn()	
	Sql_Cash="Delete From [TC_Cash] Where SmallClassID="&ID
	Sql_CashClass="Delete From [TC_CashClass] Where ID="&ID
	Conn.ExeCute(Sql_Cash)
	conn.Execute(Sql_CashClass)
	Call CloseConn()
	Call Alert("删除成功，请返回！","Class.Asp")
End Sub
%>