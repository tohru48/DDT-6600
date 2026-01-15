using System;
using System.Reflection;
using System.Web;
using System.Xml.Linq;
using Bussiness;
using log4net;
using Road.Flash;
using SqlDataProvider.Data;

namespace Tank.Request
{
	public class subactivelist : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			bool flag = false;
			string value = "fail!";
			XElement xElement = new XElement("Result");
			try
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				SubActiveInfo[] allSubActive = playerBussiness.GetAllSubActive();
				SubActiveInfo[] array = allSubActive;
				for (int i = 0; i < array.Length; i++)
				{
					SubActiveInfo subActiveInfo = array[i];
					xElement.Add(FlashUtils.CreateActiveInfo(subActiveInfo));
					SubActiveConditionInfo[] allSubActiveCondition = playerBussiness.GetAllSubActiveCondition(subActiveInfo.ActiveID);
					SubActiveConditionInfo[] array2 = allSubActiveCondition;
					for (int j = 0; j < array2.Length; j++)
					{
						SubActiveConditionInfo info = array2[j];
						xElement.Add(FlashUtils.CreateActiveConditionInfo(info));
					}
				}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error("subactivelist", exception);
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("nowTime", DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss")));
			xElement.Add(new XAttribute("message", value));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}
	}
}
