using System;
using System.Configuration;
using System.Web;
using Bussiness.Interface;

namespace Tank.Request
{
	public class directlogin : IHttpHandler
	{
		public string PHP_Key => ConfigurationManager.AppSettings["PHP_Key"];

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			string text = context.Request["username"];
			string a = context.Request["phpkey"];
			string text2 = Guid.NewGuid().ToString();
			string text3 = BaseInterface.ConvertDateTimeInt(DateTime.Now).ToString();
			string text4 = string.Empty;
			if (a == PHP_Key)
			{
				if (string.IsNullOrEmpty(text4))
				{
					text4 = BaseInterface.GetLoginKey;
				}
				string text5 = BaseInterface.md5(text + text2 + text3.ToString() + text4);
				string url = BaseInterface.LoginUrl + "?content=" + HttpUtility.UrlEncode(text + "|" + text2 + "|" + text3.ToString() + "|" + text5);
				string a2 = BaseInterface.RequestContent(url);
				if (a2 == "0")
				{
					context.Response.Write(text2.ToUpper());
				}
				else
				{
					context.Response.Write("0");
				}
			}
			else
			{
				context.Response.Write("2");
			}
		}
	}
}
