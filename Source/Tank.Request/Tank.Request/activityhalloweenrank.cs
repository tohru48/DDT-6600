using System.Web;
using System.Xml.Linq;
using Bussiness;
using SqlDataProvider.Data;

namespace Tank.Request
{
	public class activityhalloweenrank : IHttpHandler
	{
		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			bool flag = false;
			string value = "fail!";
			XElement xElement = new XElement("Result");
			using (ProduceBussiness produceBussiness = new ProduceBussiness())
			{
				//ActiveSystemInfo[] rankHalloween = produceBussiness.GetRankHalloween();
				//int num = 1;
				//ActiveSystemInfo[] array = rankHalloween;
				//for (int i = 0; i < array.Length; i++)
				//{
				//	ActiveSystemInfo activeSystemInfo = array[i];
				//	XElement content = new XElement("halloweenInfo", new XAttribute("rank", num), new XAttribute("nickName", activeSystemInfo.NickName), new XAttribute("useNum", activeSystemInfo.HalloweenCount), new XAttribute("isVIP", activeSystemInfo.HalloweenRank));
				//	xElement.Add(content);
				//	num++;
				//}
				flag = true;
				value = "Success!";
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xElement.ToString());
		}
	}
}
