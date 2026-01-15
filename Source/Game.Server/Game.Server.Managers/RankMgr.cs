using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;
using Bussiness;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Managers
{
	public class RankMgr
	{
		private static readonly ILog ilog_0;

		private static ReaderWriterLock readerWriterLock_0;

		private static Dictionary<int, UserMatchInfo> dictionary_0;

		private static Dictionary<int, UserRankDateInfo> dictionary_1;

		private static Dictionary<int, PlayerInfo> dictionary_2;

		protected static Timer _timer;

		public static bool Init()
		{
			try
			{
				readerWriterLock_0 = new ReaderWriterLock();
				dictionary_0 = new Dictionary<int, UserMatchInfo>();
				dictionary_1 = new Dictionary<int, UserRankDateInfo>();
				dictionary_2 = new Dictionary<int, PlayerInfo>();
				BeginTimer();
				return ReLoad();
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("RankMgr", exception);
				}
				return false;
			}
		}

		public static bool ReLoad()
		{
			try
			{
				Dictionary<int, UserMatchInfo> match = new Dictionary<int, UserMatchInfo>();
				Dictionary<int, UserRankDateInfo> newRanks = new Dictionary<int, UserRankDateInfo>();
				if (smethod_0(match, newRanks))
				{
					readerWriterLock_0.AcquireWriterLock(-1);
					try
					{
						dictionary_0 = match;
						dictionary_1 = newRanks;
						return true;
					}
					catch
					{
					}
					finally
					{
						using (PlayerBussiness playerBussiness = new PlayerBussiness())
						{
							int total = 0;
							bool resultValue = false;
							PlayerInfo[] playerPage = playerBussiness.GetPlayerPage(1, 16, ref total, 6, -1, ref resultValue);
							if (resultValue)
							{
								int num = 1;
								PlayerInfo[] array = playerPage;
								foreach (PlayerInfo value in array)
								{
									if (!dictionary_2.ContainsKey(num))
									{
										dictionary_2.Add(num, value);
									}
									num++;
								}
							}
						}
						readerWriterLock_0.ReleaseWriterLock();
					}
				}
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("RankMgr", exception);
				}
			}
			return false;
		}

		public static UserMatchInfo FindRank(int UserID)
		{
			if (dictionary_0.ContainsKey(UserID))
			{
				return dictionary_0[UserID];
			}
			return null;
		}

		public static UserRankDateInfo FindRankDate(int UserID)
		{
			if (dictionary_1.ContainsKey(UserID))
			{
				return dictionary_1[UserID];
			}
			return null;
		}

		public static PlayerInfo[] GetLocalTopThree()
		{
			List<PlayerInfo> list = new List<PlayerInfo>();
			for (int i = 1; i <= 3; i++)
			{
				if (dictionary_2.ContainsKey(i))
				{
					list.Add(dictionary_2[i]);
				}
			}
			return list.ToArray();
		}

		public static PlayerInfo[] GetAllLocalTop()
		{
			List<PlayerInfo> list = new List<PlayerInfo>();
			for (int i = 1; i <= 16; i++)
			{
				if (dictionary_2.ContainsKey(i))
				{
					list.Add(dictionary_2[i]);
				}
			}
			return list.ToArray();
		}

		private static bool smethod_0(Dictionary<int, UserMatchInfo> Match, Dictionary<int, UserRankDateInfo> NewRanks)
		{
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				playerBussiness.UpdateRank();
				UserMatchInfo[] allUserMatchInfo = playerBussiness.GetAllUserMatchInfo();
				UserMatchInfo[] array = allUserMatchInfo;
				foreach (UserMatchInfo userMatchInfo in array)
				{
					if (!Match.ContainsKey(userMatchInfo.UserID))
					{
						Match.Add(userMatchInfo.UserID, userMatchInfo);
					}
				}
				UserRankDateInfo[] allUserRankDate = playerBussiness.GetAllUserRankDate();
				UserRankDateInfo[] array2 = allUserRankDate;
				foreach (UserRankDateInfo userRankDateInfo in array2)
				{
					if (!NewRanks.ContainsKey(userRankDateInfo.UserID))
					{
						NewRanks.Add(userRankDateInfo.UserID, userRankDateInfo);
					}
				}
			}
			return true;
		}

		public static void BeginTimer()
		{
			int num = 3600000;
			if (_timer == null)
			{
				_timer = new Timer(TimeCheck, null, num, num);
			}
			else
			{
				_timer.Change(num, num);
			}
		}

		protected static void TimeCheck(object sender)
		{
			try
			{
				int tickCount = Environment.TickCount;
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				ReLoad();
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
			}
			catch (Exception ex)
			{
				Console.WriteLine("TimeCheck Rank: " + ex);
			}
		}

		public void StopTimer()
		{
			if (_timer != null)
			{
				_timer.Dispose();
				_timer = null;
			}
		}

		static RankMgr()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			readerWriterLock_0 = new ReaderWriterLock();
		}
	}
}
