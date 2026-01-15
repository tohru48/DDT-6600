using Bussiness;
using log4net;
using System;
using System.Configuration;
using System.Data;
using System.Reflection;
namespace Center.Server.Statics
{
	public class LogMgr
	{
		public static readonly ILog log;
		private static object object_0;
		private static int int_0;
		private static int int_1;
		private static int int_2;
		public static DataTable m_LogServer;
		private static int int_3;
		public static object _sysObj;
		public static int GameType
		{
			get
			{
				return int.Parse(ConfigurationManager.AppSettings["GameType"]);
			}
		}
		public static int ServerID
		{
			get
			{
				return int.Parse(ConfigurationManager.AppSettings["ServerID"]);
			}
		}
		public static int AreaID
		{
			get
			{
				return int.Parse(ConfigurationManager.AppSettings["AreaID"]);
			}
		}
		public static int SaveRecordSecond
		{
			get
			{
				return int.Parse(ConfigurationManager.AppSettings["SaveRecordInterval"]) * 60;
			}
		}
		public static int RegCount
		{
			get
			{
				int result;
				lock (LogMgr._sysObj)
				{
					result = LogMgr.int_3;
				}
				return result;
			}
			set
			{
				lock (LogMgr._sysObj)
				{
					LogMgr.int_3 = value;
				}
			}
		}
		public static bool Setup()
		{
			return LogMgr.Setup(LogMgr.GameType, LogMgr.ServerID, LogMgr.AreaID);
		}
		public static bool Setup(int gametype, int serverid, int areaid)
		{
			LogMgr.int_0 = gametype;
			LogMgr.int_1 = serverid;
			LogMgr.int_2 = areaid;
			LogMgr.m_LogServer = new DataTable("Log_Server");
			LogMgr.m_LogServer.Columns.Add("ApplicationId", typeof(int));
			LogMgr.m_LogServer.Columns.Add("SubId", typeof(int));
			LogMgr.m_LogServer.Columns.Add("EnterTime", typeof(System.DateTime));
			LogMgr.m_LogServer.Columns.Add("Online", typeof(int));
			LogMgr.m_LogServer.Columns.Add("Reg", typeof(int));
			return true;
		}
		public static void Reset()
		{
			lock (LogMgr.m_LogServer)
			{
				LogMgr.m_LogServer.Clear();
			}
		}
		public static void Save()
		{
			LoginMgr.GetOnlineCount();
			System.DateTime arg_0B_0 = System.DateTime.Now;
			int arg_11_0 = LogMgr.RegCount;
			LogMgr.RegCount = 0;
			int arg_1D_0 = LogMgr.SaveRecordSecond;
			using (ItemRecordBussiness itemRecordBussiness = new ItemRecordBussiness())
			{
				itemRecordBussiness.LogServerDb(LogMgr.m_LogServer);
			}
		}
		public static void AddRegCount()
		{
			lock (LogMgr._sysObj)
			{
				LogMgr.int_3++;
			}
		}
		public LogMgr()
		{
			
			
		}
		static LogMgr()
		{
			
			LogMgr.log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
			LogMgr.object_0 = new object();
			LogMgr._sysObj = new object();
		}
	}
}
