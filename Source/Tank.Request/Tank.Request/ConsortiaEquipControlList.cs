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
	public class ConsortiaEquipControlList : IHttpHandler
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
				int page = 1;
				int size = 10;
				int order = 1;
				int consortiaID = int.Parse(context.Request["consortiaID"]);
				int level = int.Parse(context.Request["level"]);
				int type = int.Parse(context.Request["type"]);
				using ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
				ConsortiaEquipControlInfo[] consortiaEquipControlPage = consortiaBussiness.GetConsortiaEquipControlPage(page, size, ref num, order, consortiaID, level, type);
				ConsortiaEquipControlInfo[] array = consortiaEquipControlPage;
				for (int i = 0; i < array.Length; i++)
				{
					ConsortiaEquipControlInfo info = array[i];
					xElement.Add(FlashUtils.CreateConsortiaEquipControlInfo(info));
				}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error("ConsortiaList", exception);
			}
			xElement.Add(new XAttribute("total", num));
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}
	}
}
