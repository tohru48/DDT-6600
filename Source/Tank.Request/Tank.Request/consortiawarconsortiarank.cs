using System.Web;
using System.Xml.Linq;
using Bussiness;

namespace Tank.Request
{
	public class consortiawarconsortiarank : IHttpHandler
	{
		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			bool flag = false;
			string value = "fail!";
			XElement xElement = new XElement("Result");
			XElement content = new XElement("Item", new object[0]);
			xElement.Add(content);
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}
	}
}
