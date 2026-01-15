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
	public class ApprenticeshipClubList : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			bool flag = true;
			string value = "true!";
			bool flag2 = false;
			bool flag3 = false;
			XElement xElement = new XElement("Result");
			xElement.Add(new XAttribute("total", 0));
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			xElement.Add(new XAttribute("isPlayerRegeisted", flag2));
			xElement.Add(new XAttribute("isSelfPublishEquip", flag3));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}
	}
}
