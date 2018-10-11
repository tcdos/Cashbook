<%
'账单列表[日期]
Sub CashList(ClassID,strDate,st,et)
	Dim rs_CashList,sql_CashList
	Dim PostTime,strTitle,AmountStyle,st_et_tip
	Call OpenConn()
	sql_CashList = "Select distinct(PostTime) from [TC_Cash] where Title<>''"
	if ClassID<>"" then
		ClassID=IsSafeID(ClassID)
		sql_CashList=sql_CashList&" and SmallClassID="&ClassID
	end if	
	if strDate<>"" and GetStrLen(st)=0 and GetStrLen(et)=0 then
		strDate=IsSafeStr(ShowTime(strDate,2))
		sql_CashList=sql_CashList&" and PostTime=#"&strDate&"#"
	end if
	if st<>"" and et<>"" and GetStrLen(strDate)=0 then
		st=IsSafeStr(ShowTime(st,2))
		et=IsSafeStr(ShowTime(et,2))
		sql_CashList=sql_CashList&" and PostTime between #"&st&"# and #"&et&"#"
	end if
	sql_CashList=sql_CashList&" order by PostTime desc"
	if st<>"" and et<>"" then st_et_tip=" 时间从 <span class=""KeyWords"">"&st&"</span> 到 <span class=""KeyWords"">"&et&"</span> "
	if ClassID<>"" then Response.Write "<div class=""ListTip"">现在列出的是"&st_et_tip&"类别为 <span class=""KeyWords"">"&GetClassName("TC_CashClass",ClassID)&"</span> 的全部账单。<a href=""javascript:history.go(-1)"">(返回)</a></div>" & vbCrLf end if	
	if strDate<>"" and GetStrLen(st)=0 and GetStrLen(et)=0 then Response.Write "<div class=""ListTip"">现在列出的是时间为 <span class=""KeyWords"">"&strDate&"</span> 内的全部账单。(<a href=""Count.Asp?st="&strDate&"&et="&strDate&""">统计</a> - <a href=""javascript:history.go(-1)"">返回</a>)</div>" & vbCrLf  end if
	Call SetRS(rs_CashList,sql_CashList,1,1)
	if rs_CashList.bof and rs_CashList.eof then
		Response.Write "<table class=""DataTab"" width=""798"" id=""tab"">" & vbCrLf
		Response.Write "<tr>" & vbCrLf
		Response.Write "<th height=""300""><a href=""Add.Asp"">您的账本还是空的哦，马上记上一笔吧！</a></th>" & vbCrLf
		Response.Write "</tr>" & vbCrLf
		Response.Write "</table>" & vbCrLf
		rs_CashList.close
		Set rs_CashList=Nothing
		Exit Sub
	else
		Response.Write "<table class=""DataTab"" width=""798"" id=""tab"">" & vbCrLf
		Response.Write "<thead>" & vbCrLf
		Response.Write "<tr>" & vbCrLf
		Response.Write "<th width=""138"">时间</th>" & vbCrLf
		Response.Write "<th width=""50"">类型</th>" & vbCrLf
		Response.Write "<th width=""155"">账单名称</th>" & vbCrLf
		Response.Write "<th width=""110"">类别</th>" & vbCrLf
		Response.Write "<th width=""90"">支付方式</th>" & vbCrLf
		Response.Write "<th width=""80"">金额</th>" & vbCrLf
		Response.Write "<th width=""80"">经手人</th>" & vbCrLf
		Response.Write "<th width=""90"">操作</th>" & vbCrLf
		Response.Write "</tr>" & vbCrLf
		Response.Write "</thead>" & vbCrLf
		Response.Write "<tbody>" & vbCrLf
		strFileName = "Main.Asp?ClassID="&ClassID&"&Date="&strDate&"&st="&st&"&et="&et
		totalPut = rs_CashList.RecordCount
		CurrentPage=Request.QueryString("Page")
		if CurrentPage="" or isnull(CurrentPage) or isempty(CurrentPage)  or Not IsNumeric(CurrentPage) then
			CurrentPage=1
		end if
		CurrentPage=Clng(CurrentPage)
		If CurrentPage < 1 Then
			CurrentPage = 1
		End If
		If (CurrentPage - 1) * MaxPerPage > totalPut Then
			If (totalPut Mod MaxPerPage) = 0 Then
				CurrentPage = totalPut \ MaxPerPage
			Else
				CurrentPage = totalPut \ MaxPerPage + 1
			End If
		End If
		If CurrentPage > 1 Then
			If (CurrentPage - 1) * MaxPerPage < totalPut Then
				rs_CashList.Move (CurrentPage - 1) * MaxPerPage
			Else
				CurrentPage = 1
			End If
		End If	
		Do While Not rs_CashList.EOF
			PostTime=rs_CashList("PostTime")
			Response.Write "<tr>" & vbCrLf
			Response.Write "<th><a href=""Main.Asp?Date="&ShowTime(PostTime,2)&""">"&ShowTime(PostTime,4)&"</a><br><span class=""minTxt"">"&EnWeekName(PostTime)&" +"&GetstrDateCount(1,ClassID,PostTime)&" -"&GetstrDateCount(0,ClassID,PostTime)&"</span></th>" & vbCrLf 
			Response.Write "<th colspan=""7"">" & vbCrLf 
			Call RecList(PostTime,ClassID)
			Response.Write"</th>" & vbCrLf 
			Response.Write "</tr>" & vbCrLf	
			iCount = iCount + 1
			If iCount >= MaxPerPage Then Exit Do
			rs_CashList.MoveNext
		Loop
		Response.Write "</tbody>" & vbCrLf
		Response.Write "</table>" & vbCrLf
		rs_CashList.close
		Set rs_CashList=Nothing
		Call ShowPage(strFileName, totalPut, MaxPerPage, CurrentPage, True, True, "天" ,"PageList")
	end if
End Sub

'账单列表[记录]
Sub RecList(strDate,ClassID)
	Dim rs_RecList,sql_RecList
	Dim ID,Title,BigClassID,SmallClassID,PayClassID,Amount,Summary,UserName,NickName
	Dim strTitle,AmountStyle
	Call OpenConn()
	sql_RecList = "Select ID,Title,BigClassID,SmallClassID,PayClassID,Amount,Summary,UserName from [TC_Cash] where PostTime=#"&strDate&"#"
	if ClassID<>"" then
		ClassID=IsSafeID(ClassID)
		sql_RecList=sql_RecList&" and SmallClassID="&ClassID
	end if
	sql_RecList=sql_RecList&" order by BigClassID asc,SmallClassID asc,ID asc"	
	Call SetRS(rs_RecList,sql_RecList,1,1)
	if rs_RecList.bof and rs_RecList.eof then
		rs_RecList.close
		Set rs_RecList=Nothing
		Exit Sub
	else
		Response.Write "<table width=""670"" class=""min_DataTab"">" & vbCrLf
		Do While Not rs_RecList.eof
			ID=rs_RecList("ID")
			Title=rs_RecList("Title")
			BigClassID=rs_RecList("BigClassID")
			SmallClassID=rs_RecList("SmallClassID")
			PayClassID=rs_RecList("PayClassID")
			Amount=rs_RecList("Amount")
			Summary=rs_RecList("Summary")
			UserName=rs_RecList("UserName")
			NickName=Conn.ExeCute("Select NickName From [TC_User] Where UserName='"&UserName&"'")(0)
			if GetStrLen(Summary)<=0 then strTitle=Title else strTitle=Summary end if
			if Amount>100 then AmountStyle="RedTxt" else AmountStyle="" end if
			Response.Write "<tr>" & vbCrLf
			Response.Write "<td width=""50""><img src=""Images/"&BigClassID&".gif""></td>" & vbCrLf 
			Response.Write "<td width=""145"" class=""dtLeft""><a href=""Add.Asp?ID="&ID&"&Page="&CurrentPage&""" title="""&strTitle&""" class=""tooltip"">"&Title&"</a></td>" & vbCrLf
			Response.Write "<td width=""110""><a href=""Main.Asp?ClassID="&SmallClassID&""">"&GetClassName("TC_CashClass",SmallClassID)&"</a></td>" & vbCrLf			
			Response.Write "<td width=""90"">"&GetClassName("TC_PayClass",PayClassID)&"</td>" & vbCrLf
			Response.Write "<td width=""80""><span class="""&AmountStyle&""">"&FormatNumber(Amount,2)&"</span></td>" & vbCrLf
			Response.Write "<td width=""80"">"&NickName&"</td>" & vbCrLf
			Response.Write "<td width=""90""><a href="""&strFileName&"&ID="&ID&"&Action=Del"" title=""删除"" onClick=""return confirm('确定删除吗？此操作将不能恢复！');""><img src=""Images/del.gif""> <a href=""Add.Asp?ID="&ID&"&Page="&CurrentPage&""" title=""编辑""><img src=""Images/edit.gif""></a>  <a href=""Add.Asp?Date="&strDate&"&Page="&CurrentPage&""" title=""补记一笔""><img src=""Images/ins.gif""></a></td>" & vbCrLf
			Response.Write "</tr>" & vbCrLf	
			If rs_RecList.eof Then Exit Do
			rs_RecList.MoveNext
		Loop
		Response.Write "</table>" & vbCrLf
		rs_RecList.close
		Set rs_RecList=Nothing
	end if
End Sub

'删除账单
Sub CashDel()
	Dim ID,Page,ClassID,PayID,strDate
	Dim sql_Del,rs_Del
	ID=IsSafeID(Request.QueryString("ID"))
	Page=Request.QueryString("Page")
	ClassID=GetValue("ClassID")
	PayID=GetValue("PayID")
	strDate=GetValue("Date")
	sql_Del="Delete from [TC_Cash] where ID="&ID
	Call OpenConn()
	Conn.ExeCute(sql_Del)
	Call CloseConn()
	Call Alert("删除成功，请返回！","Main.Asp?ClassID="&ClassID&"&PayID="&PayID&"&Date="&strDate&"&Page="&Page)
End Sub
%>