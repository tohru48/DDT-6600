using System;
using System.Collections;
using System.Reflection;
using System.Threading;
using Bussiness;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Managers
{
	public class RateMgr
	{
		private static readonly ILog ilog_0;

		private static ReaderWriterLock readerWriterLock_0;

		private static ArrayList arrayList_0;

		public static bool Init(GameServerConfig config)
		{
			readerWriterLock_0.AcquireWriterLock(-1);
			try
			{
				using (ServiceBussiness serviceBussiness = new ServiceBussiness())
				{
					arrayList_0 = serviceBussiness.GetRate(config.ServerID);
				}
				return true;
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("RateMgr", exception);
				}
				return false;
			}
			finally
			{
				readerWriterLock_0.ReleaseWriterLock();
			}
		}

		public static bool ReLoad()
		{
			return Init(GameServer.Instance.Configuration);
		}

		public static float GetRate(eRateType eType)
		{
			float result = 1f;
			readerWriterLock_0.AcquireReaderLock(-1);
			try
			{
				RateInfo rateInfo = smethod_0((int)eType);
				if (rateInfo == null)
				{
					return result;
				}
				if (rateInfo.Rate == 0f)
				{
					return 1f;
				}
				if (smethod_1(rateInfo))
				{
					result = rateInfo.Rate;
				}
			}
			catch
			{
			}
			finally
			{
				readerWriterLock_0.ReleaseReaderLock();
			}
			return result;
		}

		private static RateInfo smethod_0(int int_0)
		{
			foreach (RateInfo item in arrayList_0)
			{
				if (item.Type == int_0)
				{
					return item;
				}
			}
			return null;
		}

		private static bool smethod_1(RateInfo rateInfo_0)
		{
			DateTime beginDay = rateInfo_0.BeginDay;
			DateTime endDay = rateInfo_0.EndDay;
			return rateInfo_0.BeginDay.Year <= DateTime.Now.Year && DateTime.Now.Year <= rateInfo_0.EndDay.Year && rateInfo_0.BeginDay.DayOfYear <= DateTime.Now.DayOfYear && DateTime.Now.DayOfYear <= rateInfo_0.EndDay.DayOfYear && !(rateInfo_0.BeginTime.TimeOfDay > DateTime.Now.TimeOfDay) && !(DateTime.Now.TimeOfDay > rateInfo_0.EndTime.TimeOfDay);
		}

		static RateMgr()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			readerWriterLock_0 = new ReaderWriterLock();
			arrayList_0 = new ArrayList();
		}
	}
}
