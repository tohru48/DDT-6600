using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.FlowerGiving
{
	public class FlowerGivingMgr
	{
		private static readonly ILog ilog_0;

		private static ThreadSafeRandom threadSafeRandom_0;

		private static CommunalActiveInfo communalActiveInfo_0;

		private static Dictionary<int, ActiveSystemInfo> dictionary_0;

		private static List<ActiveSystemInfo> list_0;

		protected static Timer _dbTimer;

		protected static Timer _expTimer;

		public static void BeginTimer()
		{
			int num = 1800000;
			if (_dbTimer == null)
			{
				_dbTimer = new Timer(dbTimeCheck, null, num, num);
			}
			else
			{
				_dbTimer.Change(num, num);
			}
			num = 60000;
			if (_expTimer == null)
			{
				_expTimer = new Timer(BoatExpCheck, null, num, num);
			}
			else
			{
				_expTimer.Change(num, num);
			}
		}

		protected static void dbTimeCheck(object sender)
		{
			try
			{
				int tickCount = Environment.TickCount;
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
			}
			catch (Exception ex)
			{
				Console.WriteLine("Communal Active: " + ex);
			}
		}

		protected static void BoatExpCheck(object sender)
		{
			try
			{
				int tickCount = Environment.TickCount;
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
			}
			catch (Exception ex)
			{
				Console.WriteLine("Communal Active: " + ex);
			}
		}

		public static void StopAllTimer()
		{
			if (_dbTimer != null)
			{
				_dbTimer.Dispose();
				_dbTimer = null;
			}
			if (_expTimer != null)
			{
				_expTimer.Dispose();
				_expTimer = null;
			}
		}

		public static void SendFlowerGivingAward()
		{
		}

		public static bool Init()
		{
			try
			{
				threadSafeRandom_0 = new ThreadSafeRandom();
				CommunalActiveInfo[] allCommunalActives = CommunalActiveMgr.GetAllCommunalActives();
				CommunalActiveInfo[] array = allCommunalActives;
				foreach (CommunalActiveInfo communalActiveInfo in array)
				{
					if (communalActiveInfo.IsOpen)
					{
						communalActiveInfo_0 = communalActiveInfo;
					}
				}
				return smethod_0();
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("FlowerGivingMgr =>Int", exception);
				}
				return false;
			}
			finally
			{
				BeginTimer();
			}
		}

		private static bool smethod_0()
		{
			bool result = false;
			try
			{
				result = true;
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("FlowerGivingMgr =>LoadLocalTotalScore", exception);
				}
			}
			return result;
		}

		static FlowerGivingMgr()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			dictionary_0 = new Dictionary<int, ActiveSystemInfo>();
			list_0 = new List<ActiveSystemInfo>();
		}
	}
}
