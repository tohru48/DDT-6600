<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Tank.Flash._Default" %>

<html>

<head id="Head1" runat="server">
<title>Bombom Project</title>
    <script type="text/javascript" src="script/jquery.js"></script>
    <script type="text/javascript" src="script/dandantang.js"></script>
    <script type="text/javascript" src="script/rightClick.js"></script>
    <script type="text/javascript" src="script/swfobject.js"></script>
    <script type="text/javascript" src="script/isSafeFlash.js"></script>
<style type="text/css"> 
    html, body	{ height:100%; }
      body
        {
		margin: 0;
		padding: 0;
		background-color: #323338;
		overflow: hidden;
       
    </style>
   
</head>
<body scroll="no">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td valign="middle">
                <table border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="center">
                            <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" id="7road-ddt-game"
                                codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0"
                                name="Main" width="1000" height="600" align="middle" id="Main">
                                <param name="allowScriptAccess" value="always" />
                                <param name="movie" value="<%=Flash %>Loading.swf?<%=Content %>&config=<%=Config %>" />
                                <param name="quality" value="high" />
                                <param name="menu" value="false">
                                <param name="bgcolor" value="#000000" />
                                <param name="FlashVars" value="<%=AutoParam %>" />
                                <param name="allowScriptAccess" value="always" />
                                <embed flashvars="<%=AutoParam %>" src="<%=Flash %>Loading.swf?<%=Content %>&config=<%=Config %>"
                                    width="1000" height="600" align="middle" quality="high" name="Main" allowscriptaccess="always"
                                    type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
                            </object>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
