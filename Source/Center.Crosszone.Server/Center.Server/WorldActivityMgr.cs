using log4net;
using System;
using System.Reflection;
namespace Center.Server
{
	public class WorldActivityMgr
	{
		private static readonly ILog ilog_0;
		public static bool Init()
		{
			bool result;
			try
			{
				result = true;
			}
			catch (System.Exception ex)
			{
				WorldActivityMgr.ilog_0.ErrorFormat("Load Game Event failed:{0}", ex);
				result = false;
			}
			return result;
		}
		public static bool LoadEvent()
		{
			return true;
		}
		public WorldActivityMgr()
		{
			
			
		}
		static WorldActivityMgr()
		{
			
			WorldActivityMgr.ilog_0 = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
