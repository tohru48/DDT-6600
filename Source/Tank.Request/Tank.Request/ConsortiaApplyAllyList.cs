using System;
using System.Reflection;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;
using Bussiness;
using log4net;
using Road.Flash;
using SqlDataProvider.Data;

namespace Tank.Request
{
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class ConsortiaApplyAllyList : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			bool flag = false;
			string value = "Fail!";
			XElement xElement = new XElement("Result");
			int num = 0;
			try
			{
				int page = int.Parse(context.Request["page"]);
				int size = int.Parse(context.Request["size"]);
				int order = int.Parse(context.Request["order"]);
				int consortiaID = int.Parse(context.Request["consortiaID"]);
				int applyID = int.Parse(context.Request["applyID"]);
				int state = int.Parse(context.Request["state"]);
				using ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
				ConsortiaApplyAllyInfo[] consortiaApplyAllyPage = consortiaBussiness.GetConsortiaApplyAllyPage(page, size, ref num, order, consortiaID, applyID, state);
				ConsortiaApplyAllyInfo[] array = consortiaApplyAllyPage;
				for (int i = 0; i < array.Length; i++)
				{
					ConsortiaApplyAllyInfo info = array[i];
					xElement.Add(FlashUtils.CreateConsortiaApplyAllyInfo(info));
				}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error("ConsortiaApplyAllyList", exception);
			}
			xElement.Add(new XAttribute("total", num));
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}
	}
}
