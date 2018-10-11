<%
'检查Page参数是否为数值型
Function isChkInteger(Page)
	on Error resume next
	dim str,l,i
	'Page为Null
	if isnull(Page) then
		isChkInteger = false
		Exit Function
	End if
	'Page为空
	if isempty(Page) then
		isChkInteger = false
		Exit Function
	End if
	'Page转为字符型
	str = cstr(Page)
	if trim(str) = "" then
		isChkInteger = false
		Exit Function
	End if
	l = len(str)
	for i = 1 to l
	'检测Page是否为数值1～9
		if mid(str,i,1) > 9 or mid(str,i,1) < 0 then
			isChkInteger = false
			Exit Function
		End if
	next
	isChkInteger = true
	if err.Number <> 0 then err.Clear
End Function


'智能Url字符串替换：向Url中加入 ? 或 &
Function JoinChar(strUrl)
    If strUrl = "" Then
        JoinChar = ""
        Exit Function
    End If
    If InStr(strUrl, "?") < Len(strUrl) Then
        If InStr(strUrl, "?") > 1 Then
            If InStr(strUrl, "&") < Len(strUrl) Then
                JoinChar = strUrl & "&"
            Else
                JoinChar = strUrl
            End If
        Else
            JoinChar = strUrl & "?"
        End If
    Else
        JoinChar = strUrl
    End If
End Function


'分页函数[Tab]
Function ShowPage(sFileName, TotalNumber, MaxPerPage, CurrentPage, ShowTotal, ShowAllPages, strUnit ,StyleType)
    Dim TotalPage, strPageList, strUrl, i
	
	'参数检测
    If TotalNumber = 0 Or MaxPerPage = 0 Or IsNull(MaxPerPage) Then
        ShowPage = ""
        Exit Function
    End If
	
	'总页数
    If TotalNumber Mod MaxPerPage = 0 Then
        TotalPage = TotalNumber \ MaxPerPage
    Else
        TotalPage = TotalNumber \ MaxPerPage + 1
    End If
	
	'当前页
    If CurrentPage > TotalPage Then CurrentPage = TotalPage
	
	'列表开始
	if TypeName(StyleType)="Integer" then
    	strPageList = "<table width="""&StyleType&""" border=""0"" cellspacing=""5"" cellpadding=""5"" align=""center""><tr><td align=""center"">"
	else
		strPageList = "<div id="""&StyleType&""">"
	end if
	
	'链接地址处理
	strUrl =  JoinChar(sFileName)
	
	'首页、上一页
    If CurrentPage = 1 Then
        strPageList = strPageList & "<font color=#999999>首页 上一页</font> "
    Else
        strPageList = strPageList & "<a href='" & strUrl & "Page=1'>首页</a> "
        strPageList = strPageList & "<a href='" & strUrl & "Page=" & (CurrentPage - 1) & "'>上一页</a> "
    End If
	
	'下一页 尾页
    If CurrentPage >= TotalPage Then
        strPageList = strPageList & "<font color=#999999>下一页 尾页</font>"
    Else
        strPageList = strPageList & "<a href='" & strUrl & "Page=" & (CurrentPage + 1) & "'>下一页</a> "
        strPageList = strPageList & "<a href='" & strUrl & "Page=" & TotalPage & "'>尾页</a>"
    End If
	
	'页次
    strPageList = strPageList & " 页次：<strong><font color=red>" & CurrentPage & "</font>/" & TotalPage & "</strong>页"
	strPageList = strPageList & " <b>" & MaxPerPage & "</b>" & strUnit & "/页 "
	
	'是否用下拉列表显示所有页面以供跳转
    If ShowTotal = True Then
        strPageList = strPageList & " 共<b>" & TotalNumber & "</b> " & strUnit & " "
    End If
    If ShowAllPages = True Then
        If TotalPage > 50 Then
            strPageList = strPageList & " 转到第 <Input type='text' class='inputText' style='width:30px;'  name='Page' size='3' maxlength='5' value='" & CurrentPage & "' onKeyPress=""if (event.keyCode==13) window.location='" & strUrl & "Page=" & "'+this.value;""> 页"
        Else
            strPageList = strPageList & " 转到：<select name='Page' size='1' onchange=""javascript:window.location='" & strUrl & "Page=" & "'+this.options[this.selectedIndex].value;"">"
            For i = 1 To TotalPage
               strPageList = strPageList & "<option value='" & i & "'"
               If CLng(CurrentPage) = CLng(i) Then strPageList = strPageList & " selected "
               strPageList = strPageList & ">第" & i & "页</option>"
            Next
            strPageList = strPageList & "</select>"
        End If
    End If
	
	'列表结束
	if TypeName(StyleType)="Integer"  then
    	strPageList = strPageList & "</td></tr></table>"& vbCrLf
	else
		strPageList = strPageList & "</div>"& vbCrLf
	end if
	
    ShowPage = strPageList
	Response.Write( ShowPage )
End Function
%>