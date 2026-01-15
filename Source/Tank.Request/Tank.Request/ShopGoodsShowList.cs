using System;
using System.Reflection;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;
using Bussiness;
using log4net;
using Road.Flash;
using SqlDataProvider.Data;

namespace Tank.Request
{
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class ShopGoodsShowList : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			if (csFunction.ValidAdminIP(context.Request.UserHostAddress))
			{
				context.Response.Write(Bulid(context));
			}
			else
			{
				context.Response.Write("IP is not valid!");
			}
		}

		public static string Bulid(HttpContext context)
		{
			bool flag = false;
			string value = "Fail!";
			XElement xElement = new XElement("Result");
			try
			{
				using ProduceBussiness produceBussiness = new ProduceBussiness();
				XElement xElement2 = new XElement("Store");
				ShopGoodsShowListInfo[] allShopGoodsShowList = produceBussiness.GetAllShopGoodsShowList();
				ShopGoodsShowListInfo[] array = allShopGoodsShowList;
				for (int i = 0; i < array.Length; i++)
				{
					ShopGoodsShowListInfo info = array[i];
					xElement2.Add(FlashUtils.CreateShopGoodsShowListInfo(info));
				}
				xElement.Add(xElement2);
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error("ShopGoodsShowList", exception);
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			return csFunction.CreateCompressXml(context, xElement, "ShopGoodsShowList", isCompress: true);
		}
	}
}
