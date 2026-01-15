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
	public class IMListLoad : IHttpHandler
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
				string text = context.Request["uname"];
				int num = Convert.ToInt32(context.Request["id"]);
				int userID = Convert.ToInt32(context.Request["selfid"]);
				string text2 = context.Request["key"];
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					FriendInfo[] friendsAll = playerBussiness.GetFriendsAll(userID);
					XElement content = new XElement("customList", new XAttribute("ID", 0), new XAttribute("Name", "Amigos"));
					xElement.Add(content);
					content = new XElement("customList", new XAttribute("ID", 1), new XAttribute("Name", "Lista Negra"));
					xElement.Add(content);
					content = new XElement("customList", new XAttribute("ID", 10), new XAttribute("Name", ""));
					xElement.Add(content);
					content = new XElement("customList", new XAttribute("ID", 11), new XAttribute("Name", ""));
					xElement.Add(content);
					content = new XElement("customList", new XAttribute("ID", 12), new XAttribute("Name", ""));
					xElement.Add(content);
					content = new XElement("customList", new XAttribute("ID", 13), new XAttribute("Name", ""));
					xElement.Add(content);
					content = new XElement("customList", new XAttribute("ID", 14), new XAttribute("Name", ""));
					xElement.Add(content);
					content = new XElement("customList", new XAttribute("ID", 15), new XAttribute("Name", ""));
					xElement.Add(content);
					content = new XElement("customList", new XAttribute("ID", 16), new XAttribute("Name", ""));
					xElement.Add(content);
					content = new XElement("customList", new XAttribute("ID", 17), new XAttribute("Name", ""));
					xElement.Add(content);
					content = new XElement("customList", new XAttribute("ID", 18), new XAttribute("Name", ""));
					xElement.Add(content);
					content = new XElement("customList", new XAttribute("ID", 19), new XAttribute("Name", ""));
					xElement.Add(content);
					FriendInfo[] array = friendsAll;
					for (int i = 0; i < array.Length; i++)
					{
						FriendInfo friendInfo = array[i];
						XElement content2 = new XElement("Item", new XAttribute("ID", friendInfo.FriendID), new XAttribute("NickName", friendInfo.NickName), new XAttribute("LoginName", friendInfo.UserName), new XAttribute("Style", friendInfo.Style), new XAttribute("Sex", friendInfo.Sex == 1), new XAttribute("Colors", friendInfo.Colors), new XAttribute("Grade", friendInfo.Grade), new XAttribute("Hide", friendInfo.Hide), new XAttribute("ConsortiaName", friendInfo.ConsortiaName), new XAttribute("TotalCount", friendInfo.Total), new XAttribute("EscapeCount", friendInfo.Escape), new XAttribute("WinCount", friendInfo.Win), new XAttribute("Offer", friendInfo.Offer), new XAttribute("Relation", friendInfo.Relation), new XAttribute("Repute", friendInfo.Repute), new XAttribute("State", (friendInfo.State == 1) ? 1 : 0), new XAttribute("Nimbus", friendInfo.Nimbus), new XAttribute("DutyName", friendInfo.DutyName), new XAttribute("AchievementPoint", 0), new XAttribute("Rank", "Chiến sĩ siêu cấp"), new XAttribute("FightPower", 13528), new XAttribute("ApprenticeshipState", 0), new XAttribute("BBSFriends", false), new XAttribute("Birthday", DateTime.Now), new XAttribute("UserName", friendInfo.UserName), new XAttribute("IsMarried", friendInfo.IsMarried), new XAttribute("LastDate", friendInfo.LastDate.ToString("yyyy-mm-dd hh:mm:ss")));
						xElement.Add(content2);
					}
				}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error("IMListLoad", exception);
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			context.Response.ContentType = "text/plain";
			context.Response.BinaryWrite(StaticFunction.Compress(xElement.ToString(check: false)));
		}
	}
}
