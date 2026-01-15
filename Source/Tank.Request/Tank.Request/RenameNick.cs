using System;
using System.Configuration;
using System.Reflection;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;
using Bussiness;
using Bussiness.Interface;
using log4net;
using Road.Flash;

namespace Tank.Request
{
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class RenameNick : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			LanguageMgr.Setup(ConfigurationManager.AppSettings["ReqPath"]);
			bool flag = false;
			string translation = LanguageMgr.GetTranslation("Tank.Request.RenameNick.Fail1");
			XElement xElement = new XElement("Result");
			try
			{
				BaseInterface baseInterface = BaseInterface.CreateInterface();
				string text = context.Request["p"];
				string arg_81_0 = ((context.Request["site"] == null) ? "" : HttpUtility.UrlDecode(context.Request["site"]));
				string userHostAddress = context.Request.UserHostAddress;
				if (!string.IsNullOrEmpty(text))
				{
					byte[] array = CryptoHelper.RsaDecryt2(StaticFunction.RsaCryptor, text);
					string[] array2 = Encoding.UTF8.GetString(array, 7, array.Length - 7).Split(',');
					if (array2.Length == 5)
					{
						string text2 = array2[0];
						string text3 = array2[1];
						string text4 = array2[2];
						string nickName = array2[3];
						string newNickName = array2[4];
						if (PlayerManager.Login(text2.ToLower(), text3.ToLower()))
						{
							using PlayerBussiness playerBussiness = new PlayerBussiness();
							if (playerBussiness.RenameNick(text2, nickName, newNickName, ref translation))
							{
								PlayerManager.Update(text2.ToLower(), text4.ToLower());
								flag = true;
								translation = LanguageMgr.GetTranslation("Tank.Request.RenameNick.Success");
							}
						}
					}
				}
			}
			catch (Exception exception)
			{
				log.Error("RenameNick", exception);
				flag = false;
				translation = LanguageMgr.GetTranslation("Tank.Request.RenameNick.Fail2");
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", translation));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}
	}
}
