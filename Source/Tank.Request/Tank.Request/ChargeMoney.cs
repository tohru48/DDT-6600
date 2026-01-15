using System;
using System.Configuration;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.UI;
using Bussiness;
using Bussiness.CenterService;
using Bussiness.Interface;
using log4net;
using SqlDataProvider.Data;

namespace Tank.Request
{
	public class ChargeMoney : Page
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public static string GetChargeIP => ConfigurationManager.AppSettings["ChargeIP"];

		public static bool ValidLoginIP(string ip)
		{
			string getChargeIP = GetChargeIP;
			return string.IsNullOrEmpty(getChargeIP) || getChargeIP.Split('|').Contains(ip);
		}

		protected void Page_Load(object sender, EventArgs e)
		{
			int num = 1;
			try
			{
				string userHostAddress = Context.Request.UserHostAddress;
				if (ValidLoginIP(userHostAddress))
				{
					string content = HttpUtility.UrlDecode(base.Request["content"]);
					string site = ((base.Request["site"] == null) ? "" : HttpUtility.UrlDecode(base.Request["site"]).ToLower());
					string nickName = ((base.Request["nickname"] == null) ? "" : HttpUtility.UrlDecode(base.Request["nickname"]));
					BaseInterface baseInterface = BaseInterface.CreateInterface();
					string[] array = baseInterface.UnEncryptCharge(content, ref num, site);
					if (array.Length > 5)
					{
						string chargeID = array[0];
						string text = array[1].Trim();
						int num2 = int.Parse(array[2]);
						string text2 = array[3];
						decimal needMoney = decimal.Parse(array[4]);
						if (!string.IsNullOrEmpty(text))
						{
							text = BaseInterface.GetNameBySite(text, site);
							if (num2 > 0)
							{
								using PlayerBussiness playerBussiness = new PlayerBussiness();
								DateTime now = DateTime.Now;
								if (playerBussiness.AddChargeMoney(chargeID, text, num2, text2, needMoney, out var userID, ref num, now, userHostAddress, nickName))
								{
									num = 0;
									using CenterServiceClient centerServiceClient = new CenterServiceClient();
									centerServiceClient.ChargeMoney(userID, chargeID);
									using PlayerBussiness playerBussiness2 = new PlayerBussiness();
									PlayerInfo userSingleByUserID = playerBussiness2.GetUserSingleByUserID(userID);
									if (userSingleByUserID != null)
									{
										StaticsMgr.Log(now, text, userSingleByUserID.Sex, num2, text2, needMoney);
									}
									else
									{
										StaticsMgr.Log(now, text, sex: true, num2, text2, needMoney);
										log.Error("ChargeMoney_StaticsMgr:Player is null!");
									}
								}
							}
							else
							{
								num = 3;
							}
						}
						else
						{
							num = 2;
						}
					}
				}
				else
				{
					num = 5;
				}
			}
			catch (Exception exception)
			{
				log.Error("ChargeMoney:", exception);
			}
			base.Response.Write(num);
		}
	}
}
