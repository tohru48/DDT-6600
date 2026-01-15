using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Game.Server.DragonBoat;
using Game.Server.GameObjects;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Managers
{
	public class ActiveSystemMgr
	{
		private static readonly ILog ilog_0;

		private static ThreadSafeRandom threadSafeRandom_0;

		private static Dictionary<int, LanternriddlesInfo> dictionary_0;

		private static List<LuckStarRewardRecordInfo> list_0;

		protected static Timer m_lanternriddlesScanTimer;

		private static bool bool_0;

		private static bool bool_1;

		private static bool bool_2;

		private static bool bool_3;

		private static bool bool_4;

		private static bool vPhiHujDqh;

		private static int int_0;

		private static Dictionary<int, HalloweenRankInfo> dictionary_1;

		[CompilerGenerated]
		private static Func<ActivitySystemItemInfo, int> func_0;

		public static List<LuckStarRewardRecordInfo> RecordList => list_0;

		public static bool LanternriddlesOpen => bool_2;

		public static bool IsBattleGoundOpen
		{
			get
			{
				return bool_3;
			}
			set
			{
				bool_3 = value;
			}
		}

		public static bool IsLeagueOpen
		{
			get
			{
				return bool_4;
			}
			set
			{
				bool_4 = value;
			}
		}

		public static bool IsFightFootballTime
		{
			get
			{
				return vPhiHujDqh;
			}
			set
			{
				vPhiHujDqh = value;
			}
		}

		public static DateTime EndDate => DateTime.Now.AddMilliseconds(GameProperties.LightRiddleAnswerTime * 1000);

		public static bool Init()
		{
			try
			{
				threadSafeRandom_0 = new ThreadSafeRandom();
				bool_3 = false;
				bool_4 = false;
				vPhiHujDqh = false;
				bool_2 = false;
				bool_0 = true;
				bool_1 = true;
				int_0 = Math.Abs(60 - DateTime.Now.Minute - 30);
				BeginTimer();
				return LoadEventData();
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("ActiveSystemMgr", exception);
				}
				return false;
			}
		}

		public static bool LoadEventData()
		{
			return DragonBoatMgr.Init() && ReloadHalloweenRank();
		}

		public static void AddOrUpdateLanternriddles(int playerID, LanternriddlesInfo Lanternriddles)
		{
			Lanternriddles.QuestViews = LightriddleQuestMgr.Get30LightriddleQuest();
			if (!dictionary_0.ContainsKey(playerID))
			{
				dictionary_0.Add(playerID, Lanternriddles);
			}
			else
			{
				dictionary_0[playerID] = Lanternriddles;
			}
		}

		public static LanternriddlesInfo EnterLanternriddles(int playerID)
		{
			if (!dictionary_0.ContainsKey(playerID))
			{
				LanternriddlesInfo lanternriddlesInfo = new LanternriddlesInfo();
				lanternriddlesInfo.PlayerID = playerID;
				lanternriddlesInfo.QuestionIndex = 1;
				lanternriddlesInfo.QuestionView = 30;
				lanternriddlesInfo.DoubleFreeCount = GameProperties.LightRiddleFreeComboNum;
				lanternriddlesInfo.DoublePrice = GameProperties.LightRiddleComboMoney;
				lanternriddlesInfo.HitFreeCount = GameProperties.LightRiddleFreeHitNum;
				lanternriddlesInfo.HitPrice = GameProperties.LightRiddleHitMoney;
				lanternriddlesInfo.QuestViews = LightriddleQuestMgr.Get30LightriddleQuest();
				lanternriddlesInfo.MyInteger = 0;
				lanternriddlesInfo.QuestionNum = 0;
				lanternriddlesInfo.Option = -1;
				lanternriddlesInfo.IsHint = false;
				lanternriddlesInfo.IsDouble = false;
				lanternriddlesInfo.EndDate = EndDate;
				dictionary_0.Add(playerID, lanternriddlesInfo);
				return lanternriddlesInfo;
			}
			return GetLanternriddlesInfo(playerID);
		}

		public static LanternriddlesInfo GetLanternriddlesInfo(int playerID)
		{
			if (dictionary_0.ContainsKey(playerID))
			{
				if (dictionary_0[playerID].CanNextQuest)
				{
					dictionary_0[playerID].EndDate = EndDate;
					dictionary_0[playerID].QuestionIndex++;
				}
				if (dictionary_0[playerID].EndDate.Date != DateTime.Now.Date)
				{
					dictionary_0[playerID].EndDate = DateTime.Now;
					dictionary_0[playerID].QuestionIndex = 1;
					dictionary_0[playerID].QuestViews = LightriddleQuestMgr.Get30LightriddleQuest();
					dictionary_0[playerID].DoubleFreeCount = GameProperties.LightRiddleFreeComboNum;
					dictionary_0[playerID].DoublePrice = GameProperties.LightRiddleComboMoney;
					dictionary_0[playerID].HitFreeCount = GameProperties.LightRiddleFreeHitNum;
					dictionary_0[playerID].HitPrice = GameProperties.LightRiddleHitMoney;
					dictionary_0[playerID].MyInteger = 0;
					dictionary_0[playerID].QuestionNum = 0;
					dictionary_0[playerID].Option = -1;
					dictionary_0[playerID].IsHint = false;
					dictionary_0[playerID].IsDouble = false;
					dictionary_0[playerID].EndDate = EndDate;
				}
				return dictionary_0[playerID];
			}
			return CreateNullLanternriddlesInfo(playerID);
		}

		public static LanternriddlesInfo CreateNullLanternriddlesInfo(int playerID)
		{
			LanternriddlesInfo lanternriddlesInfo = new LanternriddlesInfo();
			lanternriddlesInfo.PlayerID = playerID;
			lanternriddlesInfo.QuestionIndex = 30;
			lanternriddlesInfo.QuestionView = 30;
			lanternriddlesInfo.DoubleFreeCount = GameProperties.LightRiddleFreeComboNum;
			lanternriddlesInfo.DoublePrice = GameProperties.LightRiddleComboMoney;
			lanternriddlesInfo.HitFreeCount = GameProperties.LightRiddleFreeHitNum;
			lanternriddlesInfo.HitPrice = GameProperties.LightRiddleHitMoney;
			lanternriddlesInfo.MyInteger = 0;
			lanternriddlesInfo.QuestionNum = 0;
			lanternriddlesInfo.Option = -1;
			lanternriddlesInfo.IsHint = true;
			lanternriddlesInfo.IsDouble = true;
			lanternriddlesInfo.EndDate = DateTime.Now;
			return lanternriddlesInfo;
		}

		public static LanternriddlesInfo GetLanternriddles(int playerID)
		{
			if (dictionary_0.ContainsKey(playerID))
			{
				return dictionary_0[playerID];
			}
			return null;
		}

		public static void UpdateLanternriddles(int playerID, LanternriddlesInfo info)
		{
			if (dictionary_0.ContainsKey(playerID) && info != null)
			{
				dictionary_0[playerID] = info;
			}
		}

		public static void LanternriddlesAnswer(int playerID, int option)
		{
			if (dictionary_0.ContainsKey(playerID))
			{
				dictionary_0[playerID].Option = option;
			}
		}

		private static bool smethod_0()
		{
			Convert.ToDateTime(GameProperties.LightRiddleBeginDate);
			DateTime dateTime = Convert.ToDateTime(GameProperties.LightRiddleEndDate);
			return DateTime.Now.Date < dateTime.Date;
		}

		public static bool ReloadHalloweenRank()
		{
			bool result;
			try
			{
				HalloweenRankInfo[] array = LoadHalloweenRankDb();
				Dictionary<int, HalloweenRankInfo> value = LoadHalloweenRanks(array);
				if (array.Length > 0)
				{
					Interlocked.Exchange(ref dictionary_1, value);
				}
				return true;
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("ReLoad HalloweenRank", exception);
				}
				result = false;
			}
			return result;
		}

		public static HalloweenRankInfo[] LoadHalloweenRankDb()
		{
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			return playerBussiness.GetAllHalloweenRank();
		}

		public static Dictionary<int, HalloweenRankInfo> LoadHalloweenRanks(HalloweenRankInfo[] HalloweenRank)
		{
			Dictionary<int, HalloweenRankInfo> dictionary = new Dictionary<int, HalloweenRankInfo>();
			foreach (HalloweenRankInfo halloweenRankInfo in HalloweenRank)
			{
				if (!dictionary.Keys.Contains(halloweenRankInfo.UserID))
				{
					dictionary.Add(halloweenRankInfo.UserID, halloweenRankInfo);
				}
			}
			return dictionary;
		}

		public static int FindHalloweenRank(int UserID)
		{
			if (dictionary_1.ContainsKey(UserID))
			{
				HalloweenRankInfo halloweenRankInfo = dictionary_1[UserID];
				return halloweenRankInfo.rank;
			}
			return 0;
		}

		public static void UpdateLuckStarRewardRecord(int PlayerID, string nickName, int TemplateID, int Count, int isVip)
		{
			AddRewardRecord(PlayerID, nickName, TemplateID, Count, isVip);
			GameServer.Instance.LoginServer.SendLuckStarRewardRecord(PlayerID, nickName, TemplateID, Count, isVip);
		}

		public static void AddRewardRecord(int PlayerID, string nickName, int TemplateID, int Count, int isVip)
		{
			if (list_0.Count > 10)
			{
				list_0.Clear();
			}
			LuckStarRewardRecordInfo luckStarRewardRecordInfo = new LuckStarRewardRecordInfo();
			luckStarRewardRecordInfo.PlayerID = PlayerID;
			luckStarRewardRecordInfo.nickName = nickName;
			luckStarRewardRecordInfo.useStarNum = 1;
			luckStarRewardRecordInfo.TemplateID = TemplateID;
			luckStarRewardRecordInfo.Count = Count;
			luckStarRewardRecordInfo.isVip = isVip;
			list_0.Add(luckStarRewardRecordInfo);
		}

		public static void UpdateIsFightFootballTime(bool open)
		{
			vPhiHujDqh = open;
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				gamePlayer?.Out.SendFightFootballTimeOpenClose(gamePlayer.PlayerCharacter.ID, open);
			}
		}

		public static void UpdateIsLeagueOpen(bool open)
		{
			bool_4 = open;
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer != null)
				{
					if (open)
					{
						gamePlayer.Out.SendLeagueNotice(gamePlayer.PlayerCharacter.ID, gamePlayer.BattleData.MatchInfo.restCount, gamePlayer.BattleData.maxCount, 1);
					}
					else
					{
						gamePlayer.Out.SendLeagueNotice(gamePlayer.PlayerCharacter.ID, gamePlayer.BattleData.MatchInfo.restCount, gamePlayer.BattleData.maxCount, 2);
					}
				}
			}
		}

		public static void UpdateIsBattleGoundOpen(bool open)
		{
			bool_3 = open;
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				gamePlayer?.Out.SendBattleGoundOpen(gamePlayer.PlayerCharacter.ID);
			}
		}

		public static List<ItemInfo> GetPyramidAward(int layer)
		{
			List<ItemInfo> list = new List<ItemInfo>();
			List<ActivitySystemItemInfo> list2 = new List<ActivitySystemItemInfo>();
			List<ActivitySystemItemInfo> activitySystemItemByLayer = ActiveMgr.GetActivitySystemItemByLayer(layer);
			int num = 1;
			IEnumerable<ActivitySystemItemInfo> source = activitySystemItemByLayer;
			int maxRound = ThreadSafeRandom.NextStatic(source.Select((ActivitySystemItemInfo activitySystemItemInfo_0) => activitySystemItemInfo_0.Probability).Max());
			List<ActivitySystemItemInfo> list3 = activitySystemItemByLayer.Where((ActivitySystemItemInfo s) => s.Probability >= maxRound).ToList();
			int num2 = list3.Count();
			if (num2 > 0)
			{
				num = ((num > num2) ? num2 : num);
				int[] randomUnrepeatArray = GetRandomUnrepeatArray(0, num2 - 1, num);
				int[] array = randomUnrepeatArray;
				foreach (int index in array)
				{
					ActivitySystemItemInfo item = list3[index];
					list2.Add(item);
				}
			}
			foreach (ActivitySystemItemInfo item2 in list2)
			{
				ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(item2.TemplateID), item2.Count, 102);
				ıtemInfo.TemplateID = item2.TemplateID;
				ıtemInfo.IsBinds = item2.IsBind;
				ıtemInfo.ValidDate = item2.ValidDate;
				ıtemInfo.Count = item2.Count;
				ıtemInfo.StrengthenLevel = item2.StrengthLevel;
				ıtemInfo.AttackCompose = 0;
				ıtemInfo.DefendCompose = 0;
				ıtemInfo.AgilityCompose = 0;
				ıtemInfo.LuckCompose = 0;
				list.Add(ıtemInfo);
			}
			return list;
		}

		public static int[] GetRandomUnrepeatArray(int minValue, int maxValue, int count)
		{
			int[] array = new int[count];
			for (int i = 0; i < count; i++)
			{
				int num = ThreadSafeRandom.NextStatic(minValue, maxValue + 1);
				int num2 = 0;
				for (int j = 0; j < i; j++)
				{
					if (array[j] == num)
					{
						num2++;
					}
				}
				if (num2 == 0)
				{
					array[i] = num;
				}
				else
				{
					i--;
				}
			}
			return array;
		}

		public static void BeginTimer()
		{
			int num = 60000;
			if (m_lanternriddlesScanTimer == null)
			{
				m_lanternriddlesScanTimer = new Timer(LanternriddlesScan, null, num, num);
			}
			else
			{
				m_lanternriddlesScanTimer.Change(num, num);
			}
		}

		protected static void LanternriddlesScan(object sender)
		{
			try
			{
				ilog_0.Info("Begin Lanternriddles CheckPeriod....");
				int tickCount = Environment.TickCount;
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				if (smethod_0())
				{
					int hour = DateTime.Now.Hour;
					DateTime dateTime = Convert.ToDateTime(GameProperties.LightRiddleBeginTime);
					DateTime dateTime2 = Convert.ToDateTime(GameProperties.LightRiddleEndTime);
					int hour2 = dateTime.Hour;
					int hour3 = dateTime2.Hour;
					if (hour >= hour2 && hour < hour3)
					{
						bool_2 = true;
						if (bool_0)
						{
							LanternriddlesOpenClose();
							bool_0 = false;
						}
					}
					else
					{
						bool_2 = false;
						if (hour >= hour3 && bool_1)
						{
							LanternriddlesOpenClose();
							bool_1 = false;
						}
					}
				}
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
				ilog_0.Info("End Lanternriddles CheckPeriod....");
			}
			catch (Exception exception)
			{
				ilog_0.Error("lanternriddlesScan ", exception);
			}
		}

		public static void LanternriddlesOpenClose()
		{
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				gamePlayer?.Out.SendLanternriddlesOpen(gamePlayer.PlayerId, bool_2);
			}
		}

		public static void StopAllTimer()
		{
			if (m_lanternriddlesScanTimer != null)
			{
				m_lanternriddlesScanTimer.Dispose();
				m_lanternriddlesScanTimer = null;
			}
		}

		[CompilerGenerated]
		private static int smethod_1(ActivitySystemItemInfo activitySystemItemInfo_0)
		{
			return activitySystemItemInfo_0.Probability;
		}

		static ActiveSystemMgr()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			dictionary_0 = new Dictionary<int, LanternriddlesInfo>();
			list_0 = new List<LuckStarRewardRecordInfo>();
			dictionary_1 = new Dictionary<int, HalloweenRankInfo>();
		}
	}
}
