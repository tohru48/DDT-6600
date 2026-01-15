using System;
using System.Configuration;
using System.Linq;
using System.Reflection;
using System.Web.UI;
using log4net;

namespace Tank.Request
{
	public class KitoffUser : Page
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
			bool flag = false;
			try
			{
				if (!ValidLoginIP(Context.Request.UserHostAddress))
				{
				}
			}
			catch (Exception exception)
			{
				log.Error("GetAdminIP:", exception);
			}
			base.Response.Write(flag);
		}
	}
}
