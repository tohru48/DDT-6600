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
	public class MapServerList : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			context.Response.Write(Bulid(context));
		}

		public static string Bulid(HttpContext context)
		{
			bool flag = false;
			string value = "Fail";
			XElement xElement = new XElement("Result");
			try
			{
				using (MapBussiness mapBussiness = new MapBussiness())
				{
					ServerMapInfo[] allServerMap = mapBussiness.GetAllServerMap();
					ServerMapInfo[] array = allServerMap;
					for (int i = 0; i < array.Length; i++)
					{
						ServerMapInfo info = array[i];
						xElement.Add(FlashUtils.CreateMapServer(info));
					}
				}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error("MapServerList", exception);
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			return csFunction.CreateCompressXml(context, xElement, "MapServerList", isCompress: true);
		}
	}
}
