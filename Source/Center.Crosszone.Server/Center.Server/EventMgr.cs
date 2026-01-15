using log4net;
using System;
using System.Reflection;
namespace Center.Server
{
	public class EventMgr
	{
		private static readonly ILog ilog_0;
		public static bool Start()
		{
			bool result;
			try
			{
				result = true;
			}
			catch (System.Exception ex)
			{
				EventMgr.ilog_0.ErrorFormat("Load server list from db failed:{0}", ex);
				result = false;
			}
			return result;
		}
		public static bool LoadEvent(string path)
		{
			return true;
		}
		public EventMgr()
		{
			
			
		}
		static EventMgr()
		{
			
			EventMgr.ilog_0 = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
