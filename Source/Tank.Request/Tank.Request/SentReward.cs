using System;
using System.Configuration;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Services;
using Bussiness;
using Bussiness.Interface;
using log4net;

namespace Tank.Request
{
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class SentReward : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public static string GetSentRewardIP => ConfigurationManager.AppSettings["SentRewardIP"];

		public static string GetSentRewardKey => ConfigurationManager.AppSettings["SentRewardKey"];

		public bool IsReusable => false;

		public static bool ValidSentRewardIP(string ip)
		{
			string getSentRewardIP = GetSentRewardIP;
			return string.IsNullOrEmpty(getSentRewardIP) || getSentRewardIP.Split('|').Contains(ip);
		}

		public void ProcessRequest(HttpContext context)
		{
			context.Response.ContentType = "text/plain";
			try
			{
				int num = 1;
				if (ValidSentRewardIP(context.Request.UserHostAddress))
				{
					string content = HttpUtility.UrlDecode(context.Request["content"]);
					string getSentRewardKey = GetSentRewardKey;
					BaseInterface baseInterface = BaseInterface.CreateInterface();
					string[] array = baseInterface.UnEncryptSentReward(content, ref num, getSentRewardKey);
					if (array.Length == 8 && num != 5 && num != 6 && num != 7)
					{
						string title = array[0];
						string content2 = array[1];
						string userName = array[2];
						int gold = int.Parse(array[3]);
						int money = int.Parse(array[4]);
						string param = array[5];
						if (checkParam(ref param))
						{
							PlayerBussiness playerBussiness = new PlayerBussiness();
							num = playerBussiness.SendMailAndItemByUserName(title, content2, userName, gold, money, param);
						}
						else
						{
							num = 4;
						}
					}
				}
				else
				{
					num = 3;
				}
				context.Response.Write(num);
			}
			catch (Exception exception)
			{
				log.Error("SentReward", exception);
			}
		}

		private bool checkParam(ref string param)
		{
			int num = 0;
			string text = "1";
			int num2 = 9;
			int num3 = 0;
			string text2 = "0";
			string b = "10";
			string b2 = "20";
			string b3 = "30";
			string b4 = "40";
			string text3 = "1";
			string b5 = "0";
			if (!string.IsNullOrEmpty(param))
			{
				string[] array = param.Split('|');
				int num4 = array.Length;
				if (num4 > 0)
				{
					param = "";
					int num5 = 0;
					string[] array2 = array;
					for (int i = 0; i < array2.Length; i++)
					{
						string text4 = array2[i];
						string[] array3 = text4.Split(',');
						if (array3.Length != 0)
						{
							array[num5] = "";
							array3[2] = ((int.Parse(array3[2]) < num || string.IsNullOrEmpty(array3[2].ToString())) ? text : array3[2]);
							array3[3] = ((int.Parse(array3[3].ToString()) < num3 || int.Parse(array3[3].ToString()) > num2 || string.IsNullOrEmpty(array3[3].ToString())) ? num3.ToString() : array3[3]);
							array3[4] = ((array3[4] == text2 || array3[4] == b || array3[4] == b2 || array3[4] == b3 || (array3[4] == b4 && !string.IsNullOrEmpty(array3[4].ToString()))) ? array3[4] : text2);
							array3[5] = ((array3[5] == text2 || array3[5] == b || array3[5] == b2 || array3[5] == b3 || (array3[5] == b4 && !string.IsNullOrEmpty(array3[5].ToString()))) ? array3[5] : text2);
							array3[6] = ((array3[6] == text2 || array3[6] == b || array3[6] == b2 || array3[6] == b3 || (array3[6] == b4 && !string.IsNullOrEmpty(array3[6].ToString()))) ? array3[6] : text2);
							array3[7] = ((array3[7] == text2 || array3[7] == b || array3[7] == b2 || array3[7] == b3 || (array3[7] == b4 && !string.IsNullOrEmpty(array3[7].ToString()))) ? array3[7] : text2);
							array3[8] = ((array3[8] == text3 || (array3[8] == b5 && !string.IsNullOrEmpty(array3[8]))) ? array3[8] : text3);
						}
						for (int j = 0; j < 9; j++)
						{
							array[num5] = array[num5] + array3[j] + ",";
						}
						array[num5] = array[num5].Remove(array[num5].Length - 1, 1);
						num5++;
					}
					for (int k = 0; k < num4; k++)
					{
						param = param + array[k] + "|";
					}
					param = param.Remove(param.Length - 1, 1);
					return true;
				}
			}
			return false;
		}
	}
}
