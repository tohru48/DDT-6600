using System;
using System.Web;
using System.Xml.Linq;
using Bussiness;

namespace Tank.Request
{
	public class nicknamerandom : IHttpHandler
	{
		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			try
			{
				string text = "unknown";
				XElement xElement = new XElement("Result");
				int sex = Convert.ToInt32(context.Request["sex"]);
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					text = playerBussiness.GetSingleRandomName(sex);
				}
				Random random = new Random();
				text = text + " " + random.Next(111, 999);
				xElement.Add(new XAttribute("name", text));
				context.Response.ContentType = "text/plain";
				context.Response.Write(xElement.ToString());
			}
			catch (Exception)
			{
			}
		}
	}
}
