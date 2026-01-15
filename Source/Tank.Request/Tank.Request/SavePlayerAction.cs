using System;
using System.Web;
using System.Xml.Linq;

namespace Tank.Request
{
	public class SavePlayerAction : IHttpHandler
	{
		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			int num = Convert.ToInt32(context.Request["selfid"]);
			string text = context.Request["key"];
			XElement xElement = new XElement("Result");
			bool flag = true;
			string value = "Success!";
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString());
		}
	}
}
