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
	public class FarmGetUserFieldInfosSingle : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			int num = Convert.ToInt32(context.Request["selfid"]);
			int num2 = Convert.ToInt32(context.Request["friendID"]);
			string text = context.Request["key"];
			bool flag = true;
			string value = "Success!";
			XElement xElement = new XElement("Result");
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				XElement xElement2 = new XElement("Item");
				UserFieldInfo[] singleFields = playerBussiness.GetSingleFields(num2);
				UserFieldInfo[] array = singleFields;
				for (int i = 0; i < array.Length; i++)
				{
					UserFieldInfo userFieldInfo = array[i];
					XElement content = new XElement("Item", new XAttribute("SeedID", userFieldInfo.SeedID), new XAttribute("AcclerateDate", AccelerateTimeFields(userFieldInfo)), new XAttribute("GrowTime", userFieldInfo.PlantTime.ToString("yyyy-MM-ddTHH:mm:ss")));
					xElement2.Add(content);
				}
				xElement2.Add(new XAttribute("UserID", num2));
				xElement.Add(xElement2);
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}

		private static int AccelerateTimeFields(UserFieldInfo m_field)
		{
			int result = 0;
			if (m_field != null && m_field.SeedID > 0)
			{
				DateTime plantTime = m_field.PlantTime;
				int fieldValidDate = m_field.FieldValidDate;
				result = AccelerateTimeFields(plantTime, fieldValidDate);
			}
			return result;
		}

		private static int AccelerateTimeFields(DateTime PlantTime, int FieldValidDate)
		{
			DateTime now = DateTime.Now;
			int num = now.Hour - PlantTime.Hour;
			int num2 = now.Minute - PlantTime.Minute;
			if (num < 0)
			{
				num = 24 + num;
			}
			if (num2 < 0)
			{
				num2 = 60 + num2;
			}
			int num3 = num * 60 + num2;
			if (num3 > FieldValidDate)
			{
				num3 = FieldValidDate;
			}
			return num3;
		}
	}
}
