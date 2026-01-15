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
	public class FarmGetUserFieldInfos : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

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

		public void ProcessRequest(HttpContext context)
		{
			int userID = Convert.ToInt32(context.Request["selfid"]);
			string text = context.Request["key"];
			bool flag = true;
			string value = "Success!";
			XElement xElement = new XElement("Result");
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				FriendInfo[] friendsAll = playerBussiness.GetFriendsAll(userID);
				FriendInfo[] array = friendsAll;
				for (int i = 0; i < array.Length; i++)
				{
					FriendInfo friendInfo = array[i];
					XElement xElement2 = new XElement("Item");
					UserFieldInfo[] singleFields = playerBussiness.GetSingleFields(friendInfo.FriendID);
					UserFieldInfo[] array2 = singleFields;
					for (int j = 0; j < array2.Length; j++)
					{
						UserFieldInfo userFieldInfo = array2[j];
						XElement content = new XElement("Item", new XAttribute("SeedID", userFieldInfo.SeedID), new XAttribute("AcclerateDate", AccelerateTimeFields(userFieldInfo)), new XAttribute("GrowTime", userFieldInfo.PlantTime.ToString("yyyy-MM-ddTHH:mm:ss")));
						xElement2.Add(content);
					}
					xElement2.Add(new XAttribute("UserID", friendInfo.FriendID));
					xElement.Add(xElement2);
				}
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}
	}
}
