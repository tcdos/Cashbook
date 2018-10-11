<%
'添加与编辑账单
Sub CashEdit(ID)
	Dim Rs_Edit,Sql_Edit
	Dim Title,SmallClassID,PayClassID,Amount,UserName,PostTime,Summary
	Dim FatherID,rs_Num,sql_Num,n,i
	Dim strDate
	Dim ReturnUrl
	Dim btnTxt
	Dim backBtn
	ReturnUrl=GetPageUrl()
	strDate=Request.QueryString("Date")
	Call OpenConn()
	if ID<>"" Then
		Sql_Edit="Select Title,SmallClassID,PayClassID,Amount,UserName,PostTime,Summary from [TC_Cash] where ID="&ID
		Call SetRs(Rs_Edit,Sql_Edit,1,1)
		if Rs_Edit.bof and Rs_Edit.eof then
			Rs_Edit.close
			Set Rs_Edit=nothing
			Call Alert("该记录不存在，请返回！","")
			Exit Sub
		else			
			Title=Rs_Edit("Title")
			SmallClassID=Rs_Edit("SmallClassID")
			PayClassID=Rs_Edit("PayClassID")
			Amount=Rs_Edit("Amount")
			UserName=Rs_Edit("UserName")
			PostTime=Rs_Edit("PostTime")
			Summary=Rs_Edit("Summary")
			Rs_Edit.close
			set Rs_Edit=nothing
		end if
		btnTxt="编辑"
		backBtn="<input name=""Cancel"" type=""button"" value=""返回"" onClick=""javascript:history.go(-1)"" class=""btnCancel"">"
	else
		btnTxt="添加"
	end if
	Response.Write "<form action=""?Action=Save&ID="&ID&""" method=""post"" name=""PostForm"" onSubmit=""return validator(this)"">" & vbCrLf
	Response.Write "<div class=""MainAddCashFormItem"">" & vbCrLf
	Response.Write "<label for=Title>账单名称：</label><input type=""text"" name=""Title"" value="""&Title&""" maxlength=""200"" style=""width:300px;"" class=""inputText"" valid=""required"" errmsg=""请输入账单名称！"">" & vbCrLf
	Response.Write "<input name=""ReturnUrl"" type=""hidden"" value="""&ReturnUrl&""" /><br />" & vbCrLf
	Response.Write "<label for=Amount>金额：</label><input type=""text"" name=""Amount"" value="""&Amount&""" maxlength=""8"" class=""inputText"" valid=""required|isMoney"" errmsg=""请输入金额！|请输入合法金额！""><br />" & vbCrLf
	Response.Write "<label for=SmallClassID>类别：</label><select name=""SmallClassID"" id=""SmallClassID"" class=""inputText"" style=""width:155px;"" valid=""required"" errmsg=""请选择类别！"">"
	Response.Write "<option value="""">请选择类别</option>"& vbCrLf
	Response.Write "<optgroup label=""-----------------------""></optgroup>"& vbCrLf 
	Dim Class_Rs,Class_Sql 
	Dim ClassID,ClassName
	Class_Sql ="Select ID,ClassName,FatherID from [TC_CashClass] where ClassName<>'' order by FatherID asc,ID asc"
	Call SetRs(Class_Rs,Class_Sql,1,1)
	if Not(Class_Rs.bof and Class_Rs.eof) then
		i=0
		Do while not Class_Rs.eof 
			ClassID=Class_Rs("ID")
			ClassName=Class_Rs("ClassName")
			FatherID=Class_Rs("FatherID")
			sql_Num="Select ID From [TC_CashClass] where FatherID="&FatherID
			Call SetRs(rs_Num,sql_Num,1,1)
			n=rs_Num.RecordCount
			rs_Num.close
			set rs_Num=nothing
			i=i+1
			Response.Write "<option value="""&ClassID&""""
			if SmallClassID=ClassID then response.Write(" selected=""selected"" ")
			Response.Write ">"&ClassName&"</option>"& vbCrLf
			if i=n then 
				Response.Write "<optgroup label=""-----------------------""></optgroup>" & vbCrLf
				i=0
			end if 
			Class_Rs.movenext
			if Class_Rs.eof then exit do 
		Loop
	end if
	Class_Rs.close
	set Class_Rs=nothing	
	Response.Write "</select><br />" & vbCrLf
	Response.Write "<label for=PayClassID>支付方式：</label><select name=""PayClassID"" id=""PayClassID"" class=""inputText"" style=""width:155px;"" valid=""required"" errmsg=""请选择支付方式！"">"& vbCrLf 
	Dim Pay_Rs,Pay_Sql 
	Dim PayID,PayName
	Pay_Sql ="Select ID,ClassName from [TC_PayClass] where ClassName<>'' order by ID asc"
	Call SetRs(Pay_Rs,Pay_Sql,1,1)
	if Not(Pay_Rs.bof and Pay_Rs.eof) then
		Do while not Pay_Rs.eof 
			PayID=Pay_Rs("ID")
			PayName=Pay_Rs("ClassName")
			Response.Write "<option value="""&PayID&""""
			if PayClassID=PayID then response.Write(" selected=""selected"" ")
			Response.Write ">"&PayName&"</option>"& vbCrLf 
			Pay_Rs.movenext
			if Pay_Rs.eof then exit do 
		Loop
	end if
	Pay_Rs.close
	set Pay_Rs=nothing
	Response.Write "</select><br />" & vbCrLf
	Response.Write "<label for=UserName>经手人：</label><input type=""text"" name=""UserName"" maxlength=""50"" class=""inputText"" valid=""required"" errmsg=""请输入经手人！"" "
	if UserName<>"" then  Response.Write "value="""&UserName&"""" else Response.Write "value="""&Trim(Session("UserName"))&""""
	Response.Write "><br />" & vbCrLf
	Response.Write "<label for=PostTime>日期：</label><input type=""text"" name=""PostTime"" id=""PostTime"" onfocus=""if(value=='YYYY-MM-DD') {value=''}"" onblur=""if (value=='') {value='YYYY-MM-DD'}"" onclick=""HS_setDate(this);"" maxlength=""50"" class=""inputText"" valid=""required"" errmsg=""请输入日期！"" "
	if PostTime="" then
		if strDate="" then
			Response.Write("Value="""&ShowTime(Now(),2)&"""")
		else
			Response.Write("Value="""&ShowTime(strDate,2)&"""")
		end if
	else
		Response.Write("Value="""&ShowTime(PostTime,2)&"""")
	end if
	Response.Write "><br />" & vbCrLf
	Response.Write "<label for=Summary>备注：</label><textarea name=""Summary"" class=""inputText"" style=""width:400px; overflow:auto;line-height:20px;"" rows=""8"">"
	If Summary<>"" then Response.Write( Summary )
	Response.Write "</textarea><br />" & vbCrLf
	Response.Write "<input name=""Submit"" type=""submit"" id=""Submit"" value="""&btnTxt&""" class=""AddBtn""> "&backBtn&"" & vbCrLf
	Response.Write "</div>" & vbCrLf
End Sub

'保存账单
Sub CashSave()
	CheckComeUrl()
	Dim Rs_Save,Sql_Save
	Dim ID,Title,BigClassID,SmallClassID,PayClassID,Amount,UserName,PostTime,Summary
	Dim Rs_BigClassID,Sql_BigClassID
	Dim ReturnUrl
	ID=Request.QueryString("ID")
	ReturnUrl=GetValue("ReturnUrl")
	Title=ReplaceStr(GetValue("Title"))
	UserName=ReplaceStr(GetValue("UserName"))	
	PostTime=ReplaceStr(GetValue("PostTime"))
	Summary=ReplaceStr(GetValue("Summary"))	
	SmallClassID=GetValue("SmallClassID")
	PayClassID=GetValue("PayClassID")
	Amount=GetValue("Amount")
	if LCase(ReturnUrl)="login.asp" or Instr(ReturnUrl,"Add.Asp")>0 then ReturnUrl="Add.Asp"
	
	if Title="" or SmallClassID="" or PayClassID="" or Amount="" or UserName="" or PostTime=""  then
		Call Alert("记账信息不完整，请返回！","")
		Exit Sub
	end if
	
	if IsDate(PostTime) then
		PostTime=ShowTime(PostTime,2)
	else
		Call Alert("日期类型错误，请返回！","")
		Exit Sub		
	end if
		
	Sql_BigClassID="Select FatherID from [TC_CashClass] where ID="&SmallClassID
	Call OpenConn()
	Call SetRs(Rs_BigClassID,Sql_BigClassID,1,1)
	if Rs_BigClassID.bof and Rs_BigClassID.eof then
		Rs_BigClassID.close
		set Rs_BigClassID=nothing
		Call CloseConn()
		Call Alert("该分类隶属出错，操作已被终止，请返回！","")
	else
		BigClassID=Rs_BigClassID("FatherID")
		Rs_BigClassID.close
		set Rs_BigClassID=nothing
	end if	
	
	if ID<>"" then
		Sql_Save="Select ID,Title,BigClassID,SmallClassID,PayClassID,Amount,UserName,PostTime,Summary from [TC_Cash] where ID="&ID
		Call SetRs(Rs_Save,Sql_Save,1,3)
	else
		Sql_Save="Select ID,Title,BigClassID,SmallClassID,PayClassID,Amount,UserName,PostTime,Summary from [TC_Cash] "
		Call SetRs(Rs_Save,Sql_Save,1,3)
		Rs_Save.AddNew
	end if
	Rs_Save("Title")=Title
	Rs_Save("BigClassID")=BigClassID
	Rs_Save("SmallClassID")=SmallClassID
	Rs_Save("PayClassID")=PayClassID
	Rs_Save("Amount")=Amount
	Rs_Save("UserName")=UserName
	Rs_Save("PostTime")=PostTime
	Rs_Save("Summary")=Summary
	Rs_Save.update
	Rs_Save.close
	set Rs_Save=nothing
	Call CloseConn()
	Call Alert("更新成功，请返回！",ReturnUrl)
End Sub
%>