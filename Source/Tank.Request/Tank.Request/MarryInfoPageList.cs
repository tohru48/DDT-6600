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
	public class MarryInfoPageList : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			bool flag = false;
			string value = "Fail!";
			int num = 0;
			XElement xElement = new XElement("Result");
			try
			{
				int page = int.Parse(context.Request["page"]);
				string name = null;
				if (context.Request["name"] != null)
				{
					name = csFunction.ConvertSql(HttpUtility.UrlDecode(context.Request["name"]));
				}
				bool sex = bool.Parse(context.Request["sex"]);
				int size = 12;
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				MarryInfo[] marryInfoPage = playerBussiness.GetMarryInfoPage(page, name, sex, size, ref num);
				MarryInfo[] array = marryInfoPage;
				for (int i = 0; i < array.Length; i++)
				{
					MarryInfo info = array[i];
					XElement content = FlashUtils.CreateMarryInfo(info);
					xElement.Add(content);
				}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error("MarryInfoPageList", exception);
			}
			xElement.Add(new XAttribute("total", num));
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}
	}
}
