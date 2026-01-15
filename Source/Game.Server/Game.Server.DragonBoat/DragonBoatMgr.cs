using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Game.Server.GameObjects;
using Game.Server.Managers;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.DragonBoat
{
	public class DragonBoatMgr
	{
		private static readonly ILog ilog_0;

		private static ThreadSafeRandom threadSafeRandom_0;

		private static CommunalActiveInfo communalActiveInfo_0;

		private static Dictionary<int, ActiveSystemInfo> dictionary_0;

		private static List<ActiveSystemInfo> list_0;

		public static readonly int DRAGONBOAT_CHIP;

		public static readonly int KINGSTATUE_CHIP;

		public static readonly int LINSHI_CHIP;

		protected static Timer _dbTimer;

		protected static Timer _expTimer;

		private static int int_0;

		[CompilerGenerated]
		private static Func<ActiveSystemInfo, int> func_0;

		[CompilerGenerated]
		private static Func<KeyValuePair<int, ActiveSystemInfo>, int> func_1;

		[CompilerGenerated]
		private static Func<KeyValuePair<int, ActiveSystemInfo>, bool> func_2;

		[CompilerGenerated]
		private static Func<KeyValuePair<int, ActiveSystemInfo>, int> func_3;

		[CompilerGenerated]
		private static Func<ActiveSystemInfo, bool> func_4;

		[CompilerGenerated]
		private static Func<ActiveSystemInfo, int> func_5;

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
				GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
				GamePlayer[] array = allPlayers;
				for (int i = 0; i < array.Length; i++)
				{
					array[i]?.Actives.SaveActiveToDatabase();
				}
				if (smethod_0())
				{
					if (!IsContinuous())
					{
						GamePlayer[] array2 = allPlayers;
						foreach (GamePlayer gamePlayer in array2)
						{
							gamePlayer?.Out.SendDragonBoat(gamePlayer.PlayerCharacter);
						}
						SendDragonBoatAward();
					}
					Console.WriteLine("=======Reload communal active Success!========");
				}
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
				UpdateBoatCompleteExp();
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
				_dbTimer.Change(-1, -1);
				_dbTimer.Dispose();
				_dbTimer = null;
			}
			if (_expTimer != null)
			{
				_expTimer.Change(-1, -1);
				_expTimer.Dispose();
				_expTimer = null;
			}
		}

		public static void SendDragonBoatAward()
		{
			if (communalActiveInfo_0 == null || !communalActiveInfo_0.IsSendAward)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			List<ActiveSystemInfo> list = SelectTopTenCurrenServer();
			List<ItemInfo> list2 = new List<ItemInfo>();
			foreach (ActiveSystemInfo item in list)
			{
				PlayerInfo userSingleByUserID = playerBussiness.GetUserSingleByUserID(item.UserID);
				if (userSingleByUserID != null && item.myRank <= 10)
				{
					string translation = LanguageMgr.GetTranslation("DragonBoatAward.Curr", item.myRank);
					list2 = GetAwardInfos(1, item.myRank);
					WorldEventMgr.SendItemsToMail(list2, item.UserID, item.NickName, translation);
				}
			}
			List<ActiveSystemInfo> list3 = SelectTopTenAllServer();
			foreach (ActiveSystemInfo item2 in list3)
			{
				PlayerInfo userSingleByUserID2 = playerBussiness.GetUserSingleByUserID(item2.UserID);
				if (userSingleByUserID2 != null && item2.myRank <= 10)
				{
					string translation = LanguageMgr.GetTranslation("DragonBoatAward.All", item2.myRank);
					list2 = GetAwardInfos(2, item2.myRank);
					WorldEventMgr.SendItemsToMail(list2, item2.UserID, item2.NickName, translation);
				}
			}
			communalActiveInfo_0.IsSendAward = false;
			playerBussiness.CompleteSendDragonBoatAward();
			Console.WriteLine("===============Send DragonBoat award completed!=================");
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
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					if (communalActiveInfo_0 != null)
					{
						if (!communalActiveInfo_0.IsReset && communalActiveInfo_0.BeginTime.Date == DateTime.Now.Date)
						{
							playerBussiness.ResetDragonBoat();
							communalActiveInfo_0.IsReset = true;
						}
						if (communalActiveInfo_0.IsReset && communalActiveInfo_0.BeginTime.Date < DateTime.Now.Date)
						{
							playerBussiness.ResetCommunalActive(OpenType(), IsReset: false);
						}
					}
				}
				return smethod_0();
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("DragonBoatMgr =>Int", exception);
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
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				ActiveSystemInfo[] allActiveSystemData = playerBussiness.GetAllActiveSystemData();
				ActiveSystemInfo[] array = allActiveSystemData;
				foreach (ActiveSystemInfo activeSystemInfo in array)
				{
					if (!dictionary_0.ContainsKey(activeSystemInfo.UserID))
					{
						dictionary_0.Add(activeSystemInfo.UserID, activeSystemInfo);
					}
					else
					{
						dictionary_0[activeSystemInfo.UserID] = activeSystemInfo;
					}
				}
				UpdateRank();
				result = true;
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("DragonBoatMgr =>LoadLocalTotalScore", exception);
				}
			}
			try
			{
				using AreaBussiness areaBussiness = new AreaBussiness();
				AreaConfigInfo[] allAreaConfig = areaBussiness.GetAllAreaConfig();
				List<ActiveSystemInfo> list = new List<ActiveSystemInfo>();
				AreaConfigInfo[] array2 = allAreaConfig;
				foreach (AreaConfigInfo areaConfigInfo in array2)
				{
					using AreaBussiness areaBussiness2 = new AreaBussiness(areaConfigInfo);
					ActiveSystemInfo[] allActiveSystemData2 = areaBussiness2.GetAllActiveSystemData();
					ActiveSystemInfo[] array3 = allActiveSystemData2;
					foreach (ActiveSystemInfo activeSystemInfo2 in array3)
					{
						if (activeSystemInfo2.totalScore != 0)
						{
							activeSystemInfo2.ZoneID = areaConfigInfo.AreaID;
							activeSystemInfo2.ZoneName = areaConfigInfo.AreaName;
							list.Add(activeSystemInfo2);
						}
					}
				}
				UpdateAreaRank(list);
				result = true;
			}
			catch (Exception exception2)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("DragonBoatMgr =>LoadAreaTotalScore", exception2);
				}
			}
			UpdateBoatCompleteExp();
			return result;
		}

		public static bool UpdateTotalBoatExp(ActiveSystemInfo asi)
		{
			List<ActiveSystemInfo> list = new List<ActiveSystemInfo>();
			foreach (ActiveSystemInfo item in list_0)
			{
				if (item.UserID != asi.UserID || item.ZoneID != asi.ZoneID)
				{
					list.Add(item);
				}
			}
			list.Add(asi);
			UpdateAreaRank(list);
			return true;
		}

		public static void UpdateAreaRank(List<ActiveSystemInfo> list)
		{
			if (communalActiveInfo_0 == null)
			{
				return;
			}
			list_0.Clear();
			IOrderedEnumerable<ActiveSystemInfo> orderedEnumerable = list.OrderByDescending((ActiveSystemInfo activeSystemInfo_0) => activeSystemInfo_0.totalScore);
			int num = 1;
			foreach (ActiveSystemInfo item in orderedEnumerable)
			{
				if (item.totalScore >= communalActiveInfo_0.MinScore)
				{
					item.myRank = num;
					list_0.Add(item);
					num++;
				}
			}
		}

		public static bool IsDragonBoatOpen()
		{
			return communalActiveInfo_0 != null;
		}

		public static bool UpdateLocalBoatExp(ActiveSystemInfo info)
		{
			UpdateTotalBoatExp(info);
			if (!dictionary_0.Keys.Contains(info.UserID))
			{
				dictionary_0.Add(info.UserID, info);
			}
			else
			{
				dictionary_0[info.UserID] = info;
			}
			UpdateRank();
			return true;
		}

		public static void UpdateRank()
		{
			if (communalActiveInfo_0 == null)
			{
				return;
			}
			IEnumerable<KeyValuePair<int, ActiveSystemInfo>> source = dictionary_0;
			IOrderedEnumerable<KeyValuePair<int, ActiveSystemInfo>> orderedEnumerable = source.OrderByDescending((KeyValuePair<int, ActiveSystemInfo> pair) => pair.Value.totalScore);
			int num = 1;
			foreach (KeyValuePair<int, ActiveSystemInfo> item in orderedEnumerable)
			{
				if (item.Value.totalScore >= communalActiveInfo_0.MinScore)
				{
					dictionary_0[item.Value.UserID].myRank = num;
					num++;
				}
			}
		}

		public static int boatCompleteExp()
		{
			return int_0;
		}

		public static void UpdateBoatCompleteExp()
		{
			int_0 = 0;
			foreach (ActiveSystemInfo value in dictionary_0.Values)
			{
				int_0 += value.totalScore;
			}
		}

		public static int ReduceToemUpGrace()
		{
			List<CommunalActiveExpInfo> list = CommunalActiveMgr.FindCommunalActiveExp(OpenType());
			int num = int_0;
			if (num >= list[list.Count - 1].Exp)
			{
				return 30;
			}
			return 0;
		}

		public static bool IsContinuous()
		{
			return communalActiveInfo_0 != null && communalActiveInfo_0.EndTime.Date >= DateTime.Now.Date;
		}

		public static int periodType()
		{
			if (!IsContinuous())
			{
				return 2;
			}
			List<CommunalActiveExpInfo> list = CommunalActiveMgr.FindCommunalActiveExp(OpenType());
			int num = 1250000;
			if (list.Count == 6)
			{
				num = list[5].Exp;
			}
			else
			{
				Console.WriteLine("Communal Active Exp Error, count: {0}", list.Count);
			}
			int num2 = int_0;
			if (num2 >= num)
			{
				return 2;
			}
			return 1;
		}

		public static int AddExpPlus()
		{
			List<CommunalActiveExpInfo> list = CommunalActiveMgr.FindCommunalActiveExp(OpenType());
			int num = int_0;
			foreach (CommunalActiveExpInfo item in list)
			{
				if (num >= item.Exp)
				{
					return item.AddExpPlus;
				}
			}
			return 0;
		}

		public static int DayMaxScore()
		{
			if (communalActiveInfo_0 != null)
			{
				return communalActiveInfo_0.DayMaxScore;
			}
			return -1;
		}

		public static int MinScore()
		{
			if (communalActiveInfo_0 != null)
			{
				return communalActiveInfo_0.MinScore;
			}
			return 13000;
		}

		public static string AddPropertyByMoney()
		{
			if (communalActiveInfo_0 != null)
			{
				return communalActiveInfo_0.AddPropertyByMoney;
			}
			return "100:10,10";
		}

		public static string AddPropertyByProp()
		{
			if (communalActiveInfo_0 != null)
			{
				return communalActiveInfo_0.AddPropertyByProp;
			}
			return "1:10,10";
		}

		public static int OpenType()
		{
			if (communalActiveInfo_0 != null)
			{
				return communalActiveInfo_0.ActiveID;
			}
			return 1;
		}

		public static List<ItemInfo> GetAwardInfos(int area, int rank)
		{
			List<ItemInfo> list = new List<ItemInfo>();
			if (communalActiveInfo_0 != null)
			{
				List<CommunalActiveAwardInfo> list2 = CommunalActiveMgr.FindCommunalActiveAward(communalActiveInfo_0.ActiveID);
				foreach (CommunalActiveAwardInfo item in list2)
				{
					if (item.IsArea == area && item.RandID == rank)
					{
						ItemTemplateInfo goods = ItemMgr.FindItemTemplate(item.TemplateID);
						ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(goods, item.Count, 105);
						ıtemInfo.IsBinds = item.IsBind;
						ıtemInfo.ValidDate = item.ValidDate;
						list.Add(ıtemInfo);
					}
				}
			}
			return list;
		}

		public static int FindMyRank(int ID)
		{
			if (!dictionary_0.ContainsKey(ID))
			{
				return -1;
			}
			int myRank = dictionary_0[ID].myRank;
			if (myRank != 0)
			{
				return myRank;
			}
			return -1;
		}

		public static int FindAreaMyRank(int ID, int zoneID)
		{
			foreach (ActiveSystemInfo item in list_0)
			{
				if (item.UserID == ID && item.ZoneID == zoneID)
				{
					return (item.myRank == 0) ? (-1) : item.myRank;
				}
			}
			return -1;
		}

		public static List<ActiveSystemInfo> SelectTopTenCurrenServer()
		{
			List<ActiveSystemInfo> list = new List<ActiveSystemInfo>();
			IEnumerable<KeyValuePair<int, ActiveSystemInfo>> source = dictionary_0;
			IEnumerable<KeyValuePair<int, ActiveSystemInfo>> source2 = source.Where((KeyValuePair<int, ActiveSystemInfo> pair) => pair.Value.totalScore >= MinScore());
			IEnumerable<KeyValuePair<int, ActiveSystemInfo>> enumerable = source2.OrderByDescending((KeyValuePair<int, ActiveSystemInfo> pair) => pair.Value.totalScore).Take(10);
			foreach (KeyValuePair<int, ActiveSystemInfo> item in enumerable)
			{
				list.Add(item.Value);
			}
			return list;
		}

		public static List<ActiveSystemInfo> SelectTopTenAllServer()
		{
			IEnumerable<ActiveSystemInfo> source = list_0;
			IEnumerable<ActiveSystemInfo> source2 = source.Where((ActiveSystemInfo activeSystemInfo_0) => activeSystemInfo_0.totalScore >= MinScore());
			return source2.OrderByDescending((ActiveSystemInfo activeSystemInfo_0) => activeSystemInfo_0.totalScore).Take(10).ToList();
		}

		[CompilerGenerated]
		private static int smethod_1(ActiveSystemInfo activeSystemInfo_0)
		{
			return activeSystemInfo_0.totalScore;
		}

		[CompilerGenerated]
		private static int smethod_2(KeyValuePair<int, ActiveSystemInfo> pair)
		{
			return pair.Value.totalScore;
		}

		[CompilerGenerated]
		private static bool smethod_3(KeyValuePair<int, ActiveSystemInfo> pair)
		{
			return pair.Value.totalScore >= MinScore();
		}

		[CompilerGenerated]
		private static int smethod_4(KeyValuePair<int, ActiveSystemInfo> pair)
		{
			return pair.Value.totalScore;
		}

		[CompilerGenerated]
		private static bool smethod_5(ActiveSystemInfo activeSystemInfo_0)
		{
			return activeSystemInfo_0.totalScore >= MinScore();
		}

		[CompilerGenerated]
		private static int smethod_6(ActiveSystemInfo activeSystemInfo_0)
		{
			return activeSystemInfo_0.totalScore;
		}

		static DragonBoatMgr()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			dictionary_0 = new Dictionary<int, ActiveSystemInfo>();
			list_0 = new List<ActiveSystemInfo>();
			DRAGONBOAT_CHIP = 11690;
			KINGSTATUE_CHIP = 11771;
			LINSHI_CHIP = 201309;
			int_0 = 0;
		}
	}
}
