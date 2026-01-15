using System;
using System.Reflection;
using System.Web;
using System.Xml.Linq;
using Bussiness;
using log4net;
using Road.Flash;

namespace Tank.Request
{
	public class scenecollecrandomnpc : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			bool flag = false;
			string value = "fail!";
			XElement xElement = new XElement("Result");
			try
			{
				using (new PlayerBussiness())
				{
					xElement.Add(FlashUtils.CreatescenecollecrandomnpcInfo());
					flag = true;
					value = "Success!";
				}
			}
			catch (Exception exception)
			{
				log.Error("subactivelist", exception);
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			context.Response.ContentType = "text/plain";
			context.Response.BinaryWrite(StaticFunction.Compress(xElement.ToString(check: false)));
		}
	}
}
