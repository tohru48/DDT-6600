using System;
using System.Reflection;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;
using Bussiness;
using log4net;
using SqlDataProvider.Data;

namespace Tank.Request
{
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class LoadUsersSort : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			bool flag = false;
			string value = "Fail!";
			XElement xElement = new XElement("Result");
			int num = 0;
			try
			{
				int page = 1;
				int size = 10;
				int order = int.Parse(context.Request["order"]);
				int userID = -1;
				bool flag2 = false;
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				PlayerInfo[] playerPage = playerBussiness.GetPlayerPage(page, size, ref num, order, userID, ref flag2);
				if (flag2)
				{
					PlayerInfo[] array = playerPage;
					for (int i = 0; i < array.Length; i++)
					{
						PlayerInfo playerInfo = array[i];
						XElement content = new XElement("Item", new XAttribute("ID", playerInfo.ID), new XAttribute("NickName", (playerInfo.NickName == null) ? "" : playerInfo.NickName), new XAttribute("Grade", playerInfo.Grade), new XAttribute("Colors", (playerInfo.Colors == null) ? "" : playerInfo.Colors), new XAttribute("Skin", (playerInfo.Skin == null) ? "" : playerInfo.Skin), new XAttribute("Sex", playerInfo.Sex), new XAttribute("Style", (playerInfo.Style == null) ? "" : playerInfo.Style), new XAttribute("ConsortiaName", (playerInfo.ConsortiaName == null) ? "" : playerInfo.ConsortiaName), new XAttribute("Hide", playerInfo.Hide), new XAttribute("Offer", playerInfo.Offer), new XAttribute("ReputeOffer", playerInfo.ReputeOffer), new XAttribute("ConsortiaHonor", playerInfo.ConsortiaHonor), new XAttribute("ConsortiaLevel", playerInfo.ConsortiaLevel), new XAttribute("ConsortiaRepute", playerInfo.ConsortiaRepute), new XAttribute("WinCount", playerInfo.Win), new XAttribute("TotalCount", playerInfo.Total), new XAttribute("EscapeCount", playerInfo.Escape), new XAttribute("Repute", playerInfo.Repute), new XAttribute("GP", playerInfo.GP));
						xElement.Add(content);
					}
					flag = true;
					value = "Success!";
				}
			}
			catch (Exception exception)
			{
				log.Error("LoadUsersSort", exception);
			}
			xElement.Add(new XAttribute("total", num));
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}
	}
}
