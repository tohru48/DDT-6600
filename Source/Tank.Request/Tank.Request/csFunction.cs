using System;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Xml.Linq;
using Bussiness;
using log4net;
using Road.Flash;
using SqlDataProvider.Data;

namespace Tank.Request
{
	public class csFunction
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		private static string[] al = ";|and|1=1|exec|insert|select|delete|update|like|count|chr|mid|master|or|truncate|char|declare|join".Split('|');

		public static string GetAdminIP => ConfigurationManager.AppSettings["AdminIP"];

		public static bool ValidAdminIP(string ip)
		{
			string getAdminIP = GetAdminIP;
			return string.IsNullOrEmpty(getAdminIP) || getAdminIP.Split('|').Contains(ip);
		}

		public static string ConvertSql(string inputString)
		{
			inputString = inputString.Trim();
			inputString = inputString.Replace("'", "''");
			inputString = inputString.Replace(";--", "");
			inputString = inputString.Replace("=", "");
			inputString = inputString.Replace(" or", "");
			inputString = inputString.Replace(" or ", "");
			inputString = inputString.Replace(" and", "");
			inputString = inputString.Replace("and ", "");
			if (!SqlChar(inputString))
			{
				inputString = "";
			}
			return inputString;
		}

		public static bool SqlChar(string v)
		{
			if (v.Trim() != "")
			{
				string[] array = al;
				for (int i = 0; i < array.Length; i++)
				{
					string text = array[i];
					if (v.IndexOf(text + " ") > -1 || v.IndexOf(" " + text) > -1)
					{
						return false;
					}
				}
			}
			return true;
		}

		public static string CreateCompressXml(HttpContext context, XElement result, string file, bool isCompress)
		{
			string path = context.Server.MapPath("~");
			return CreateCompressXml(path, result, file, isCompress);
		}

		public static string CreateCompressXml(XElement result, string file, bool isCompress)
		{
			string currentPath = StaticsMgr.CurrentPath;
			return CreateCompressXml(currentPath, result, file, isCompress);
		}

		public static string CreateCompressXml(string path, XElement result, string file, bool isCompress)
		{
			try
			{
				file += ".xml";
				path = Path.Combine(path, file);
				using (FileStream fileStream = new FileStream(path, FileMode.Create))
				{
					if (isCompress)
					{
						using BinaryWriter binaryWriter = new BinaryWriter(fileStream);
						binaryWriter.Write(StaticFunction.Compress(result.ToString(check: false)));
					}
					else
					{
						using StreamWriter streamWriter = new StreamWriter(fileStream);
						streamWriter.Write(result.ToString(check: false));
					}
				}
				return "Build: " + file + ", Success!";
			}
			catch (Exception exception)
			{
				log.Error("CreateCompressXml " + file + " is fail!", exception);
				return "Build: " + file + ", Fail!";
			}
		}

		public static string BuildCelebConsortia(string file, int order)
		{
			return BuildCelebConsortia(file, order, "");
		}

		public static string BuildCelebConsortia(string file, int order, string fileNotCompress)
		{
			bool flag = false;
			string value = "Fail!";
			XElement xElement = new XElement("Result");
			int num = 0;
			try
			{
				int page = 1;
				int size = 50;
				int consortiaID = -1;
				string name = "";
				int level = -1;
				using ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
				ConsortiaInfo[] consortiaPage = consortiaBussiness.GetConsortiaPage(page, size, ref num, order, name, consortiaID, level, -1);
				ConsortiaInfo[] array = consortiaPage;
				for (int i = 0; i < array.Length; i++)
				{
					ConsortiaInfo consortiaInfo = array[i];
					XElement xElement2 = FlashUtils.CreateConsortiaInfo(consortiaInfo);
					if (consortiaInfo.ChairmanID != 0)
					{
						using PlayerBussiness playerBussiness = new PlayerBussiness();
						PlayerInfo userSingleByUserID = playerBussiness.GetUserSingleByUserID(consortiaInfo.ChairmanID);
						if (userSingleByUserID != null)
						{
							xElement2.Add(FlashUtils.CreateCelebInfo(userSingleByUserID));
						}
					}
					xElement.Add(xElement2);
				}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error(file + " is fail!", exception);
			}
			xElement.Add(new XAttribute("total", num));
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			xElement.Add(new XAttribute("date", DateTime.Today.ToString("yyyy-MM-dd")));
			if (!string.IsNullOrEmpty(fileNotCompress))
			{
				CreateCompressXml(xElement, fileNotCompress, isCompress: false);
			}
			return CreateCompressXml(xElement, file, isCompress: true);
		}

		public static string BuildCelebTotalPrestige(string file, string fileNotCompress)
		{
			bool flag = false;
			string value = "Fail!";
			XElement xElement = new XElement("Result");
			int num = 0;
			try
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				//PlayerInfo[] rankPrestige = playerBussiness.GetRankPrestige();
				//num = rankPrestige.Length;
				//PlayerInfo[] array = rankPrestige;
				//for (int i = 0; i < array.Length; i++)
				//{
				//	PlayerInfo info = array[i];
				//	XElement content = FlashUtils.CreateCelebPrestigeInfo(info);
				//	xElement.Add(content);
				//}
				//flag = true;
				//value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error(file + " is fail!", exception);
			}
			xElement.Add(new XAttribute("total", num));
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			xElement.Add(new XAttribute("date", DateTime.Today.ToString("yyyy-MM-dd")));
			if (!string.IsNullOrEmpty(fileNotCompress))
			{
				CreateCompressXml(xElement, fileNotCompress, isCompress: false);
			}
			return CreateCompressXml(xElement, file, isCompress: true);
		}

		public static string BuildCelebMountExp(string file, string fileNotCompress)
		{
			bool flag = false;
			string value = "Fail!";
			XElement xElement = new XElement("Result");
			int num = 0;
			try
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				//PlayerInfo[] rankMountExp = playerBussiness.GetRankMountExp();
				//num = rankMountExp.Length;
				//PlayerInfo[] array = rankMountExp;
				//for (int i = 0; i < array.Length; i++)
				//{
				//	PlayerInfo info = array[i];
				//	XElement content = FlashUtils.CreateCelebMountExp(info);
				//	xElement.Add(content);
				//}
				//flag = true;
				//value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error(file + " is fail!", exception);
			}
			xElement.Add(new XAttribute("total", num));
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			xElement.Add(new XAttribute("date", DateTime.Today.ToString("yyyy-MM-dd")));
			if (!string.IsNullOrEmpty(fileNotCompress))
			{
				CreateCompressXml(xElement, fileNotCompress, isCompress: false);
			}
			return CreateCompressXml(xElement, file, isCompress: true);
		}

		public static string BuildCelebConsortiaFightPower(string file, string fileNotCompress)
		{
			bool flag = false;
			string value = "Fail!";
			XElement xElement = new XElement("Result");
			int num = 0;
			try
			{
				using ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
				//ConsortiaInfo[] array = consortiaBussiness.UpdateConsortiaFightPower();
				//num = array.Length;
				//ConsortiaInfo[] array2 = array;
				//for (int i = 0; i < array2.Length; i++)
				//{
				//	ConsortiaInfo consortiaInfo = array2[i];
				//	XElement xElement2 = FlashUtils.CreateConsortiaInfo(consortiaInfo);
				//	if (consortiaInfo.ChairmanID != 0)
				//	{
				//		using PlayerBussiness playerBussiness = new PlayerBussiness();
				//		PlayerInfo userSingleByUserID = playerBussiness.GetUserSingleByUserID(consortiaInfo.ChairmanID);
				//		if (userSingleByUserID != null)
				//		{
				//			xElement2.Add(FlashUtils.CreateCelebInfo(userSingleByUserID));
				//		}
				//	}
				//	xElement.Add(xElement2);
				//}
				flag = true;
				value = "Success!";
			}
			catch (Exception exception)
			{
				log.Error(file + " is fail!", exception);
			}
			xElement.Add(new XAttribute("total", num));
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			xElement.Add(new XAttribute("date", DateTime.Today.ToString("yyyy-MM-dd")));
			if (!string.IsNullOrEmpty(fileNotCompress))
			{
				CreateCompressXml(xElement, fileNotCompress, isCompress: false);
			}
			return CreateCompressXml(xElement, file, isCompress: true);
		}

		public static string BuildCelebUsers(string file, int order)
		{
			return BuildCelebUsers(file, order, "");
		}

		public static string BuildCelebUsers(string file, int order, string fileNotCompress)
		{
			bool flag = false;
			string value = "Fail!";
			XElement xElement = new XElement("Result");
			try
			{
				int page = 1;
				int size = 50;
				int userID = -1;
				int num = 0;
				bool flag2 = false;
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				//playerBussiness.UpdateUserReputeFightPower();
				//PlayerInfo[] playerPage = playerBussiness.GetPlayerPage(page, size, ref num, order, userID, ref flag2);
				//if (flag2)
				//{
				//	PlayerInfo[] array = playerPage;
				//	for (int i = 0; i < array.Length; i++)
				//	{
				//		PlayerInfo info = array[i];
				//		xElement.Add(FlashUtils.CreateCelebInfo(info));
				//	}
				//	flag = true;
				//	value = "Success!";
				//}
			}
			catch (Exception exception)
			{
				log.Error(file + " is fail!", exception);
			}
			xElement.Add(new XAttribute("value", flag));
			xElement.Add(new XAttribute("message", value));
			xElement.Add(new XAttribute("date", DateTime.Today.ToString("yyyy-MM-dd")));
			if (!string.IsNullOrEmpty(fileNotCompress))
			{
				CreateCompressXml(xElement, fileNotCompress, isCompress: false);
			}
			return CreateCompressXml(xElement, file, isCompress: true);
		}
	}
}
