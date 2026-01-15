using System;
using System.Reflection;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;
using Bussiness;
using log4net;
using Road.Flash;
using SqlDataProvider.Data;

namespace Tank.Request.CelebList
{
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class CelebByDayBestEquip : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			context.Response.Write(Build(context));
		}

		public static string Build(HttpContext context)
		{
			if (!csFunction.ValidAdminIP(context.Request.UserHostAddress))
			{
				return "CelebByDayGPList Fail!";
			}
			return Build();
		}

		public static string Build()
		{
			bool flag = false;
			string value = "Fail!";
			XElement xElement = new XElement("Result");
			try
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				BestEquipInfo[] celebByDayBestEquip = playerBussiness.GetCelebByDayBestEquip();
				BestEquipInfo[] array = celebByDayBestEquip;
				for (int i = 0; i < array.Length; i++)
				{
					BestEquipInfo info = array[i];
					xElement.Add(FlashUtils.CreateBestEquipInfo(info));
				}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error("Load CelebByDayBestEquip is fail!", exception);
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			return csFunction.CreateCompressXml(xElement, "CelebForBestEquip", isCompress: false);
		}
	}
}
