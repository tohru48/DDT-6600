using System;
using System.Web;
using System.Xml.Linq;
using Bussiness;

namespace Tank.Request
{
	public class GiftRecieveLog : IHttpHandler
	{
		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			bool flag = false;
			string value = "Fail!";
			XElement xElement = new XElement("Result");
			try
			{
				flag = true;
				value = "Success!";
			}
			catch (Exception)
			{
			}
			finally
			{
				xElement.Add(new XAttribute("value", flag));
				xElement.Add(new XAttribute("message", value));
				context.Response.ContentType = "text/plain";
				context.Response.BinaryWrite(StaticFunction.Compress(xElement.ToString(check: false)));
			}
		}
	}
}
