using System;
using System.Collections.Generic;
using System.Reflection;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;
using Bussiness;
using Bussiness.CenterService;
using log4net;
using Road.Flash;

namespace Tank.Request
{
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class ServerList : IHttpHandler
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
				using (CenterServiceClient centerServiceClient = new CenterServiceClient())
				{
					IList<ServerData> serverList = centerServiceClient.GetServerList();
					foreach (ServerData current in serverList)
					{
						if (current.State != -1)
						{
							num += current.Online;
							xElement.Add(FlashUtils.CreateServerInfo(current.Id, current.Name, current.Ip, current.Port, current.State, current.MustLevel, current.LowestLevel, current.Online));
						}
					}
				}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error("Load server list error:", exception);
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			xElement.Add(new XAttribute("total", num));
			xElement.Add(new XAttribute("agentId", 1));
			xElement.Add(new XAttribute("AreaName", "gn"));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}
	}
}
