using Bussiness;
using Bussiness.Managers;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Runtime.CompilerServices;
namespace Center.Server
{
	public class WorldMgr
	{
		private static readonly ILog ilog_0;
		public static System.Collections.Generic.List<string> NotceList;
		private static object object_0;
		private static System.Collections.Generic.Dictionary<string, RankingPersonInfo> dictionary_0;
		private static System.Collections.Generic.Dictionary<string, RankingLightriddleInfo> dictionary_1;
		public static string[] name;
		public static string[] bossResourceId;
		public static int[] Pve_Id;
		public static readonly long MAX_BLOOD;
		public static long current_blood;
		public static System.DateTime begin_time;
		public static System.DateTime end_time;
		public static bool fightOver;
		public static bool roomClose;
		public static bool worldOpen;
		private static readonly int int_0;
		public static System.DateTime LeagueOpenTime;
		public static bool IsLeagueOpen;
		public static System.DateTime BattleGoundOpenTime;
		public static bool IsBattleGoundOpen;
		public static System.DateTime FightFootballTime;
		public static bool IsFightFootballTime;
		public static int currentPVE_ID;
		public static int fight_time;
		private static System.Collections.Generic.Dictionary<int, LanternriddlesInfo> dictionary_2;
		private static System.Collections.Generic.Dictionary<int, LuckStarRewardRecordInfo> dictionary_3;
		private static System.Collections.Generic.Dictionary<int, HalloweenRankInfo> dictionary_4;
		public static bool CanSendLightriddleAward;
		public static bool CanSendLuckyStarAward;
		private static int int_1;
		private static int imcqPvDa5;
		[System.Runtime.CompilerServices.CompilerGenerated]
		private static Func<HalloweenRankInfo, int> func_0;
		[System.Runtime.CompilerServices.CompilerGenerated]
		private static Func<System.Collections.Generic.KeyValuePair<string, RankingLightriddleInfo>, bool> func_1;
		[System.Runtime.CompilerServices.CompilerGenerated]
		private static Func<System.Collections.Generic.KeyValuePair<string, RankingLightriddleInfo>, int> func_2;
		[System.Runtime.CompilerServices.CompilerGenerated]
		private static Func<System.Collections.Generic.KeyValuePair<string, RankingLightriddleInfo>, int> func_3;
		[System.Runtime.CompilerServices.CompilerGenerated]
		private static Func<System.Collections.Generic.KeyValuePair<string, RankingPersonInfo>, int> func_4;
		public static bool Start()
		{
			bool result;
			try
			{
				WorldMgr.CanSendLightriddleAward = true;
				WorldMgr.CanSendLuckyStarAward = true;
				WorldMgr.dictionary_0 = new System.Collections.Generic.Dictionary<string, RankingPersonInfo>();
				WorldMgr.dictionary_1 = new System.Collections.Generic.Dictionary<string, RankingLightriddleInfo>();
				WorldMgr.dictionary_2 = new System.Collections.Generic.Dictionary<int, LanternriddlesInfo>();
				WorldMgr.dictionary_3 = new System.Collections.Generic.Dictionary<int, LuckStarRewardRecordInfo>();
				WorldMgr.dictionary_4 = new System.Collections.Generic.Dictionary<int, HalloweenRankInfo>();
				WorldMgr.current_blood = WorldMgr.MAX_BLOOD;
				WorldMgr.begin_time = System.DateTime.Now;
				WorldMgr.LeagueOpenTime = System.DateTime.Now;
				WorldMgr.BattleGoundOpenTime = System.DateTime.Now;
				WorldMgr.FightFootballTime = System.DateTime.Now;
				WorldMgr.ResetLuckStar();
				WorldMgr.end_time = WorldMgr.begin_time.AddDays(1.0);
				WorldMgr.fightOver = true;
				WorldMgr.roomClose = true;
				WorldMgr.worldOpen = false;
				WorldMgr.IsLeagueOpen = false;
				WorldMgr.IsBattleGoundOpen = false;
				WorldMgr.IsFightFootballTime = false;
				result = true;
			}
			catch (System.Exception ex)
			{
				WorldMgr.ilog_0.ErrorFormat("Load server list from db failed:{0}", ex);
				result = false;
			}
			return result;
		}
		public static void ResetLightriddleRank()
		{
			WorldMgr.dictionary_1.Clear();
		}
		public static void ResetHalloween()
		{
			WorldMgr.dictionary_4.Clear();
		}
		public static void UpdateHalloweenRank(int ID, string nickName, int useNum, int isVip)
		{
			if (WorldMgr.dictionary_4.ContainsKey(ID))
			{
				WorldMgr.dictionary_4[ID].useNum = useNum;
				return;
			}
			HalloweenRankInfo halloweenRankInfo = new HalloweenRankInfo();
			halloweenRankInfo.UserID = ID;
			halloweenRankInfo.nickName = nickName;
			halloweenRankInfo.useNum = useNum;
			halloweenRankInfo.isVip = isVip;
			WorldMgr.dictionary_4.Add(ID, halloweenRankInfo);
		}
		public static void UpdateHalloweenRankAll()
		{
			System.Collections.Generic.List<HalloweenRankInfo> list = new System.Collections.Generic.List<HalloweenRankInfo>();
			foreach (HalloweenRankInfo current in WorldMgr.dictionary_4.Values)
			{
				list.Add(current);
			}
			if (list.Count > 0)
			{
				System.Collections.Generic.IEnumerable<HalloweenRankInfo> arg_6C_0 = list;
				if (WorldMgr.func_0 == null)
				{
					WorldMgr.func_0 = new Func<HalloweenRankInfo, int>(WorldMgr.smethod_0);
				}
				System.Collections.Generic.List<HalloweenRankInfo> list2 = arg_6C_0.OrderByDescending(WorldMgr.func_0).ToList<HalloweenRankInfo>();
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					lock (WorldMgr.dictionary_4)
					{
						int num = 1;
						foreach (HalloweenRankInfo current2 in list2)
						{
							current2.rank = num;
							if (WorldMgr.dictionary_4.ContainsKey(current2.UserID))
							{
								WorldMgr.dictionary_4[current2.UserID] = current2;
								playerBussiness.UpdateHalloweenRank(current2);
							}
							num++;
						}
					}
				}
			}
			CenterServer.Instance.SendReloadHalloweenRank();
		}
		public static void ResetLuckStar()
		{
			WorldMgr.dictionary_3.Clear();
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				playerBussiness.ResetLuckStarRank();
			}
			WorldMgr.int_1 = System.Math.Abs(60 - System.DateTime.Now.Minute - 30);
		}
		public static void UpdateLuckStarRewardRecord(int PlayerID, string nickName, int TemplateID, int Count, int isVip)
		{
			if (WorldMgr.dictionary_3.Keys.Contains(PlayerID))
			{
				WorldMgr.dictionary_3[PlayerID].useStarNum++;
				return;
			}
			LuckStarRewardRecordInfo luckStarRewardRecordInfo = new LuckStarRewardRecordInfo();
			luckStarRewardRecordInfo.PlayerID = PlayerID;
			luckStarRewardRecordInfo.nickName = nickName;
			luckStarRewardRecordInfo.useStarNum = 1;
			luckStarRewardRecordInfo.TemplateID = TemplateID;
			luckStarRewardRecordInfo.Count = Count;
			luckStarRewardRecordInfo.isVip = isVip;
			WorldMgr.dictionary_3.Add(PlayerID, luckStarRewardRecordInfo);
		}
		public static void SendLuckyStarTopTenAward()
		{
			int minUseNum = GameProperties.MinUseNum;
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				LuckStarRewardRecordInfo[] luckStarTopTenRank = playerBussiness.GetLuckStarTopTenRank(minUseNum);
				LuckStarRewardRecordInfo[] array = luckStarTopTenRank;
				for (int i = 0; i < array.Length; i++)
				{
					LuckStarRewardRecordInfo luckStarRewardRecordInfo = array[i];
					System.Collections.Generic.List<LuckyStartToptenAwardInfo> luckyStartAwardByRank = WorldEventMgr.GetLuckyStartAwardByRank(luckStarRewardRecordInfo.rank);
					System.Collections.Generic.List<ItemInfo> list = new System.Collections.Generic.List<ItemInfo>();
					foreach (LuckyStartToptenAwardInfo current in luckyStartAwardByRank)
					{
						ItemTemplateInfo goods = ItemMgr.FindItemTemplate(current.TemplateID);
						ItemInfo itemInfo = ItemInfo.CreateFromTemplate(goods, 1, 105);
						itemInfo.IsBinds = current.IsBinds;
						itemInfo.ValidDate = current.Validate;
						itemInfo.Count = current.Count;
						list.Add(itemInfo);
					}
					WorldEventMgr.SendItemsToMail(list, luckStarRewardRecordInfo.PlayerID, luckStarRewardRecordInfo.nickName, LanguageMgr.GetTranslation("LuckyStarTopTenAward.GetAward", new object[]
					{
						luckStarRewardRecordInfo.rank
					}));
				}
			}
			WorldMgr.CanSendLuckyStarAward = false;
		}
		public static System.Collections.Generic.List<LuckStarRewardRecordInfo> GetAllLuckyStarRank()
		{
			System.Collections.Generic.List<LuckStarRewardRecordInfo> list = new System.Collections.Generic.List<LuckStarRewardRecordInfo>();
			foreach (LuckStarRewardRecordInfo current in WorldMgr.dictionary_3.Values)
			{
				list.Add(current);
			}
			return list;
		}
		public static void SaveLuckyStarToDatabase()
		{
			System.Collections.Generic.List<LuckStarRewardRecordInfo> allLuckyStarRank = WorldMgr.GetAllLuckyStarRank();
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				foreach (LuckStarRewardRecordInfo current in allLuckyStarRank)
				{
					playerBussiness.SaveLuckStarRankInfo(current);
				}
			}
		}
		public static void SaveLuckyStarRewardRecord()
		{
			int arg_0D_0 = System.DateTime.Now.Hour;
			if (WorldMgr.int_1 > 0)
			{
				WorldMgr.int_1--;
			}
			if (WorldMgr.int_1 == 0)
			{
				if (WorldMgr.CanSendLuckyStarAward)
				{
					WorldMgr.SaveLuckyStarToDatabase();
					WorldMgr.int_1 = 30;
				}
				else
				{
					WorldMgr.int_1 = -1;
				}
			}
			if (WorldMgr.imcqPvDa5 == 1)
			{
				WorldMgr.UpdateHalloweenRankAll();
				WorldMgr.imcqPvDa5 = 0;
				return;
			}
			WorldMgr.imcqPvDa5++;
		}
		public static void AddOrUpdateLanternriddles(int playerID, LanternriddlesInfo Lanternriddles)
		{
			if (!WorldMgr.dictionary_2.ContainsKey(playerID))
			{
				WorldMgr.dictionary_2.Add(playerID, Lanternriddles);
				return;
			}
			WorldMgr.dictionary_2[playerID] = Lanternriddles;
		}
		public static LanternriddlesInfo GetLanternriddles(int playerID)
		{
			if (WorldMgr.dictionary_2.ContainsKey(playerID))
			{
				return WorldMgr.dictionary_2[playerID];
			}
			return null;
		}
		public static void UpdateLightriddleRank(int integer, int typeVip, string nickName, int playerId)
		{
			if (WorldMgr.dictionary_1.Keys.Contains(nickName))
			{
				WorldMgr.dictionary_1[nickName].Integer = integer;
			}
			else
			{
				RankingLightriddleInfo rankingLightriddleInfo = new RankingLightriddleInfo();
				rankingLightriddleInfo.NickName = nickName;
				rankingLightriddleInfo.Integer = integer;
				rankingLightriddleInfo.TypeVIP = typeVip;
				rankingLightriddleInfo.PlayerId = playerId;
				WorldMgr.dictionary_1.Add(nickName, rankingLightriddleInfo);
			}
			WorldMgr.SortRank();
		}
		public static void SendLightriddleTopEightAward()
		{
			System.Collections.Generic.List<RankingLightriddleInfo> list = WorldMgr.SelectTopEight();
			foreach (RankingLightriddleInfo current in list)
			{
				System.Collections.Generic.List<LuckyStartToptenAwardInfo> lanternriddlesAwardByRank = WorldEventMgr.GetLanternriddlesAwardByRank(current.Rank);
				System.Collections.Generic.List<ItemInfo> list2 = new System.Collections.Generic.List<ItemInfo>();
				foreach (LuckyStartToptenAwardInfo current2 in lanternriddlesAwardByRank)
				{
					ItemTemplateInfo goods = ItemMgr.FindItemTemplate(current2.TemplateID);
					ItemInfo itemInfo = ItemInfo.CreateFromTemplate(goods, 1, 105);
					itemInfo.IsBinds = current2.IsBinds;
					itemInfo.ValidDate = current2.Validate;
					itemInfo.Count = current2.Count;
					list2.Add(itemInfo);
				}
				WorldEventMgr.SendItemsToMail(list2, current.PlayerId, current.NickName, LanguageMgr.GetTranslation("LightriddleTopEightAward.GetAward", new object[]
				{
					current.Rank
				}));
			}
			WorldMgr.CanSendLightriddleAward = false;
		}
		public static System.Collections.Generic.List<RankingLightriddleInfo> SelectTopEight()
		{
			System.Collections.Generic.List<RankingLightriddleInfo> list = new System.Collections.Generic.List<RankingLightriddleInfo>();
			System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, RankingLightriddleInfo>> arg_28_0 = WorldMgr.dictionary_1;
			if (WorldMgr.func_1 == null)
			{
				WorldMgr.func_1 = new Func<System.Collections.Generic.KeyValuePair<string, RankingLightriddleInfo>, bool>(WorldMgr.smethod_1);
			}
			System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, RankingLightriddleInfo>> arg_4A_0 = arg_28_0.Where(WorldMgr.func_1);
			if (WorldMgr.func_2 == null)
			{
				WorldMgr.func_2 = new Func<System.Collections.Generic.KeyValuePair<string, RankingLightriddleInfo>, int>(WorldMgr.smethod_2);
			}
			IOrderedEnumerable<System.Collections.Generic.KeyValuePair<string, RankingLightriddleInfo>> orderedEnumerable = arg_4A_0.OrderByDescending(WorldMgr.func_2);
			foreach (System.Collections.Generic.KeyValuePair<string, RankingLightriddleInfo> current in orderedEnumerable)
			{
				if (list.Count == 8)
				{
					break;
				}
				list.Add(current.Value);
			}
			return list;
		}
		public static void SortRank()
		{
			System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, RankingLightriddleInfo>> arg_22_0 = WorldMgr.dictionary_1;
			if (WorldMgr.func_3 == null)
			{
				WorldMgr.func_3 = new Func<System.Collections.Generic.KeyValuePair<string, RankingLightriddleInfo>, int>(WorldMgr.smethod_3);
			}
			IOrderedEnumerable<System.Collections.Generic.KeyValuePair<string, RankingLightriddleInfo>> orderedEnumerable = arg_22_0.OrderByDescending(WorldMgr.func_3);
			int num = 1;
			System.Collections.Generic.Dictionary<string, RankingLightriddleInfo> dictionary = new System.Collections.Generic.Dictionary<string, RankingLightriddleInfo>();
			foreach (System.Collections.Generic.KeyValuePair<string, RankingLightriddleInfo> current in orderedEnumerable)
			{
				current.Value.Rank = num;
				dictionary.Add(current.Key, current.Value);
				num++;
			}
			WorldMgr.dictionary_1 = dictionary;
		}
		public static void UpdateRank(int damage, int honor, string nickName)
		{
			if (WorldMgr.dictionary_0.Keys.Contains(nickName))
			{
				WorldMgr.dictionary_0[nickName].Damage += damage;
				WorldMgr.dictionary_0[nickName].Honor += honor;
				return;
			}
			RankingPersonInfo rankingPersonInfo = new RankingPersonInfo();
			rankingPersonInfo.ID = WorldMgr.dictionary_0.Count + 1;
			rankingPersonInfo.Name = nickName;
			rankingPersonInfo.Damage = damage;
			rankingPersonInfo.Honor = honor;
			WorldMgr.dictionary_0.Add(nickName, rankingPersonInfo);
		}
		public static bool CheckName(string NickName)
		{
			return WorldMgr.dictionary_0.Keys.Contains(NickName);
		}
		public static RankingPersonInfo GetSingleRank(string name)
		{
			return WorldMgr.dictionary_0[name];
		}
		public static System.Collections.Generic.List<RankingPersonInfo> SelectTopTen()
		{
			System.Collections.Generic.List<RankingPersonInfo> list = new System.Collections.Generic.List<RankingPersonInfo>();
			System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, RankingPersonInfo>> arg_28_0 = WorldMgr.dictionary_0;
			if (WorldMgr.func_4 == null)
			{
				WorldMgr.func_4 = new Func<System.Collections.Generic.KeyValuePair<string, RankingPersonInfo>, int>(WorldMgr.smethod_4);
			}
			IOrderedEnumerable<System.Collections.Generic.KeyValuePair<string, RankingPersonInfo>> orderedEnumerable = arg_28_0.OrderByDescending(WorldMgr.func_4);
			foreach (System.Collections.Generic.KeyValuePair<string, RankingPersonInfo> current in orderedEnumerable)
			{
				if (list.Count == 10)
				{
					break;
				}
				list.Add(current.Value);
			}
			return list;
		}
		public static void SetupWorldBoss(int id)
		{
			WorldMgr.current_blood = WorldMgr.MAX_BLOOD;
			WorldMgr.begin_time = System.DateTime.Now;
			WorldMgr.end_time = WorldMgr.begin_time.AddDays(1.0);
			WorldMgr.fight_time = WorldMgr.int_0 - WorldMgr.begin_time.Minute;
			WorldMgr.fightOver = false;
			WorldMgr.roomClose = false;
			WorldMgr.currentPVE_ID = id;
			WorldMgr.worldOpen = true;
		}
		public static void WorldBossFightOver()
		{
			WorldMgr.fightOver = true;
		}
		public static void WorldBossRoomClose()
		{
			WorldMgr.roomClose = true;
		}
		public static void UpdateFightTime()
		{
			if (!WorldMgr.fightOver)
			{
				WorldMgr.fight_time = WorldMgr.int_0 - WorldMgr.begin_time.Minute;
			}
		}
		public static void WorldBossClose()
		{
			WorldMgr.worldOpen = false;
		}
		public static void WorldBossClearRank()
		{
			WorldMgr.dictionary_0.Clear();
		}
		public static void ReduceBlood(int value)
		{
			if (WorldMgr.current_blood > 0L)
			{
				WorldMgr.current_blood -= (long)value;
			}
		}
		public WorldMgr()
		{
			
			
		}
		[System.Runtime.CompilerServices.CompilerGenerated]
		private static int smethod_0(HalloweenRankInfo halloweenRankInfo_0)
		{
			return halloweenRankInfo_0.useNum;
		}
		[System.Runtime.CompilerServices.CompilerGenerated]
		private static bool smethod_1(System.Collections.Generic.KeyValuePair<string, RankingLightriddleInfo> pair)
		{
			return pair.Value.Integer > 1;
		}
		[System.Runtime.CompilerServices.CompilerGenerated]
		private static int smethod_2(System.Collections.Generic.KeyValuePair<string, RankingLightriddleInfo> pair)
		{
			return pair.Value.Integer;
		}
		[System.Runtime.CompilerServices.CompilerGenerated]
		private static int smethod_3(System.Collections.Generic.KeyValuePair<string, RankingLightriddleInfo> pair)
		{
			return pair.Value.Integer;
		}
		[System.Runtime.CompilerServices.CompilerGenerated]
		private static int smethod_4(System.Collections.Generic.KeyValuePair<string, RankingPersonInfo> pair)
		{
			return pair.Value.Damage;
		}
		static WorldMgr()
		{
			
			WorldMgr.ilog_0 = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
			WorldMgr.NotceList = new System.Collections.Generic.List<string>();
			WorldMgr.object_0 = new object();
			WorldMgr.name = new string[]
			{
				"Dragão Antigo",
				"Conde da Noite",
				"Conde da Noite",
				"Capitão do Futebol"
			};
			WorldMgr.bossResourceId = new string[]
			{
				"1",
				"2",
				"2",
				"4"
			};
			WorldMgr.Pve_Id = new int[]
			{
				1243,
				30001,
				30002,
				30004
			};
			WorldMgr.MAX_BLOOD = 3000000000L;
			WorldMgr.current_blood = 0L;
			WorldMgr.int_0 = 60;
			WorldMgr.imcqPvDa5 = 0;
		}
	}
}
