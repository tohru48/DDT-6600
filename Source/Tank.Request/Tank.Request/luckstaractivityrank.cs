using System;
using System.Web;
using System.Xml.Linq;
using Bussiness;
using Road.Flash;
using SqlDataProvider.Data;

namespace Tank.Request
{
	public class luckstaractivityrank : IHttpHandler
	{
		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			int num = Convert.ToInt32(context.Request["selfid"]);
			string text = context.Request["key"];
			XElement xElement = new XElement("Ranks");
			LuckstarActivityRankInfo luckstarActivityRankInfo = new LuckstarActivityRankInfo();
			luckstarActivityRankInfo.nickName = "";
			using (ProduceBussiness produceBussiness = new ProduceBussiness())
			{
				LuckstarActivityRankInfo[] allLuckstarActivityRank = produceBussiness.GetAllLuckstarActivityRank();
				LuckstarActivityRankInfo[] array = allLuckstarActivityRank;
				for (int i = 0; i < array.Length; i++)
				{
					LuckstarActivityRankInfo luckstarActivityRankInfo2 = array[i];
					xElement.Add(FlashUtils.LuckstarActivityRank(luckstarActivityRankInfo2));
					if (luckstarActivityRankInfo2.UserID == num)
					{
						luckstarActivityRankInfo = luckstarActivityRankInfo2;
					}
				}
			}
			XElement content = new XElement("myRank", new XAttribute("rank", luckstarActivityRankInfo.rank), new XAttribute("useStarNum", luckstarActivityRankInfo.useStarNum), new XAttribute("nickName", luckstarActivityRankInfo.nickName));
			xElement.Add(content);
			bool flag = true;
			string value = "Success!";
			xElement.Add(new XAttribute("lastUpdateTime", DateTime.Now.ToString("MM-dd hh:mm")));
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString(check: false));
		}
	}
}
