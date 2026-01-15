using System;
using System.Collections.Generic;
using System.Reflection;
using Bussiness;
using Game.Logic;
using Game.Logic.Phy.Object;
using Game.Server.GameObjects;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Managers
{
	public class ConsortiaMgr
	{
		private static readonly ILog ilog_0;

		private static Dictionary<string, int> dictionary_0;

		private static Dictionary<int, ConsortiaInfo> dictionary_1;

		private static Dictionary<int, ConsortiaBossConfigInfo> dictionary_2;

		public static bool ReLoad()
		{
			try
			{
				Dictionary<string, int> ally = new Dictionary<string, int>();
				Dictionary<int, ConsortiaInfo> consortia = new Dictionary<int, ConsortiaInfo>();
				Dictionary<int, ConsortiaBossConfigInfo> consortiaBossConfig = new Dictionary<int, ConsortiaBossConfigInfo>();
				if (smethod_0(ally) && smethod_1(consortia, consortiaBossConfig))
				{
					try
					{
						dictionary_0 = ally;
						dictionary_1 = consortia;
						dictionary_2 = consortiaBossConfig;
						return true;
					}
					catch
					{
					}
				}
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("ConsortiaMgr", exception);
				}
			}
			return false;
		}

		public static bool Init()
		{
			try
			{
				dictionary_0 = new Dictionary<string, int>();
				if (!smethod_0(dictionary_0))
				{
					return false;
				}
				dictionary_1 = new Dictionary<int, ConsortiaInfo>();
				dictionary_2 = new Dictionary<int, ConsortiaBossConfigInfo>();
				if (!smethod_1(dictionary_1, dictionary_2))
				{
					return false;
				}
				return true;
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("ConsortiaMgr", exception);
				}
				return false;
			}
		}

		private static bool smethod_0(Dictionary<string, int> ally)
		{
			using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
			{
				ConsortiaAllyInfo[] consortiaAllyAll = consortiaBussiness.GetConsortiaAllyAll();
				ConsortiaAllyInfo[] array = consortiaAllyAll;
				foreach (ConsortiaAllyInfo consortiaAllyInfo in array)
				{
					if (consortiaAllyInfo.IsExist)
					{
						string key = ((consortiaAllyInfo.Consortia1ID >= consortiaAllyInfo.Consortia2ID) ? (consortiaAllyInfo.Consortia2ID + "&" + consortiaAllyInfo.Consortia1ID) : (consortiaAllyInfo.Consortia1ID + "&" + consortiaAllyInfo.Consortia2ID));
						if (!ally.ContainsKey(key))
						{
							ally.Add(key, consortiaAllyInfo.State);
						}
					}
				}
			}
			return true;
		}

		private static bool smethod_1(Dictionary<int, ConsortiaInfo> consortia, Dictionary<int, ConsortiaBossConfigInfo> consortiaBossConfig)
		{
			using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
			{
				ConsortiaInfo[] consortiaAll = consortiaBussiness.GetConsortiaAll();
				ConsortiaInfo[] array = consortiaAll;
				foreach (ConsortiaInfo consortiaInfo in array)
				{
					if (consortiaInfo.IsExist && !consortia.ContainsKey(consortiaInfo.ConsortiaID))
					{
						consortia.Add(consortiaInfo.ConsortiaID, consortiaInfo);
					}
				}
				ConsortiaBossConfigInfo[] consortiaBossConfigAll = consortiaBussiness.GetConsortiaBossConfigAll();
				ConsortiaBossConfigInfo[] array2 = consortiaBossConfigAll;
				foreach (ConsortiaBossConfigInfo consortiaBossConfigInfo in array2)
				{
					if (!consortiaBossConfig.ContainsKey(consortiaBossConfigInfo.BossLevel))
					{
						consortiaBossConfig.Add(consortiaBossConfigInfo.BossLevel, consortiaBossConfigInfo);
					}
				}
			}
			return true;
		}

		public static int UpdateConsortiaAlly(int int_0, int consortiaID2, int state)
		{
			string key = ((int_0 >= consortiaID2) ? (consortiaID2 + "&" + int_0) : (int_0 + "&" + consortiaID2));
			if (!dictionary_0.ContainsKey(key))
			{
				dictionary_0.Add(key, state);
			}
			else
			{
				dictionary_0[key] = state;
			}
			return 0;
		}

		public static bool ConsortiaUpGrade(int consortiaID, int consortiaLevel)
		{
			bool result = false;
			if (dictionary_1.ContainsKey(consortiaID) && dictionary_1[consortiaID].IsExist)
			{
				dictionary_1[consortiaID].Level = consortiaLevel;
			}
			else
			{
				ConsortiaInfo consortiaInfo = new ConsortiaInfo();
				consortiaInfo.BuildDate = DateTime.Now;
				consortiaInfo.Level = consortiaLevel;
				consortiaInfo.IsExist = true;
				dictionary_1.Add(consortiaID, consortiaInfo);
			}
			return result;
		}

		public static bool ConsortiaStoreUpGrade(int consortiaID, int storeLevel)
		{
			bool result = false;
			if (dictionary_1.ContainsKey(consortiaID) && dictionary_1[consortiaID].IsExist)
			{
				dictionary_1[consortiaID].StoreLevel = storeLevel;
			}
			return result;
		}

		public static bool ConsortiaShopUpGrade(int consortiaID, int shopLevel)
		{
			bool result = false;
			if (dictionary_1.ContainsKey(consortiaID) && dictionary_1[consortiaID].IsExist)
			{
				dictionary_1[consortiaID].ShopLevel = shopLevel;
			}
			return result;
		}

		public static bool ConsortiaSmithUpGrade(int consortiaID, int smithLevel)
		{
			bool result = false;
			if (dictionary_1.ContainsKey(consortiaID) && dictionary_1[consortiaID].IsExist)
			{
				dictionary_1[consortiaID].SmithLevel = smithLevel;
			}
			return result;
		}

		public static bool AddConsortia(int consortiaID)
		{
			bool result = false;
			if (!dictionary_1.ContainsKey(consortiaID))
			{
				ConsortiaInfo consortiaInfo = new ConsortiaInfo();
				consortiaInfo.BuildDate = DateTime.Now;
				consortiaInfo.Level = 1;
				consortiaInfo.IsExist = true;
				consortiaInfo.ConsortiaName = "";
				consortiaInfo.ConsortiaID = consortiaID;
				dictionary_1.Add(consortiaID, consortiaInfo);
			}
			return result;
		}

		public static ConsortiaInfo FindConsortiaInfo(int consortiaID)
		{
			if (dictionary_1.ContainsKey(consortiaID))
			{
				return dictionary_1[consortiaID];
			}
			return null;
		}

		public static ConsortiaBossConfigInfo FindConsortiaBossConfig(int level)
		{
			if (dictionary_2.ContainsKey(level))
			{
				return dictionary_2[level];
			}
			return null;
		}

		public static int FindConsortiaBossMaxLevel(int param1, ConsortiaInfo info)
		{
			int num = ((param1 != 0) ? param1 : (info.Level + info.SmithLevel + info.ShopLevel + info.StoreLevel + info.SkillLevel));
			int result = 1;
			for (int num2 = dictionary_2.Count; num2 >= 0; num2--)
			{
				if (num >= dictionary_2[num2].Level)
				{
					return num2;
				}
			}
			return result;
		}

		public static int CanConsortiaFight(int consortiaID1, int consortiaID2)
		{
			if (consortiaID1 != 0 && consortiaID2 != 0 && consortiaID1 != consortiaID2)
			{
				ConsortiaInfo consortiaInfo = FindConsortiaInfo(consortiaID1);
				ConsortiaInfo consortiaInfo2 = FindConsortiaInfo(consortiaID2);
				if (consortiaInfo != null && consortiaInfo2 != null && consortiaInfo.Level >= 3 && consortiaInfo2.Level >= 3)
				{
					return FindConsortiaAlly(consortiaID1, consortiaID2);
				}
				return -1;
			}
			return -1;
		}

		public static int FindConsortiaAlly(int int_0, int consortiaID2)
		{
			if (int_0 != 0 && consortiaID2 != 0 && int_0 != consortiaID2)
			{
				string key = ((int_0 >= consortiaID2) ? (consortiaID2 + "&" + int_0) : (int_0 + "&" + consortiaID2));
				if (dictionary_0.ContainsKey(key))
				{
					return dictionary_0[key];
				}
				return 0;
			}
			return -1;
		}

		public static int GetOffer(int int_0, int consortiaID2, eGameType gameType)
		{
			return smethod_2(FindConsortiaAlly(int_0, consortiaID2), gameType);
		}

		private static int smethod_2(int int_0, eGameType eGameType_0)
		{
			switch (eGameType_0)
			{
			case eGameType.Free:
				switch (int_0)
				{
				case 0:
					return 1;
				case 1:
					return 0;
				case 2:
					return 3;
				}
				break;
			case eGameType.Guild:
				switch (int_0)
				{
				case 0:
					return 5;
				case 1:
					return 0;
				case 2:
					return 10;
				}
				break;
			}
			return 0;
		}

		public static int KillPlayer(GamePlayer win, GamePlayer lose, Dictionary<GamePlayer, Player> players, eRoomType roomType, eGameType gameClass)
		{
			if (roomType != eRoomType.Match)
			{
				return -1;
			}
			int num = FindConsortiaAlly(win.PlayerCharacter.ConsortiaID, lose.PlayerCharacter.ConsortiaID);
			if (num == -1)
			{
				return num;
			}
			int num2 = smethod_2(num, gameClass);
			if (lose.PlayerCharacter.Offer < num2)
			{
				num2 = lose.PlayerCharacter.Offer;
			}
			if (num2 != 0)
			{
				players[win].GainOffer = num2;
				players[lose].GainOffer = -num2;
			}
			return num;
		}

		public static int ConsortiaFight(int consortiaWin, int consortiaLose, Dictionary<int, Player> players, eRoomType roomType, eGameType gameClass, int totalKillHealth, int playercount)
		{
			if (roomType != eRoomType.Match)
			{
				return 0;
			}
			int num = playercount / 2;
			int riches = 0;
			int state = 2;
			int num2 = 1;
			int num3 = 3;
			if (gameClass == eGameType.Guild)
			{
				num3 = 10;
				num2 = (int)RateMgr.GetRate(eRateType.Offer_Rate);
			}
			float rate = RateMgr.GetRate(eRateType.Riches_Rate);
			using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
			{
				if (gameClass == eGameType.Free)
				{
					num = 0;
				}
				else
				{
					consortiaBussiness.ConsortiaFight(consortiaWin, consortiaLose, num, out riches, state, totalKillHealth, rate);
				}
				foreach (KeyValuePair<int, Player> player in players)
				{
					if (player.Value != null)
					{
						if (player.Value.PlayerDetail.PlayerCharacter.ConsortiaID == consortiaWin)
						{
							player.Value.PlayerDetail.AddOffer((num + num3) * num2);
							player.Value.PlayerDetail.PlayerCharacter.RichesRob += riches;
						}
						else if (player.Value.PlayerDetail.PlayerCharacter.ConsortiaID == consortiaLose)
						{
							player.Value.PlayerDetail.AddOffer((int)Math.Round((double)num * 0.5) * num2);
							player.Value.PlayerDetail.RemoveOffer(num3);
						}
					}
				}
			}
			return riches;
		}

		static ConsortiaMgr()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
