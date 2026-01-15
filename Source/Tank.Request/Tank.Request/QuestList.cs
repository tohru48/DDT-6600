using System;
using System.Collections;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Services;
using System.Xml;
using System.Xml.Linq;
using Bussiness;
using log4net;
using Road.Flash;
using SqlDataProvider.Data;

namespace Tank.Request
{
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class QuestList : IHttpHandler
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
				QuestInfo[] aLlQuest = produceBussiness.method_1();
				QuestAwardInfo[] allQuestGoods = produceBussiness.GetAllQuestGoods();
				QuestConditionInfo[] allQuestCondiction = produceBussiness.GetAllQuestCondiction();
				QuestRateInfo[] allQuestRate = produceBussiness.GetAllQuestRate();
				QuestInfo[] array = aLlQuest;
				for (int i = 0; i < array.Length; i++)
				{
					QuestInfo quest = array[i];
					XElement xElement2 = FlashUtils.CreateQuestInfo(quest);
					IEnumerable enumerable = allQuestCondiction.Where((QuestConditionInfo s) => s.QuestID == quest.ID);
					foreach (QuestConditionInfo info in enumerable)
					{
						xElement2.Add(FlashUtils.CreateQuestCondiction(info));
					}
					IEnumerable enumerable2 = allQuestGoods.Where((QuestAwardInfo s) => s.QuestID == quest.ID);
					foreach (QuestAwardInfo info2 in enumerable2)
					{
						xElement2.Add(FlashUtils.CreateQuestGoods(info2));
					}
					xElement.Add(xElement2);
				}
				QuestRateInfo[] array2 = allQuestRate;
				for (int i2 = 0; i2 < array2.Length; i2++)
				{
					QuestRateInfo info3 = array2[i2];
					XElement content = FlashUtils.CreateQuestRate(info3);
					xElement.Add(content);
				}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error("QuestList", exception);
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			return csFunction.CreateCompressXml(context, xElement, "QuestList", isCompress: true);
		}

		private static void AppendAttribute(XmlDocument doc, XmlNode node, string attr, string value)
		{
			XmlAttribute xmlAttribute = doc.CreateAttribute(attr);
			xmlAttribute.Value = value;
			node.Attributes.Append(xmlAttribute);
		}
	}
}
