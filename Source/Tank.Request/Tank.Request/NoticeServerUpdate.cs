using System;
using System.Configuration;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.UI;
using Bussiness.CenterService;
using Bussiness.Interface;
using log4net;

namespace Tank.Request
{
	public class NoticeServerUpdate : Page
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public static string GetAdminIP => ConfigurationManager.AppSettings["AdminIP"];

		public static bool ValidLoginIP(string ip)
		{
			string getAdminIP = GetAdminIP;
			return string.IsNullOrEmpty(getAdminIP) || getAdminIP.Split('|').Contains(ip);
		}

		protected void Page_Load(object sender, EventArgs e)
		{
			int num = 2;
			try
			{
				int serverId = int.Parse(Context.Request["serverID"]);
				int num2 = int.Parse(Context.Request["type"]);
				if (ValidLoginIP(Context.Request.UserHostAddress))
				{
					using (CenterServiceClient centerServiceClient = new CenterServiceClient())
					{
						num = centerServiceClient.NoticeServerUpdate(serverId, num2);
					}
					int num3 = num2;
					if (num3 == 5 && num == 0)
					{
						num = HandleServerMapUpdate();
					}
				}
				else
				{
					num = 5;
				}
			}
			catch (Exception exception)
			{
				log.Error("ExperienceRateUpdate:", exception);
				num = 4;
			}
			base.Response.Write(num);
		}

		private int HandleServerMapUpdate()
		{
			string url = "http://" + HttpContext.Current.Request.Url.Authority.ToString() + "/MapServerList.ashx";
			string text = BaseInterface.RequestContent(url);
			if (text.Contains("Success"))
			{
				return 0;
			}
			return 3;
		}
	}
}
