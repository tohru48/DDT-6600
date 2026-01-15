using System;
using System.Reflection;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;
using Bussiness;
using log4net;

namespace Tank.Request
{
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class AdvanceQuestTime : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			bool flag = false;
			string value = "Fail!";
			XElement xElement = new XElement("Result");
			try
			{
				int num = Convert.ToInt32(context.Request["userid"]);
				int num2 = Convert.ToInt32(context.Request["selfid"]);
				string text = context.Request["key"];
				using (new PlayerBussiness())
				{
				}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error("advancequestionread", exception);
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			context.Response.ContentType = "text/plain";
			context.Response.Write($"0,{DateTime.Now},0");
		}
	}
}
