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
	public class ConsortiaInviteUsersList : IHttpHandler
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
				int userID = int.Parse(context.Request["userID"]);
				int inviteID = int.Parse(context.Request["inviteID"]);
				using ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
				ConsortiaInviteUserInfo[] consortiaInviteUserPage = consortiaBussiness.GetConsortiaInviteUserPage(page, size, ref num, order, userID, inviteID);
				ConsortiaInviteUserInfo[] array = consortiaInviteUserPage;
				for (int i = 0; i < array.Length; i++)
				{
					ConsortiaInviteUserInfo info = array[i];
					xElement.Add(FlashUtils.CreateConsortiaInviteUserInfo(info));
				}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error("ConsortiaInviteUsersList", exception);
			}
			xElement.Add(new XAttribute("total", num));
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}
	}
}
