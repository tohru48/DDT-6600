using System;
using System.Reflection;
using System.Text;
using System.Web;
using System.Xml.Linq;
using Bussiness;
using Bussiness.CenterService;
using log4net;
using Road.Flash;

namespace Tank.Request
{
	public class ActivePullDown : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			int num = Convert.ToInt32(context.Request["selfid"]);
			int activeID = Convert.ToInt32(context.Request["activeID"]);
			string text = context.Request["key"];
			string text2 = context.Request["activeKey"];
			bool flag = false;
			string text3 = "ActivePullDownHandler.Fail";
			string awardID = "";
			XElement xElement = new XElement("Result");
			if (text2 != "")
			{
				byte[] array = CryptoHelper.RsaDecryt2(StaticFunction.RsaCryptor, text2);
				awardID = Encoding.UTF8.GetString(array, 0, array.Length);
			}
			try
			{
				using (ActiveBussiness activeBussiness = new ActiveBussiness())
				{
					if (activeBussiness.PullDown(activeID, awardID, num, ref text3) == 0)
					{
						using CenterServiceClient centerServiceClient = new CenterServiceClient();
						centerServiceClient.MailNotice(num);
					}
				}
				flag = true;
				text3 = LanguageMgr.GetTranslation(text3);
			}
			catch (Exception exception)
			{
				log.Error("ActivePullDown", exception);
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", text3));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}
	}
}
