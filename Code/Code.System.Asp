<%
'欢迎信息
Function WelSummary()
	Response.Write "<strong>"&Session("UserName")&"</strong>：您好，欢迎使用小钱袋子。"
	Response.Write "<span class=""MainCount_in"">总收入："&FormatNumber(GetBigClassCount(1,"",""),2)&"</span> | "
	Response.Write "<span class=""MainCount_out"">总支出："&FormatNumber(GetBigClassCount(2,"",""),2)&"</span> | "
	Response.Write "<span class=""MainCount_in"">借入："&FormatNumber(GetBigClassCount(3,"",""),2)&"</span> | "
	Response.Write "<span class=""MainCount_out"">借出："&FormatNumber(GetBigClassCount(4,"",""),2)&"</span> | "
	Response.Write "<span class=""MainCount_total"">结余："&FormatNumber((GetBigClassCount(1,"","")+GetBigClassCount(3,"","")-GetBigClassCount(2,"","")-GetBigClassCount(4,"","")),2)&"</span>"
End Function

'获取类别名称
Function GetClassName(DbTab,ID)
	Dim sql_ClassName,rs_ClassName
	sql_ClassName="Select ClassName From ["&DbTab&"] where ID="&ID
	Set rs_ClassName=Conn.ExeCute(sql_ClassName)
	if Not (rs_ClassName.bof and rs_ClassName.eof) then
		GetClassName=rs_ClassName("ClassName")
	else
		GetClassName="—"
	end if
	rs_ClassName.close
	set rs_ClassName=nothing
End Function

'获取统计结果[一级类别]
Function GetBigClassCount(BigClassID,st,et)
	Dim Rs_Count,Sql_Count
	Dim i
	if GetStrLen(st)=0 or GetStrLen(et)=0 then
		Sql_Count="Select Sum(Amount) As Num From [TC_Cash] where BigClassID="&BigClassID
	else
		if IsDate(st)=False or IsDate(et)=False then
			Call Alert("日期型参数出错，该操作已终止，请返回","")
			Exit Function
			Response.End()
		else
			st=IsSafeStr(ShowTime(st,2))
			et=IsSafeStr(ShowTime(et,2))		
			Sql_Count="Select Sum(Amount) As Num From [TC_Cash] where BigClassID="&BigClassID&" and PostTime between #"&st&"# and #"&et&"#"
		end if
	end if
	Call OpenConn()
	Set Rs_Count=Conn.Execute(Sql_Count)
	i=Rs_Count("Num")
	if i="" or isNull(i) or isEmpty(i) then i=0
	Rs_Count.Close
	Set Rs_Count=Nothing	
	GetBigClassCount=i
End Function

'获取统计结果[二级类别]
Function GetSmallClassCount(SmallClassID,st,et)
	Dim Rs_Count,Sql_Count
	Dim i
	if GetStrLen(st)=0 or GetStrLen(et)=0 then
		Sql_Count="Select Sum(Amount) As Num From [TC_Cash] where SmallClassID="&SmallClassID
	else
		if IsDate(st)=False or IsDate(et)=False then
			Call Alert("日期型参数出错，该操作已终止，请返回","")
			Exit Function
			Response.End()
		else
			st=IsSafeStr(ShowTime(st,2))
			et=IsSafeStr(ShowTime(et,2))		
			Sql_Count="Select Sum(Amount) As Num From [TC_Cash] where SmallClassID="&SmallClassID&" and PostTime between #"&st&"# and #"&et&"#"
		end if
	end if
	Call OpenConn()
	Set Rs_Count=Conn.Execute(Sql_Count)
	i=Rs_Count("Num")
	if i="" or isNull(i) or isEmpty(i) then i=0
	Rs_Count.Close
	Set Rs_Count=Nothing	
	GetSmallClassCount=i
End Function

'获取统计结果[指定日期]
Function GetstrDateCount(BigClassID,SmallClassID,strDate)
	Dim Rs_Count,Sql_Count
	Dim i
	if IsDate(strDate)=False then
		Call Alert("日期型参数出错，该操作已终止，请返回","")
		Exit Function
		Response.End()
	else
		strDate=IsSafeStr(ShowTime(strDate,2))
		if BigClassID=1 Then
			if GetStrLen(SmallClassID)>0 then
				Sql_Count="Select Sum(Amount) As Num From [TC_Cash] where (BigClassID=1 or BigClassID=3) and SmallClassID="&SmallClassID&" and PostTime=#"&strDate&"#"
			else
				Sql_Count="Select Sum(Amount) As Num From [TC_Cash] where (BigClassID=1 or BigClassID=3) and PostTime=#"&strDate&"#"				
			end if	
		else
			if GetStrLen(SmallClassID)>0 then
				Sql_Count="Select Sum(Amount) As Num From [TC_Cash] where (BigClassID=2 or BigClassID=4) and SmallClassID="&SmallClassID&" and PostTime=#"&strDate&"#"
			else
				Sql_Count="Select Sum(Amount) As Num From [TC_Cash] where (BigClassID=2 or BigClassID=4) and PostTime=#"&strDate&"#"				
			end if
		end if		
	end if
	Call OpenConn()
	Set Rs_Count=Conn.Execute(Sql_Count)
	i=Rs_Count("Num")
	if i="" or isNull(i) or isEmpty(i) then i=0
	Rs_Count.Close
	Set Rs_Count=Nothing	
	GetstrDateCount=i
End Function

'获取记录数
Function GetRecordCount(FieldName,SmallClassID,st,et)
	Dim Rs_Count,Sql_Count
	Dim i
	if GetStrLen(st)=0 or GetStrLen(et)=0 then
		Sql_Count="Select Count(ID) As Num From [TC_Cash] where "&FieldName&"="&SmallClassID
	else
		if IsDate(st)=False or IsDate(et)=False then
			Call Alert("日期型参数出错，该操作已终止，请返回","")
			Exit Function
			Response.End()
		else
			st=IsSafeStr(ShowTime(st,2))
			et=IsSafeStr(ShowTime(et,2))		
			Sql_Count="Select Count(ID) As Num From [TC_Cash] where "&FieldName&"="&SmallClassID&" and PostTime between #"&st&"# and #"&et&"#"
		end if
	end if	
	Call OpenConn()
	Set Rs_Count=Conn.Execute(Sql_Count)
	i=Rs_Count("Num")
	if i="" or isNull(i) or isEmpty(i) then i=0
	Rs_Count.Close
	Set Rs_Count=Nothing	
	GetRecordCount=i	
End Function

'获取百分比
Function GetPer(A,B)
	if B=0 then
		GetPer=0
	else
		GetPer=FormatPercent(A/B,2)
	end if
End Function
%>