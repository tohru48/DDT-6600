using System;
using System.Configuration;
using System.Reflection;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;
using Bussiness;
using log4net;

namespace Tank.Request
{
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class NickNameCheck : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			LanguageMgr.Setup(ConfigurationManager.AppSettings["ReqPath"]);
			bool flag = false;
			string translation = LanguageMgr.GetTranslation("Tank.Request.NickNameCheck.Exist");
			XElement xElement = new XElement("Result");
			try
			{
				string text = csFunction.ConvertSql(HttpUtility.UrlDecode(context.Request["NickName"]));
				if (Encoding.Default.GetByteCount(text) <= 14)
				{
					if (!string.IsNullOrEmpty(text))
					{
						using PlayerBussiness playerBussiness = new PlayerBussiness();
						if (playerBussiness.GetUserSingleByNickName(text) == null)
						{
							flag = true;
							translation = LanguageMgr.GetTranslation("Tank.Request.NickNameCheck.Right");
						}
					}
				}
				else
				{
					translation = LanguageMgr.GetTranslation("Tank.Request.NickNameCheck.Long");
				}
			}
			catch (Exception exception)
			{
				log.Error("NickNameCheck", exception);
				flag = false;
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", translation));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}
	}
}
