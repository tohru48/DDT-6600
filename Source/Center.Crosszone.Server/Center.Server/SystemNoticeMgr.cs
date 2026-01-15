using log4net;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Reflection;
using System.Xml.Linq;
namespace Center.Server
{
	public class SystemNoticeMgr
	{
		private static readonly ILog ilog_0;
		public static System.Collections.Generic.List<string> NotceList;
		private static object object_0;
		private static string smethod_0()
		{
			return ConfigurationManager.AppSettings["SystemNoticePath"];
		}
		public static bool Start()
		{
			bool result;
			try
			{
				result = SystemNoticeMgr.LoadNotice("");
			}
			catch (System.Exception ex)
			{
				SystemNoticeMgr.ilog_0.ErrorFormat("Load server list from db failed:{0}", ex);
				result = false;
			}
			return result;
		}
		public static bool LoadNotice(string path)
		{
			string text = path + SystemNoticeMgr.smethod_0();
			if (!System.IO.File.Exists(text))
			{
				SystemNoticeMgr.ilog_0.Error("SystemNotice file : " + text + " not found !");
			}
			else
			{
				try
				{
					XDocument xDocument = XDocument.Load(text);
					using (System.Collections.Generic.IEnumerator<XNode> enumerator = xDocument.Root.Nodes().GetEnumerator())
					{
						while (enumerator.MoveNext())
						{
							XElement xElement = (XElement)enumerator.Current;
							try
							{
								int.Parse(xElement.Attribute("id").Value);
								string value = xElement.Attribute("notice").Value;
								SystemNoticeMgr.NotceList.Add(value);
							}
							catch (System.Exception ex)
							{
								SystemNoticeMgr.ilog_0.Error("BattleMgr setup error:", ex);
							}
						}
					}
				}
				catch (System.Exception ex2)
				{
					SystemNoticeMgr.ilog_0.Error("BattleMgr setup error:", ex2);
				}
			}
			SystemNoticeMgr.ilog_0.InfoFormat("Total {0} syterm notice loaded.", SystemNoticeMgr.NotceList.Count);
			return true;
		}
		public SystemNoticeMgr()
		{
			
			
		}
		static SystemNoticeMgr()
		{
			
			SystemNoticeMgr.ilog_0 = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
			SystemNoticeMgr.NotceList = new System.Collections.Generic.List<string>();
			SystemNoticeMgr.object_0 = new object();
		}
	}
}
