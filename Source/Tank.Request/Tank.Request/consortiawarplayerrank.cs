using System.Web;
using System.Xml.Linq;
using Bussiness;

namespace Tank.Request
{
	public class consortiawarplayerrank : IHttpHandler
	{
		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			string value = context.Request["ConsortiaID"];
			string value2 = context.Request["UserID"];
			bool flag = true;
			string value3 = "sucess!";
			XElement xElement = new XElement("Result");
			if (!string.IsNullOrEmpty(value) && !string.IsNullOrEmpty(value2))
			{
				XElement content = new XElement("Item", new XAttribute("Rank", 1), new XAttribute("ConsortiaID", value), new XAttribute("Name", "Sociedade"), new XAttribute("Score", 99), new XAttribute("UserID", value2), new XAttribute("ZoneName", "Canal"), new XAttribute("ZoneID", 4));
				xElement.Add(content);
				flag = true;
				value3 = "Success!";
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value3));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}
	}
}
