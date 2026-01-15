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
	public class ConsortiaList : IHttpHandler
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
				string name = csFunction.ConvertSql(HttpUtility.UrlDecode(context.Request["name"]));
				int level = int.Parse(context.Request["level"]);
				int openApply = int.Parse(context.Request["openApply"]);
				using ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
				ConsortiaInfo[] consortiaPage = consortiaBussiness.GetConsortiaPage(page, size, ref num, order, name, consortiaID, level, openApply);
				ConsortiaInfo[] array = consortiaPage;
				for (int i = 0; i < array.Length; i++)
				{
					ConsortiaInfo info = array[i];
					xElement.Add(FlashUtils.CreateConsortiaInfo(info));
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
			context.Response.BinaryWrite(StaticFunction.Compress(xElement.ToString(check: false)));
		}
	}
}
