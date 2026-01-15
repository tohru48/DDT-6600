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
	public class searchgoodstemp : IHttpHandler
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
				SearchGoodsTempInfo[] allSearchGoodsTemp = produceBussiness.GetAllSearchGoodsTemp();
				SearchGoodsTempInfo[] array = allSearchGoodsTemp;
				for (int i = 0; i < array.Length; i++)
				{
					SearchGoodsTempInfo info = array[i];
					xElement.Add(FlashUtils.CreateSearchGoodsTemp(info));
				}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error("searchgoodstemp", exception);
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			return csFunction.CreateCompressXml(context, xElement, "searchgoodstemp", isCompress: false);
		}
	}
}
