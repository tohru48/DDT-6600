using System;
using System.Configuration;
using System.Reflection;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.SessionState;
using System.Xml.Linq;
using Bussiness;
using Bussiness.Interface;
using log4net;
using Road.Flash;
using SqlDataProvider.Data;

namespace Tank.Request
{
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class Login : IHttpHandler, IRequiresSessionState
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			LanguageMgr.Setup(ConfigurationManager.AppSettings["ReqPath"]);
			bool flag = false;
			string translation = LanguageMgr.GetTranslation("Tank.Request.Login.Fail1");
			bool flag2 = false;
			XElement xElement = new XElement("Result");
			try
			{
				BaseInterface baseInterface = BaseInterface.CreateInterface();
				string text = context.Request["p"];
				string site = ((context.Request["site"] == null) ? "" : HttpUtility.UrlDecode(context.Request["site"]));
				string userHostAddress = context.Request.UserHostAddress;
				if (string.IsNullOrEmpty(text))
				{
					return;
				}
				byte[] array = CryptoHelper.RsaDecryt2(StaticFunction.RsaCryptor, text);
				string[] array2 = Encoding.UTF8.GetString(array, 7, array.Length - 7).Split(',');
				if (array2.Length != 4)
				{
					return;
				}
				string userName = array2[0];
				string text3 = array2[1];
				string userPass = array2[2];
				string nickname = array2[3];
				if (PlayerManager.Login(userName.ToLower(), text3.ToLower()))
				{
					int num = 0;
					bool flag3 = false;
					bool byUserIsFirst = PlayerManager.GetByUserIsFirst(userName);
					PlayerInfo playerInfo = baseInterface.CreateLogin(userName, userPass,ref translation, ref num, userHostAddress, ref flag2, byUserIsFirst, ref flag3, site, nickname);
					if (playerInfo != null && !flag2)
					{
						if (num == 0)
						{
							PlayerManager.Update(userName, userPass);
						}
						else
						{
							PlayerManager.Remove(userName);
						}
						string text5 = (string.IsNullOrEmpty(playerInfo.Style) ? ",,,,,,,," : playerInfo.Style);
						playerInfo.Colors = (string.IsNullOrEmpty(playerInfo.Colors) ? ",,,,,,,," : playerInfo.Colors);
						XElement content = new XElement("Item", new XAttribute("ID", playerInfo.ID), new XAttribute("IsFirst", num), new XAttribute("NickName", playerInfo.NickName), new XAttribute("Date", ""), new XAttribute("IsConsortia", 0), new XAttribute("ConsortiaID", playerInfo.ConsortiaID), new XAttribute("Sex", playerInfo.Sex), new XAttribute("WinCount", playerInfo.Win), new XAttribute("TotalCount", playerInfo.Total), new XAttribute("EscapeCount", playerInfo.Escape), new XAttribute("DutyName", (playerInfo.DutyName == null) ? "" : playerInfo.DutyName), new XAttribute("GP", playerInfo.GP), new XAttribute("Honor", ""), new XAttribute("Style", (playerInfo.Style == null) ? text5 : playerInfo.Style), new XAttribute("Gold", playerInfo.Gold), new XAttribute("Colors", (playerInfo.Colors == null) ? "" : playerInfo.Colors), new XAttribute("Attack", playerInfo.Attack), new XAttribute("Defence", playerInfo.Defence), new XAttribute("Agility", playerInfo.Agility), new XAttribute("Luck", playerInfo.Luck), new XAttribute("Grade", playerInfo.Grade), new XAttribute("Hide", playerInfo.Hide), new XAttribute("Repute", playerInfo.Repute), new XAttribute("ConsortiaName", (playerInfo.ConsortiaName == null) ? "" : playerInfo.ConsortiaName), new XAttribute("Offer", playerInfo.Offer), new XAttribute("Skin", (playerInfo.Skin == null) ? "" : playerInfo.Skin), new XAttribute("ReputeOffer", playerInfo.ReputeOffer), new XAttribute("ConsortiaHonor", playerInfo.ConsortiaHonor), new XAttribute("ConsortiaLevel", playerInfo.ConsortiaLevel), new XAttribute("ConsortiaRepute", playerInfo.ConsortiaRepute), new XAttribute("Money", playerInfo.Money), new XAttribute("AntiAddiction", playerInfo.AntiAddiction), new XAttribute("IsMarried", playerInfo.IsMarried), new XAttribute("SpouseID", playerInfo.SpouseID), new XAttribute("SpouseName", (playerInfo.SpouseName == null) ? "" : playerInfo.SpouseName), new XAttribute("MarryInfoID", playerInfo.MarryInfoID), new XAttribute("IsCreatedMarryRoom", playerInfo.IsCreatedMarryRoom), new XAttribute("IsGotRing", playerInfo.IsGotRing), new XAttribute("LoginName", (playerInfo.UserName == null) ? "" : playerInfo.UserName), new XAttribute("Nimbus", playerInfo.Nimbus), new XAttribute("FightPower", playerInfo.FightPower), new XAttribute("AnswerSite", playerInfo.AnswerSite), new XAttribute("WeaklessGuildProgressStr", (playerInfo.WeaklessGuildProgressStr == null) ? "" : playerInfo.WeaklessGuildProgressStr), new XAttribute("IsOldPlayer", playerInfo.IsOldPlayer));
						xElement.Add(content);
						flag = true;
						translation = LanguageMgr.GetTranslation("Tank.Request.Login.Success");
					}
					else
					{
						PlayerManager.Remove(userName);
					}
				}
				else
				{
					log.Error(userName + ": " + text3);
				}
			}
			catch (Exception exception)
			{
				log.Error("User Login error", exception);
				flag = false;
				translation = LanguageMgr.GetTranslation("Tank.Request.Login.Fail2");
			}
			finally
			{
				xElement.Add(new XAttribute("value", flag));
				xElement.Add(new XAttribute("message", translation));
				context.Response.ContentType = "text/plain";
				context.Response.Write(xElement.ToString(check: false));
			}
		}
	}
}
