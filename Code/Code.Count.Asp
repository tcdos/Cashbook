<%
'统计列表
Sub CountClassList(BigClassID)
	Dim rs_CountClassList,sql_CountClassList
	Dim ID,ClassName
	Call OpenConn()
	sql_CountClassList = "Select ID,ClassName from [TC_CashClass] where ClassName<>'' and FatherID="&BigClassID&" order by ID asc"
	Call SetRS(rs_CountClassList,sql_CountClassList,1,1)
	if rs_CountClassList.bof and rs_CountClassList.eof then
		rs_CountClassList.close
		Set rs_CountClassList=Nothing
		Exit Sub
	else
		Do While Not rs_CountClassList.eof
			ID=rs_CountClassList("ID")
			ClassName=rs_CountClassList("ClassName")
			if GetSmallClassCount(ID,GetValue("st"),GetValue("et"))>0 then
				Response.Write "<div class=""MainCountClassList""><div class=""MainCountClassList_txt"">"&ClassName&"："&FormatNumber(GetSmallClassCount(ID,GetValue("st"),GetValue("et")),2)&" / "&GetPer(GetSmallClassCount(ID,GetValue("st"),GetValue("et")),GetBigClassCount(BigClassID,GetValue("st"),GetValue("et")))&" <a href=""Main.Asp?ClassID="&ID&"&st="&GetValue("st")&"&et="&GetValue("et")&"""><span class=""GrayTxt"">("&GetRecordCount("SmallClassID",ID,GetValue("st"),GetValue("et"))&")</span></a></div><div class=""MainCountClassList_per""><div class=""MainCountClassList_per_"" style=""width:"&GetPer(GetSmallClassCount(ID,GetValue("st"),GetValue("et")),GetBigClassCount(BigClassID,GetValue("st"),GetValue("et")))&";""></div></div><div class=""clear""></div></div> " & vbCrLf
			end if
			If rs_CountClassList.EOF Then Exit Do
			rs_CountClassList.MoveNext
		Loop
		Response.Write "<div class=""clear""></div>" & vbCrLf
		rs_CountClassList.close
		Set rs_CountClassList=Nothing	
	end if
End Sub

'系统提示[起始日期-结束日期]
Function CountTip()
	Dim st:st=GetValue("st")
	Dim et:et=GetValue("et")
	if st<>"" and et<>"" then
		Response.Write "<div class=""CountTip"">现在列出的是从 <span class=""KeyWords""><strong>"&st&"</strong></span> - <span class=""KeyWords""><strong>"&et&"</strong></span> 的统计结果。<a href=""Count.Asp"">(返回)</a></div>" & vbCrLf
	end if
End Function

'定义相关日期参数值
Dim LastMonth_st:LastMonth_st=Dateadd("M",-1,Year(Date)&"-"&Month(Date)&"-1")
Dim LastMonth_et:LastMonth_et=Dateadd("D",-1,Year(Date)&"-"&Month(Date)&"-1")
Dim ThisMonth_st:ThisMonth_st=Year(Date)&"-"&Month(Date)&"-1"
Dim ThisMonth_et:ThisMonth_et=Dateadd("D",-1,Dateadd("M",1,Year(Date)&"-"&Month(Date)&"-1"))
Dim ThisDay_st:ThisDay_st=Dateadd("M",-1,Year(Date)&"-"&Month(Date)&"-"&Day(Date))
Dim ThisDay_et:ThisDay_et=Year(Date)&"-"&Month(Date)&"-"&Day(Date)
%>