using System;
using System.Configuration;
using System.Reflection;
using System.Text;
using System.Web;
using System.Xml.Linq;
using Bussiness;
using log4net;

namespace Tank.Request
{
	public class ConsortiaNameCheck : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			LanguageMgr.Setup(ConfigurationManager.AppSettings["ReqPath"]);
			bool flag = false;
			string translation = LanguageMgr.GetTranslation("Tank.Request.ConsortiaCheck.Exist");
			XElement xElement = new XElement("Result");
			try
			{
				string text = csFunction.ConvertSql(HttpUtility.UrlDecode(context.Request["NickName"]));
				if (Encoding.Default.GetByteCount(text) <= 14)
				{
					if (!string.IsNullOrEmpty(text))
					{
						using ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
						if (consortiaBussiness.GetConsortiaSingleByName(text) == null)
						{
							flag = true;
							translation = LanguageMgr.GetTranslation("Tank.Request.ConsortiaCheck.Right");
						}
					}
				}
				else
				{
					translation = LanguageMgr.GetTranslation("Tank.Request.ConsortiaCheck.Long");
				}
			}
			catch (Exception exception)
			{
				log.Error("ConsortiaCheck", exception);
				flag = false;
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", translation));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}
	}
}
