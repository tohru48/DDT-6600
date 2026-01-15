using System;
using System.Collections.Specialized;
using System.Configuration;
using System.Reflection;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;
using Bussiness;
using log4net;
using Tank.Request.Illegalcharacters;

namespace Tank.Request
{
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class VisualizeRegister : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		private static FileSystem fileIllegal = new FileSystem(HttpContext.Current.Server.MapPath(IllegalCharacters), HttpContext.Current.Server.MapPath(IllegalDirectory), "*.txt");

		public static string IllegalCharacters => ConfigurationManager.AppSettings["IllegalCharacters"];

		public static string IllegalDirectory => ConfigurationManager.AppSettings["IllegalDirectory"];

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			LanguageMgr.Setup(ConfigurationManager.AppSettings["ReqPath"]);
			bool flag = false;
			string translation = LanguageMgr.GetTranslation("Tank.Request.VisualizeRegister.Fail1");
			XElement xElement = new XElement("Result");
			try
			{
				NameValueCollection @params = context.Request.Params;
				string text = @params["Name"];
				string text2 = @params["Pass"];
				string text3 = @params["NickName"].Trim().Replace(",", "");
				string armColor = @params["Arm"];
				string hairColor = @params["Hair"];
				string faceColor = @params["Face"];
				string clothColor = @params["Cloth"];
				string hatColor = @params["Cloth"];
				string text4 = @params["ArmID"];
				string text5 = @params["HairID"];
				string text6 = @params["FaceID"];
				string text7 = @params["ClothID"];
				string text8 = @params["ClothID"];
				int num = -1;
				if (bool.Parse(ConfigurationManager.AppSettings["MustSex"]))
				{
					num = (bool.Parse(@params["Sex"]) ? 1 : 0);
				}
				if (Encoding.Default.GetByteCount(text3) <= 14)
				{
					if (!fileIllegal.checkIllegalChar(text3))
					{
						if (!string.IsNullOrEmpty(text) && !string.IsNullOrEmpty(text2) && !string.IsNullOrEmpty(text3))
						{
							string[] array = ((num == 1) ? ConfigurationManager.AppSettings["BoyVisualizeItem"].Split(';') : ConfigurationManager.AppSettings["GrilVisualizeItem"].Split(';'));
							text4 = array[0].Split(',')[0];
							text5 = array[0].Split(',')[1];
							text6 = array[0].Split(',')[2];
							text7 = array[0].Split(',')[3];
							text8 = array[0].Split(',')[4];
							armColor = "";
							hairColor = "";
							faceColor = "";
							clothColor = "";
							hatColor = "";
							using PlayerBussiness playerBussiness = new PlayerBussiness();
							string text9 = text4 + "," + text5 + "," + text6 + "," + text7 + "," + text8;
							if (playerBussiness.RegisterPlayer(text, text2, text3, text9, text9, armColor, hairColor, faceColor, clothColor, hatColor, num, ref translation, int.Parse(ConfigurationManager.AppSettings["ValidDate"])))
							{
								flag = true;
								translation = LanguageMgr.GetTranslation("Tank.Request.VisualizeRegister.Success");
							}
						}
						else
						{
							translation = LanguageMgr.GetTranslation("!string.IsNullOrEmpty(name) && !");
						}
					}
					else
					{
						translation = LanguageMgr.GetTranslation("Tank.Request.VisualizeRegister.Illegalcharacters");
					}
				}
				else
				{
					translation = LanguageMgr.GetTranslation("Tank.Request.VisualizeRegister.Long");
				}
			}
			catch (Exception exception)
			{
				log.Error("VisualizeRegister", exception);
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", translation));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}
	}
}
