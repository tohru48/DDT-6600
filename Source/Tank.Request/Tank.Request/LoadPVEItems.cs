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
	public class LoadPVEItems : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			if (csFunction.ValidAdminIP(context.Request.UserHostAddress))
			{
				context.Response.Write(Build(context));
			}
			else
			{
				context.Response.Write("IP is not valid!");
			}
		}

		public static string Build(HttpContext context)
		{
			bool flag = false;
			string value = "Fail";
			XElement xElement = new XElement("Result");
			try
			{
				using (PveBussiness pveBussiness = new PveBussiness())
				{
					PveInfo[] allPveInfos = pveBussiness.GetAllPveInfos();
					PveInfo[] array = allPveInfos;
					for (int i = 0; i < array.Length; i++)
					{
						PveInfo m = array[i];
						xElement.Add(FlashUtils.CreatePveInfo(m));
					}
				}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error("LoadPVEItems", exception);
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			return csFunction.CreateCompressXml(context, xElement, "LoadPVEItems", isCompress: true);
		}
	}
}
