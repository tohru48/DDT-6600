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
	public class BombConfig : IHttpHandler
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
				using (ProduceBussiness produceBussiness = new ProduceBussiness())
				{
					BallConfigInfo[] allBallConfig = produceBussiness.GetAllBallConfig();
					BallConfigInfo[] array = allBallConfig;
					for (int i = 0; i < array.Length; i++)
					{
						BallConfigInfo b = array[i];
						xElement.Add(FlashUtils.CreateBallConfigInfo(b));
					}
				}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error("bombconfig", exception);
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			return csFunction.CreateCompressXml(context, xElement, "bombconfig", isCompress: true);
		}
	}
}
