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
	public class dailyloglist : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			bool flag = false;
			string value = "Fail!";
			XElement xElement = new XElement("Result");
			try
			{
				string text = context.Request["key"];
				int userID = int.Parse(context.Request["selfid"]);
				using (ProduceBussiness produceBussiness = new ProduceBussiness())
				{
					DailyLogListInfo dailyLogListSingle = produceBussiness.GetDailyLogListSingle(userID);
					string text2 = dailyLogListSingle.DayLog;
					int num = dailyLogListSingle.UserAwardLog;
					DateTime lastDate = dailyLogListSingle.LastDate;
					int num2 = text2.Split(',').Length;
					int month = DateTime.Now.Month;
					int year = DateTime.Now.Year;
					int day = DateTime.Now.Day;
					int num3 = DateTime.DaysInMonth(year, month);
					if (month != lastDate.Month || year != lastDate.Year)
					{
						text2 = "";
						num = 0;
						lastDate = DateTime.Now;
					}
					if (num2 < num3)
					{
						if (string.IsNullOrEmpty(text2) && num2 > 1)
						{
							text2 = "False";
						}
						for (int i = num2; i < day - 1; i++)
						{
							text2 += ",False";
						}
					}
					dailyLogListSingle.DayLog = text2;
					dailyLogListSingle.UserAwardLog = num;
					dailyLogListSingle.LastDate = lastDate;
					produceBussiness.UpdateDailyLogList(dailyLogListSingle);
					XElement content = new XElement("DailyLogList", new XAttribute("UserAwardLog", num), new XAttribute("DayLog", text2));
					xElement.Add(content);
				}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error("dailyloglist", exception);
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			xElement.Add(new XAttribute("nowDate", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")));
			context.Response.ContentType = "text/plain";
			context.Response.BinaryWrite(StaticFunction.Compress(xElement.ToString(check: false)));
		}
	}
}
