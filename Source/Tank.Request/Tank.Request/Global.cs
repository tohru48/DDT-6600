using System;
using System.Web;
using Bussiness;
using log4net.Config;

namespace Tank.Request
{
	public class Global : HttpApplication
	{
		protected void Application_Start(object sender, EventArgs e)
		{
			string path = base.Server.MapPath("~");
			LanguageMgr.Setup(path);
			XmlConfigurator.Configure();
			StaticsMgr.Setup();
			PlayerManager.Setup();
		}

		protected void Session_Start(object sender, EventArgs e)
		{
		}

		protected void Application_BeginRequest(object sender, EventArgs e)
		{
		}

		protected void Application_AuthenticateRequest(object sender, EventArgs e)
		{
		}

		protected void Application_Error(object sender, EventArgs e)
		{
		}

		protected void Session_End(object sender, EventArgs e)
		{
		}

		protected void Application_End(object sender, EventArgs e)
		{
			StaticsMgr.Stop();
		}
	}
}
