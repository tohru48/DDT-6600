using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;
using Bussiness;
using Game.Base.Packets;
using Game.Server.Rooms;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Managers
{
	public class FightRateMgr
	{
		private static readonly ILog ilog_0;

		private static ReaderWriterLock readerWriterLock_0;

		protected static Dictionary<int, FightRateInfo> _fightRate;

		public static bool ReLoad()
		{
			try
			{
				Dictionary<int, FightRateInfo> dictionary = new Dictionary<int, FightRateInfo>();
				if (smethod_0(dictionary))
				{
					readerWriterLock_0.AcquireWriterLock(-1);
					try
					{
						_fightRate = dictionary;
						return true;
					}
					catch
					{
					}
					finally
					{
						readerWriterLock_0.ReleaseWriterLock();
					}
				}
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("AwardMgr", exception);
				}
			}
			return false;
		}

		public static bool Init()
		{
			try
			{
				readerWriterLock_0 = new ReaderWriterLock();
				_fightRate = new Dictionary<int, FightRateInfo>();
				return smethod_0(_fightRate);
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("AwardMgr", exception);
				}
				return false;
			}
		}

		private static bool smethod_0(Dictionary<int, FightRateInfo> fighRate)
		{
			using (ServiceBussiness serviceBussiness = new ServiceBussiness())
			{
				FightRateInfo[] fightRate = serviceBussiness.GetFightRate(GameServer.Instance.Configuration.ServerID);
				FightRateInfo[] array = fightRate;
				foreach (FightRateInfo fightRateInfo in array)
				{
					if (!fighRate.ContainsKey(fightRateInfo.ID))
					{
						fighRate.Add(fightRateInfo.ID, fightRateInfo);
					}
				}
			}
			return true;
		}

		public static FightRateInfo[] GetAllFightRateInfo()
		{
			FightRateInfo[] array = null;
			readerWriterLock_0.AcquireReaderLock(-1);
			try
			{
				array = _fightRate.Values.ToArray();
			}
			catch
			{
			}
			finally
			{
				readerWriterLock_0.ReleaseReaderLock();
			}
			if (array != null)
			{
				return array;
			}
			return new FightRateInfo[0];
		}

		public static bool CanChangeStyle(BaseRoom game, GSPacketIn pkg)
		{
			FightRateInfo[] allFightRateInfo = GetAllFightRateInfo();
			try
			{
				FightRateInfo[] array = allFightRateInfo;
				foreach (FightRateInfo fightRateInfo in array)
				{
					if (fightRateInfo.BeginDay.Year <= DateTime.Now.Year && DateTime.Now.Year <= fightRateInfo.EndDay.Year && fightRateInfo.BeginDay.DayOfYear <= DateTime.Now.DayOfYear && DateTime.Now.DayOfYear <= fightRateInfo.EndDay.DayOfYear && fightRateInfo.BeginTime.TimeOfDay <= DateTime.Now.TimeOfDay && DateTime.Now.TimeOfDay <= fightRateInfo.EndTime.TimeOfDay && ThreadSafeRandom.NextStatic(1000000) < fightRateInfo.Rate)
					{
						return true;
					}
				}
			}
			catch
			{
			}
			pkg.WriteBoolean(val: false);
			return false;
		}

		static FightRateMgr()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
