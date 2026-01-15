using System.Web;
using System.Web.Services;
using System.Xml.Linq;
using Bussiness;
using Road.Flash;
using SqlDataProvider.Data;

namespace Tank.Request
{
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class ShopItemList : IHttpHandler
	{
		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			if (csFunction.ValidAdminIP(context.Request.UserHostAddress))
			{
				context.Response.Write(Bulid(context));
			}
			else
			{
				context.Response.Write("IP is not valid! " + context.Request.UserHostAddress);
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
				ShopItemInfo[] aLllShop = produceBussiness.method_0();
				ShopItemInfo[] array = aLllShop;
				for (int i = 0; i < array.Length; i++)
				{
					ShopItemInfo shop = array[i];
					xElement2.Add(FlashUtils.CreateShopInfo(shop));
				}
				xElement.Add(xElement2);
				flag = true;
				value = "Success!";
			}
			catch
			{
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			return csFunction.CreateCompressXml(context, xElement, "ShopItemList", isCompress: true);
		}
	}
}
