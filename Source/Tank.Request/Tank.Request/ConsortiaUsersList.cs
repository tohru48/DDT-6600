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
	public class ConsortiaUsersList : IHttpHandler
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
				int userID = int.Parse(context.Request["userID"]);
				int state = int.Parse(context.Request["state"]);
				using ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
				ConsortiaUserInfo[] consortiaUsersPage = consortiaBussiness.GetConsortiaUsersPage(page, size, ref num, order, consortiaID, userID, state);
				ConsortiaUserInfo[] array = consortiaUsersPage;
				for (int i = 0; i < array.Length; i++)
				{
					ConsortiaUserInfo info = array[i];
					xElement.Add(FlashUtils.CreateConsortiaUserInfo(info));
				}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error("ConsortiaUsersList", exception);
			}
			xElement.Add(new XAttribute("total", num));
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			xElement.Add(new XAttribute("currentDate", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")));
			context.Response.ContentType = "text/plain";
			context.Response.BinaryWrite(StaticFunction.Compress(xElement.ToString(check: false)));
		}
	}
}
