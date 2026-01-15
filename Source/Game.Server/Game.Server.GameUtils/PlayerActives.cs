using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Game.Base;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.GypsyShop;
using Game.Server.Managers;
using log4net;
using Newtonsoft.Json;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public class PlayerActives
	{
		private static readonly ILog ilog_0;

		protected object m_lock;

		protected Timer _christmasTimer;

		protected Timer _labyrinthTimer;

		protected Timer _lightriddleTimer;

		protected GamePlayer m_player;

		private PyramidConfigInfo pyramidConfigInfo_0;

		private PyramidInfo pyramidInfo_0;

		private UserChristmasInfo userChristmasInfo_0;

		private ActiveSystemInfo activeSystemInfo_0;

		private NewChickenBoxItemInfo[] newChickenBoxItemInfo_0;

		private List<NewChickenBoxItemInfo> list_0;

		private int int_0;

		private int[] int_1;

		private int[] int_2;

		private int int_3;

		private ThreadSafeRandom threadSafeRandom_0;

		private bool bool_0;

		private readonly int int_4;

		private readonly int int_5;

		private readonly int int_6;

		private readonly int int_7;

		public readonly int coinTemplateID;

		private int int_8;

		private BoguAdventureDataInfo boguAdventureDataInfo_0;

		private BoguCeilInfo[] boguCeilInfo_0;

		private int[] int_9;

		private readonly int int_10;

		private readonly int int_11;

		private readonly int int_12;

		public readonly int findMinePrice;

		public readonly int revivePrice;

		public readonly int resetPrice;

		public readonly int halloweenCard;

		public readonly int MINE;

		public readonly int SPACE;

		public readonly int SIGN;

		public readonly int OPEN;

		public readonly int NOT_OPEN;

		private readonly int int_13;

		private readonly int int_14;

		private TreasurePuzzleDataInfo[] treasurePuzzleDataInfo_0;

		private readonly int int_15;

		private GypsyItemDataInfo[] gypsyItemDataInfo_0;

		public int QXDropId;

		private CryptBossItemInfo[] cryptBossItemInfo_0;

		private readonly string[] string_0;

		private readonly int[] int_16;

		private readonly int[] int_17;

		private readonly int[] int_18;

		private readonly int[] int_19;

		private readonly int[] int_20;

		private readonly int[] int_21;

		private int int_22;

		private int int_23;

		private int int_24;

		private DateTime dateTime_0;

		private DateTime dateTime_1;

		private int int_25;

		private NewChickenBoxItemInfo[] newChickenBoxItemInfo_1;

		private NewChickenBoxItemInfo newChickenBoxItemInfo_2;

		public DateTime LuckyStartStartTurn;

		private int int_26;

		private bool bool_1;

		public GamePlayer Player => m_player;

		public PyramidConfigInfo PyramidConfig
		{
			get
			{
				return pyramidConfigInfo_0;
			}
			set
			{
				pyramidConfigInfo_0 = value;
			}
		}

		public PyramidInfo Pyramid
		{
			get
			{
				return pyramidInfo_0;
			}
			set
			{
				pyramidInfo_0 = value;
			}
		}

		public UserChristmasInfo Christmas
		{
			get
			{
				return userChristmasInfo_0;
			}
			set
			{
				userChristmasInfo_0 = value;
			}
		}

		public ActiveSystemInfo Info
		{
			get
			{
				return activeSystemInfo_0;
			}
			set
			{
				activeSystemInfo_0 = value;
			}
		}

		public NewChickenBoxItemInfo[] ChickenBoxRewards
		{
			get
			{
				return newChickenBoxItemInfo_0;
			}
			set
			{
				newChickenBoxItemInfo_0 = value;
			}
		}

		public int flushPrice
		{
			get
			{
				return int_0;
			}
			set
			{
				int_0 = value;
			}
		}

		public int[] eagleEyePrice
		{
			get
			{
				return int_1;
			}
			set
			{
				int_1 = value;
			}
		}

		public int[] openCardPrice
		{
			get
			{
				return int_2;
			}
			set
			{
				int_2 = value;
			}
		}

		public int freeFlushTime
		{
			get
			{
				return int_3;
			}
			set
			{
				int_3 = value;
			}
		}

		public BoguAdventureDataInfo BoguAdventure
		{
			get
			{
				return boguAdventureDataInfo_0;
			}
			set
			{
				boguAdventureDataInfo_0 = value;
			}
		}

		public BoguCeilInfo[] BoguAdventureCell
		{
			get
			{
				return boguCeilInfo_0;
			}
			set
			{
				boguCeilInfo_0 = value;
			}
		}

		public int[] AwardCount
		{
			get
			{
				return int_9;
			}
			set
			{
				int_9 = value;
			}
		}

		public TreasurePuzzleDataInfo[] Treasurepuzzle
		{
			get
			{
				return treasurePuzzleDataInfo_0;
			}
			set
			{
				treasurePuzzleDataInfo_0 = value;
			}
		}

		public GypsyItemDataInfo[] MysteryShop
		{
			get
			{
				return gypsyItemDataInfo_0;
			}
			set
			{
				gypsyItemDataInfo_0 = value;
			}
		}

		public CryptBossItemInfo[] CryptBoss => cryptBossItemInfo_0;

		public int freeRefreshBoxCount
		{
			get
			{
				return int_22;
			}
			set
			{
				int_22 = value;
			}
		}

		public int freeEyeCount
		{
			get
			{
				return int_23;
			}
			set
			{
				int_23 = value;
			}
		}

		public int freeOpenCardCount
		{
			get
			{
				return int_24;
			}
			set
			{
				int_24 = value;
			}
		}

		public DateTime LuckyBegindate
		{
			get
			{
				return dateTime_0;
			}
			set
			{
				dateTime_0 = value;
			}
		}

		public DateTime LuckyEnddate
		{
			get
			{
				return dateTime_1;
			}
			set
			{
				dateTime_1 = value;
			}
		}

		public int minUseNum
		{
			get
			{
				return int_25;
			}
			set
			{
				int_25 = value;
			}
		}

		public NewChickenBoxItemInfo Award
		{
			get
			{
				return newChickenBoxItemInfo_2;
			}
			set
			{
				newChickenBoxItemInfo_2 = value;
			}
		}

		public bool LightriddleStart => bool_1;

		public PlayerActives(GamePlayer player, bool saveTodb)
		{
			m_lock = new object();
			threadSafeRandom_0 = new ThreadSafeRandom();
			int_4 = 1000;
			int_5 = 15;
			int_6 = 18;
			int_7 = 14;
			coinTemplateID = 201193;
			int_8 = GameProperties.WarriorFamRaidTimeRemain;
			int_10 = GameProperties.NeedBox1GoguAward;
			int_11 = GameProperties.NeedBox2GoguAward;
			int_12 = GameProperties.NeedBox3GoguAward;
			findMinePrice = GameProperties.FindMinePrice;
			revivePrice = GameProperties.RevivePrice;
			resetPrice = GameProperties.ResetPrice;
			halloweenCard = 201453;
			MINE = -1;
			SPACE = -2;
			SIGN = 1;
			OPEN = 2;
			NOT_OPEN = 3;
			int_13 = 10;
			int_14 = 7;
			int_15 = 20;
			string_0 = GameProperties.CryptBossOpenDay.Split('|');
			int_16 = new int[5] { 1120186, 1120187, 1120188, 1120189, 1120190 };
			int_17 = new int[5] { 1120191, 1120192, 1120193, 1120194, 1120195 };
			int_18 = new int[5] { 1120196, 1120197, 1120198, 1120199, 1120200 };
			int_19 = new int[5] { 1120201, 1120202, 1120203, 1120204, 1120205 };
			int_20 = new int[5] { 1120206, 1120207, 1120208, 1120209, 1120210 };
			int_21 = new int[5] { 1120211, 1120212, 1120213, 1120214, 1120215 };
			int_26 = 15;
			m_player = player;
			bool_0 = saveTodb;
			int_1 = GameProperties.ConvertStringArrayToIntArray("NewChickenEagleEyePrice");
			int_2 = GameProperties.ConvertStringArrayToIntArray("NewChickenOpenCardPrice");
			int_0 = GameProperties.NewChickenFlushPrice;
			int_3 = 120;
			list_0 = new List<NewChickenBoxItemInfo>();
			int_23 = 0;
			int_24 = 0;
			int_22 = 0;
			method_5();
			method_11();
		}

		public int IsAcquireAward(int type)
		{
			int result = 1;
			switch (type)
			{
			case 0:
				if (BoguAdventure.openCount >= int_10)
				{
					result = 0;
				}
				if (BoguAdventure.isAcquireAward1 == 1)
				{
					result = 1;
				}
				break;
			case 1:
				if (BoguAdventure.openCount >= int_11)
				{
					result = 0;
				}
				if (BoguAdventure.isAcquireAward2 == 1)
				{
					result = 1;
				}
				break;
			case 2:
				if (BoguAdventure.openCount >= int_11)
				{
					result = 0;
				}
				if (BoguAdventure.isAcquireAward3 == 1)
				{
					result = 1;
				}
				break;
			}
			return result;
		}

		public int CountOpenCanTakeBoxGoguAdventure(int type)
		{
			return type switch
			{
				0 => int_10, 
				1 => int_11, 
				2 => int_12, 
				_ => 0, 
			};
		}

		public virtual bool LoadBoguAdventureFromDatabase()
		{
			if (bool_0)
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				try
				{
					boguAdventureDataInfo_0 = playerBussiness.GetAllBoguAdventureDataByID(Player.PlayerCharacter.ID);
					if (boguAdventureDataInfo_0 == null)
					{
						CreateBoguAdventureDataInfo();
						boguCeilInfo_0 = method_0();
						int_9 = new int[int_13 * int_14];
						UpdateAroundMineCount();
					}
					else
					{
						if (string.IsNullOrEmpty(BoguAdventure.awardCount))
						{
							int_9 = new int[int_13 * int_14];
						}
						else
						{
							int_9 = JsonConvert.DeserializeObject<int[]>(BoguAdventure.awardCount);
						}
						if (string.IsNullOrEmpty(BoguAdventure.cellInfo))
						{
							boguCeilInfo_0 = method_0();
						}
						else
						{
							boguCeilInfo_0 = JsonConvert.DeserializeObject<BoguCeilInfo[]>(BoguAdventure.cellInfo);
						}
					}
				}
				catch
				{
				}
				finally
				{
					if (BoguAdventure.lastEnterGame.Date < DateTime.Now.Date)
					{
						ResetBoguAdventureEveryDay();
					}
					SerializeBoguAdventure();
				}
			}
			return BoguAdventure != null;
		}

		public void SerializeBoguAdventure()
		{
			lock (m_lock)
			{
				if (boguAdventureDataInfo_0 != null)
				{
					if (int_9 != null && int_9.Length >= int_13 * int_14)
					{
						boguAdventureDataInfo_0.awardCount = JsonConvert.SerializeObject(int_9);
					}
					if (BoguAdventureCell != null && BoguAdventureCell.Length >= int_13 * int_14)
					{
						boguAdventureDataInfo_0.cellInfo = JsonConvert.SerializeObject(BoguAdventureCell);
					}
				}
			}
		}

		public virtual bool LoadDDPlayFromDatabase()
		{
			if (bool_0)
			{
				using (new PlayerBussiness())
				{
				}
			}
			return true;
		}

		public virtual bool LoadGypsyItemDataFromDatabase()
		{
			if (bool_0)
			{
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					try
					{
						if (gypsyItemDataInfo_0 == null)
						{
							gypsyItemDataInfo_0 = playerBussiness.GetAllGypsyItemDataByID(Player.PlayerCharacter.ID);
							if (MysteryShop.Length < 8)
							{
								gypsyItemDataInfo_0 = null;
								RefreshMysteryShop();
							}
						}
					}
					catch
					{
						return false;
					}
					return true;
				}
			}
			return true;
		}

		public virtual void SaveBoguAdventureDatabase()
		{
			if (!bool_0)
			{
				return;
			}
			SerializeBoguAdventure();
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			lock (m_lock)
			{
				if (boguAdventureDataInfo_0 != null && boguAdventureDataInfo_0.IsDirty)
				{
					if (BoguAdventure.ID > 0)
					{
						playerBussiness.UpdateBoguAdventureData(BoguAdventure);
					}
					else
					{
						playerBussiness.AddBoguAdventureData(BoguAdventure);
					}
				}
			}
		}

		public void UpdateAroundMineCount()
		{
			lock (m_lock)
			{
				if (boguCeilInfo_0 != null)
				{
					for (int i = 0; i < boguCeilInfo_0.Length; i++)
					{
						boguCeilInfo_0[i].MineCount = GetTotalMineAround(i + 1).Length;
					}
				}
			}
		}

		public void CreateBoguAdventureDataInfo()
		{
			lock (m_lock)
			{
				boguAdventureDataInfo_0 = new BoguAdventureDataInfo();
				boguAdventureDataInfo_0.UserID = Player.PlayerCharacter.ID;
				boguAdventureDataInfo_0.currentIndex = 0;
				boguAdventureDataInfo_0.hp = 2;
				boguAdventureDataInfo_0.isAcquireAward1 = 0;
				boguAdventureDataInfo_0.isAcquireAward2 = 0;
				boguAdventureDataInfo_0.isAcquireAward3 = 0;
				boguAdventureDataInfo_0.openCount = 0;
				boguAdventureDataInfo_0.isFreeReset = true;
				boguAdventureDataInfo_0.resetCount = GameProperties.resetCount;
				boguAdventureDataInfo_0.cellInfo = "";
				boguAdventureDataInfo_0.awardCount = "";
				boguAdventureDataInfo_0.lastEnterGame = DateTime.Now;
			}
			SaveBoguAdventureDatabase();
		}

		public void ResetBoguAdventureEveryDay()
		{
			lock (m_lock)
			{
				if (boguAdventureDataInfo_0 != null)
				{
					boguAdventureDataInfo_0.isAcquireAward1 = 0;
					boguAdventureDataInfo_0.isAcquireAward2 = 0;
					boguAdventureDataInfo_0.isAcquireAward3 = 0;
					boguAdventureDataInfo_0.isFreeReset = true;
					boguAdventureDataInfo_0.resetCount = GameProperties.resetCount;
					boguAdventureDataInfo_0.lastEnterGame = DateTime.Now;
				}
			}
			SaveBoguAdventureDatabase();
		}

		public void ResetAllBoguAdventure()
		{
			lock (m_lock)
			{
				if (boguAdventureDataInfo_0 != null)
				{
					boguAdventureDataInfo_0.currentIndex = 0;
					boguAdventureDataInfo_0.hp = 2;
					boguAdventureDataInfo_0.openCount = 0;
					boguAdventureDataInfo_0.cellInfo = "";
					boguAdventureDataInfo_0.awardCount = "";
				}
			}
			boguCeilInfo_0 = method_0();
			int_9 = new int[int_13 * int_14];
			UpdateAroundMineCount();
			SerializeBoguAdventure();
			SaveBoguAdventureDatabase();
		}

		public void SendBoguAdventureEnter()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(90);
			gSPacketIn.WriteInt(BoguAdventure.currentIndex);
			gSPacketIn.WriteInt(BoguAdventure.hp);
			gSPacketIn.WriteInt(BoguAdventure.isAcquireAward1);
			gSPacketIn.WriteInt(BoguAdventure.isAcquireAward2);
			gSPacketIn.WriteInt(BoguAdventure.isAcquireAward3);
			gSPacketIn.WriteInt(BoguAdventure.openCount);
			gSPacketIn.WriteInt(findMinePrice);
			gSPacketIn.WriteInt(revivePrice);
			gSPacketIn.WriteInt(resetPrice);
			gSPacketIn.WriteBoolean(BoguAdventure.isFreeReset);
			gSPacketIn.WriteInt(BoguAdventure.resetCount);
			gSPacketIn.WriteInt(BoguAdventureCell.Length);
			BoguCeilInfo[] boguAdventureCell = BoguAdventureCell;
			foreach (BoguCeilInfo boguCeilInfo in boguAdventureCell)
			{
				gSPacketIn.WriteInt(boguCeilInfo.Index);
				gSPacketIn.WriteInt(boguCeilInfo.State);
				gSPacketIn.WriteInt(boguCeilInfo.Result);
				gSPacketIn.WriteInt(boguCeilInfo.MineCount);
			}
			int num = 3;
			for (int j = 0; j < num; j++)
			{
				gSPacketIn.WriteInt(CountOpenCanTakeBoxGoguAdventure(j));
				List<BoguAdventureRewardInfo> list = ActiveSystermAwardMgr.FindBoguAdventureReward(num - j);
				gSPacketIn.WriteInt(list.Count);
				foreach (BoguAdventureRewardInfo item in list)
				{
					gSPacketIn.WriteInt(item.TemplateID);
					gSPacketIn.WriteInt(item.Count);
				}
			}
			Player.SendTCP(gSPacketIn);
		}

		public void SendUpdateFreeCount()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(281);
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteInt(Info.updateFreeCounts);
			gSPacketIn.WriteInt(Info.updateWorshipedCounts);
			gSPacketIn.WriteInt(Info.update200State);
			gSPacketIn.WriteInt(int.Parse(GameProperties.WorshipMoonPriceInfo.Split('|')[1]));
			Player.SendTCP(gSPacketIn);
		}

		public void SendHalloweenEnter()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(116);
			gSPacketIn.WriteInt(Player.GetHalloweenCardCount());
			gSPacketIn.WriteInt(ActiveSystemMgr.FindHalloweenRank(Player.PlayerCharacter.ID));
			gSPacketIn.WriteDateTime(DateTime.Now);
			Player.SendTCP(gSPacketIn);
		}

		public bool UpdateAwardCount(int index)
		{
			if (index < 0)
			{
				return false;
			}
			if (index > int_13 * int_14)
			{
				return false;
			}
			lock (m_lock)
			{
				if (int_9 != null && int_9[index - 1] == 0)
				{
					int_9[index - 1] = index;
					return true;
				}
			}
			if (IsAcquireAward(0) == 0)
			{
				SendBoguAdventureEnter();
			}
			if (IsAcquireAward(1) == 0)
			{
				SendBoguAdventureEnter();
			}
			if (IsAcquireAward(2) == 0)
			{
				SendBoguAdventureEnter();
			}
			return false;
		}

		public void UpdateCeilBoguMap(BoguCeilInfo ceil)
		{
			lock (m_lock)
			{
				if (boguCeilInfo_0 != null)
				{
					boguCeilInfo_0[ceil.Index - 1] = ceil;
				}
			}
			SaveBoguAdventureDatabase();
		}

		public BoguCeilInfo[] GetTotalMineAroundNotOpen(int index)
		{
			List<BoguCeilInfo> list = new List<BoguCeilInfo>();
			int[] countAroundIndex = GetCountAroundIndex(index);
			foreach (int index2 in countAroundIndex)
			{
				BoguCeilInfo boguCeilInfo = FindCeilBoguMap(index2);
				if (boguCeilInfo != null && boguCeilInfo.Result == MINE && boguCeilInfo.State == NOT_OPEN)
				{
					list.Add(boguCeilInfo);
				}
			}
			return list.ToArray();
		}

		private BoguCeilInfo[] method_0()
		{
			new BoguCeilInfo();
			BoguCeilInfo[] array = new BoguCeilInfo[int_13 * int_14];
			int[] source = method_1();
			for (int i = 0; i < array.Length; i++)
			{
				array[i] = new BoguCeilInfo
				{
					Index = i + 1,
					State = NOT_OPEN,
					Result = (source.Contains(i + 1) ? MINE : SPACE),
					MineCount = 0
				};
			}
			return array;
		}

		public BoguCeilInfo[] GetTotalMineAround(int index)
		{
			List<BoguCeilInfo> list = new List<BoguCeilInfo>();
			int[] countAroundIndex = GetCountAroundIndex(index);
			foreach (int index2 in countAroundIndex)
			{
				BoguCeilInfo boguCeilInfo = FindCeilBoguMap(index2);
				if (boguCeilInfo != null && boguCeilInfo.Result == MINE)
				{
					list.Add(boguCeilInfo);
				}
			}
			return list.ToArray();
		}

		public BoguCeilInfo FindCeilBoguMap(int index)
		{
			if (boguCeilInfo_0 == null)
			{
				return null;
			}
			BoguCeilInfo[] array = boguCeilInfo_0;
			foreach (BoguCeilInfo boguCeilInfo in array)
			{
				if (boguCeilInfo.Index == index)
				{
					return boguCeilInfo;
				}
			}
			return null;
		}

		public int[] GetCountAroundIndex(int index)
		{
			List<int> list = new List<int>();
			int[] source = new int[7] { 1, 11, 21, 31, 41, 51, 61 };
			int[] source2 = new int[7] { 10, 20, 30, 40, 50, 60, 70 };
			int num = int_13 * int_14;
			if (index > 0 && index <= num)
			{
				int num2 = index - 1;
				if (num2 >= 1 && num2 <= num)
				{
					list.Add(num2);
				}
				int num3 = index - 9;
				if (num3 >= 1 && num3 <= num)
				{
					list.Add(num3);
				}
				int num4 = index - 10;
				if (num4 >= 1 && num4 <= num)
				{
					list.Add(num4);
				}
				int num5 = index - 11;
				if (num5 >= 1 && num5 <= num)
				{
					list.Add(num5);
				}
				int num6 = index + 1;
				if (num6 >= 1 && num6 <= num)
				{
					list.Add(num6);
				}
				int num7 = index + 9;
				if (num7 >= 1 && num7 <= num)
				{
					list.Add(num7);
				}
				int num8 = index + 10;
				if (num8 >= 1 && num8 <= num)
				{
					list.Add(num8);
				}
				int num9 = index + 11;
				if (num9 >= 1 && num9 <= num)
				{
					list.Add(num9);
				}
				if (source.Contains(index))
				{
					list.Remove(num2);
					list.Remove(num7);
					list.Remove(num5);
				}
				if (source2.Contains(index))
				{
					list.Remove(num6);
					list.Remove(num3);
					list.Remove(num9);
				}
			}
			return list.ToArray();
		}

		private int[] method_1()
		{
			List<int> list = new List<int>();
			List<int> list2 = new List<int>();
			for (int i = 1; i <= int_13 * int_14; i++)
			{
				list2.Add(i);
			}
			for (int num = 25; num > 0; num--)
			{
				int index = threadSafeRandom_0.Next(0, list2.Count - 1);
				list.Add(list2[index]);
				list2.RemoveAt(index);
			}
			return list.ToArray();
		}

		public void TreasurepuzzleGetAward(int current)
		{
			lock (m_lock)
			{
				for (int i = 0; i < treasurePuzzleDataInfo_0.Length; i++)
				{
					if (current == i)
					{
						treasurePuzzleDataInfo_0[i].IsGetAward = true;
					}
					treasurePuzzleDataInfo_0[i].Int32_1 = 0;
					treasurePuzzleDataInfo_0[i].Int32_3 = 0;
					treasurePuzzleDataInfo_0[i].Int32_5 = 0;
					treasurePuzzleDataInfo_0[i].Int32_7 = 0;
					treasurePuzzleDataInfo_0[i].Int32_9 = 0;
					treasurePuzzleDataInfo_0[i].Int32_11 = 0;
				}
			}
		}

		public int AddHole(int hole, int count)
		{
			int num = 0;
			lock (m_lock)
			{
				for (int i = 0; i < count; i++)
				{
					switch (hole)
					{
					case 1:
						if (treasurePuzzleDataInfo_0[0].Int32_1 < treasurePuzzleDataInfo_0[0].Int32_0)
						{
							treasurePuzzleDataInfo_0[0].Int32_1++;
							num++;
						}
						else if (treasurePuzzleDataInfo_0[1].Int32_1 < treasurePuzzleDataInfo_0[1].Int32_0)
						{
							treasurePuzzleDataInfo_0[1].Int32_1++;
							num++;
						}
						else if (treasurePuzzleDataInfo_0[2].Int32_1 < treasurePuzzleDataInfo_0[2].Int32_0)
						{
							treasurePuzzleDataInfo_0[2].Int32_1++;
							num++;
						}
						break;
					case 2:
						if (treasurePuzzleDataInfo_0[0].Int32_3 < treasurePuzzleDataInfo_0[0].Int32_2)
						{
							treasurePuzzleDataInfo_0[0].Int32_3++;
							num++;
						}
						else if (treasurePuzzleDataInfo_0[1].Int32_3 < treasurePuzzleDataInfo_0[1].Int32_2)
						{
							treasurePuzzleDataInfo_0[1].Int32_3++;
							num++;
						}
						else if (treasurePuzzleDataInfo_0[2].Int32_3 < treasurePuzzleDataInfo_0[2].Int32_2)
						{
							treasurePuzzleDataInfo_0[2].Int32_3++;
							num++;
						}
						break;
					case 3:
						if (treasurePuzzleDataInfo_0[0].Int32_5 < treasurePuzzleDataInfo_0[0].Int32_4)
						{
							treasurePuzzleDataInfo_0[0].Int32_5++;
							num++;
						}
						else if (treasurePuzzleDataInfo_0[1].Int32_5 < treasurePuzzleDataInfo_0[1].Int32_4)
						{
							treasurePuzzleDataInfo_0[1].Int32_5++;
							num++;
						}
						else if (treasurePuzzleDataInfo_0[2].Int32_5 < treasurePuzzleDataInfo_0[2].Int32_4)
						{
							treasurePuzzleDataInfo_0[2].Int32_5++;
							num++;
						}
						break;
					case 4:
						if (treasurePuzzleDataInfo_0[0].Int32_7 < treasurePuzzleDataInfo_0[0].Int32_6)
						{
							treasurePuzzleDataInfo_0[0].Int32_7++;
							num++;
						}
						else if (treasurePuzzleDataInfo_0[1].Int32_7 < treasurePuzzleDataInfo_0[1].Int32_6)
						{
							treasurePuzzleDataInfo_0[1].Int32_7++;
							num++;
						}
						else if (treasurePuzzleDataInfo_0[2].Int32_7 < treasurePuzzleDataInfo_0[2].Int32_6)
						{
							treasurePuzzleDataInfo_0[2].Int32_7++;
							num++;
						}
						break;
					case 5:
						if (treasurePuzzleDataInfo_0[0].Int32_9 < treasurePuzzleDataInfo_0[0].Int32_8)
						{
							treasurePuzzleDataInfo_0[0].Int32_9++;
							num++;
						}
						else if (treasurePuzzleDataInfo_0[1].Int32_9 < treasurePuzzleDataInfo_0[1].Int32_8)
						{
							treasurePuzzleDataInfo_0[1].Int32_9++;
							num++;
						}
						else if (treasurePuzzleDataInfo_0[2].Int32_9 < treasurePuzzleDataInfo_0[2].Int32_8)
						{
							treasurePuzzleDataInfo_0[2].Int32_9++;
							num++;
						}
						break;
					case 6:
						if (treasurePuzzleDataInfo_0[0].Int32_11 < treasurePuzzleDataInfo_0[0].Int32_10)
						{
							treasurePuzzleDataInfo_0[0].Int32_11++;
							num++;
						}
						else if (treasurePuzzleDataInfo_0[1].Int32_11 < treasurePuzzleDataInfo_0[1].Int32_10)
						{
							treasurePuzzleDataInfo_0[1].Int32_11++;
							num++;
						}
						else if (treasurePuzzleDataInfo_0[2].Int32_11 < treasurePuzzleDataInfo_0[2].Int32_10)
						{
							treasurePuzzleDataInfo_0[2].Int32_11++;
							num++;
						}
						break;
					}
				}
			}
			return num++;
		}

		public void CreateTreasurepuzzleDataInfo()
		{
			lock (m_lock)
			{
				treasurePuzzleDataInfo_0 = new TreasurePuzzleDataInfo[3];
				for (int i = 1; i <= treasurePuzzleDataInfo_0.Length; i++)
				{
					int num = int_15 * i;
					TreasurePuzzleDataInfo treasurePuzzleDataInfo = new TreasurePuzzleDataInfo();
					treasurePuzzleDataInfo.UserID = Player.PlayerCharacter.ID;
					treasurePuzzleDataInfo.PuzzleID = i;
					treasurePuzzleDataInfo.Int32_0 = num;
					treasurePuzzleDataInfo.Int32_1 = 0;
					treasurePuzzleDataInfo.Int32_2 = num;
					treasurePuzzleDataInfo.Int32_3 = 0;
					treasurePuzzleDataInfo.Int32_4 = num;
					treasurePuzzleDataInfo.Int32_5 = 0;
					treasurePuzzleDataInfo.Int32_6 = num;
					treasurePuzzleDataInfo.Int32_7 = 0;
					treasurePuzzleDataInfo.Int32_8 = num;
					treasurePuzzleDataInfo.Int32_9 = 0;
					treasurePuzzleDataInfo.Int32_10 = num;
					treasurePuzzleDataInfo.Int32_11 = 0;
					treasurePuzzleDataInfo_0[i - 1] = treasurePuzzleDataInfo;
				}
			}
			SaveTreasurepuzzleDatabase();
		}

		public virtual bool LoadTreasurePuzzleFromDatabase()
		{
			if (bool_0)
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				try
				{
					TreasurePuzzleDataInfo[] allTreasurePuzzleDataByID = playerBussiness.GetAllTreasurePuzzleDataByID(Player.PlayerCharacter.ID);
					if (allTreasurePuzzleDataByID.Length != 0)
					{
						lock (m_lock)
						{
							treasurePuzzleDataInfo_0 = allTreasurePuzzleDataByID;
							for (int i = 1; i <= treasurePuzzleDataInfo_0.Length; i++)
							{
								int num = int_15 * i;
								treasurePuzzleDataInfo_0[i - 1].Int32_0 = num;
								treasurePuzzleDataInfo_0[i - 1].Int32_2 = num;
								treasurePuzzleDataInfo_0[i - 1].Int32_4 = num;
								treasurePuzzleDataInfo_0[i - 1].Int32_6 = num;
								treasurePuzzleDataInfo_0[i - 1].Int32_8 = num;
								treasurePuzzleDataInfo_0[i - 1].Int32_10 = num;
							}
						}
					}
					else
					{
						CreateTreasurepuzzleDataInfo();
					}
				}
				catch
				{
				}
			}
			return Treasurepuzzle != null && Treasurepuzzle.Length >= 3;
		}

		public virtual void SaveTreasurepuzzleDatabase()
		{
			if (!bool_0)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			lock (m_lock)
			{
				for (int i = 0; i < Treasurepuzzle.Length; i++)
				{
					if (treasurePuzzleDataInfo_0[i] != null && treasurePuzzleDataInfo_0[i].IsDirty)
					{
						if (treasurePuzzleDataInfo_0[i].ID > 0)
						{
							playerBussiness.UpdateTreasurePuzzleData(treasurePuzzleDataInfo_0[i]);
						}
						else
						{
							playerBussiness.AddTreasurePuzzleData(treasurePuzzleDataInfo_0[i]);
						}
					}
				}
			}
		}

		public virtual void LoadFromDatabase()
		{
			if (!bool_0)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			try
			{
				if (IsChristmasOpen())
				{
					userChristmasInfo_0 = playerBussiness.GetSingleUserChristmas(Player.PlayerCharacter.ID);
					if (userChristmasInfo_0 == null)
					{
						CreateChristmasInfo(Player.PlayerCharacter.ID);
					}
				}
				activeSystemInfo_0 = playerBussiness.GetSingleActiveSystem(Player.PlayerCharacter.ID);
				if (activeSystemInfo_0 == null)
				{
					CreateActiveSystemInfo();
					return;
				}
				activeSystemInfo_0.NickName = Player.PlayerCharacter.NickName;
				activeSystemInfo_0.ZoneName = Player.ZoneName;
				activeSystemInfo_0.ZoneID = Player.ZoneId;
			}
			finally
			{
				method_2();
			}
		}

		public virtual void SaveActiveToDatabase()
		{
			if (!bool_0)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			lock (m_lock)
			{
				if (activeSystemInfo_0 != null && activeSystemInfo_0.IsDirty)
				{
					if (activeSystemInfo_0.ID > 0)
					{
						playerBussiness.UpdateActiveSystem(activeSystemInfo_0);
					}
					else
					{
						playerBussiness.AddActiveSystem(activeSystemInfo_0);
					}
				}
			}
		}

		public virtual void SaveToDatabase()
		{
			if (bool_0)
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				lock (m_lock)
				{
					if (cryptBossItemInfo_0 != null)
					{
						activeSystemInfo_0.CryptBoss = JsonConvert.SerializeObject(cryptBossItemInfo_0);
					}
					if (activeSystemInfo_0 != null && activeSystemInfo_0.IsDirty)
					{
						if (activeSystemInfo_0.ID > 0)
						{
							playerBussiness.UpdateActiveSystem(activeSystemInfo_0);
						}
						else
						{
							playerBussiness.AddActiveSystem(activeSystemInfo_0);
						}
					}
					if (pyramidInfo_0 != null && pyramidInfo_0.IsDirty)
					{
						if (pyramidInfo_0.ID > 0)
						{
							playerBussiness.UpdatePyramid(pyramidInfo_0);
						}
						else
						{
							playerBussiness.AddPyramid(pyramidInfo_0);
						}
					}
					if (userChristmasInfo_0 != null && userChristmasInfo_0.IsDirty)
					{
						if (userChristmasInfo_0.ID > 0)
						{
							playerBussiness.UpdateUserChristmas(userChristmasInfo_0);
						}
						else
						{
							playerBussiness.AddUserChristmas(userChristmasInfo_0);
						}
					}
					if (newChickenBoxItemInfo_0 != null)
					{
						NewChickenBoxItemInfo[] array = newChickenBoxItemInfo_0;
						foreach (NewChickenBoxItemInfo newChickenBoxItemInfo in array)
						{
							if (newChickenBoxItemInfo != null && newChickenBoxItemInfo.IsDirty)
							{
								if (newChickenBoxItemInfo.ID > 0)
								{
									playerBussiness.UpdateNewChickenBox(newChickenBoxItemInfo);
								}
								else
								{
									playerBussiness.AddNewChickenBox(newChickenBoxItemInfo);
								}
							}
						}
					}
					if (gypsyItemDataInfo_0 != null)
					{
						GypsyItemDataInfo[] array2 = gypsyItemDataInfo_0;
						foreach (GypsyItemDataInfo gypsyItemDataInfo in array2)
						{
							if (gypsyItemDataInfo != null && gypsyItemDataInfo.IsDirty)
							{
								if (gypsyItemDataInfo.ID > 0)
								{
									playerBussiness.UpdateGypsyItemData(gypsyItemDataInfo);
								}
								else
								{
									playerBussiness.AddGypsyItemData(gypsyItemDataInfo);
								}
							}
						}
					}
				}
				if (list_0.Count > 0)
				{
					foreach (NewChickenBoxItemInfo item in list_0)
					{
						playerBussiness.UpdateNewChickenBox(item);
					}
				}
			}
			LanternriddlesInfo lanternriddles = ActiveSystemMgr.GetLanternriddles(m_player.PlayerCharacter.ID);
			GameServer.Instance.LoginServer.SendLightriddleInfo(lanternriddles);
		}

		public GypsyItemDataInfo GetMysteryShopByID(int ID)
		{
			GypsyItemDataInfo[] mysteryShop = MysteryShop;
			foreach (GypsyItemDataInfo gypsyItemDataInfo in mysteryShop)
			{
				if (gypsyItemDataInfo.GypsyID == ID)
				{
					return gypsyItemDataInfo;
				}
			}
			return null;
		}

		public bool UpdateMysteryShopByID(int ID)
		{
			lock (m_lock)
			{
				for (int i = 0; i < MysteryShop.Length; i++)
				{
					if (gypsyItemDataInfo_0[i].GypsyID == ID)
					{
						gypsyItemDataInfo_0[i].CanBuy = 0;
					}
				}
			}
			return true;
		}

		public void RefreshMysteryShopByHour()
		{
			DateTime now = DateTime.Now;
			if (GameProperties.MysteryShopFreshTime == now.Hour && Info.LastRefresh.Date < now.Date)
			{
				Info.LastRefresh = now;
				RefreshMysteryShop();
			}
		}

		public void RefreshMysteryShop()
		{
			List<MysteryShopInfo> mysteryShop = GypsyShopMgr.GetMysteryShop();
			bool flag = false;
			lock (m_lock)
			{
				if (gypsyItemDataInfo_0 == null)
				{
					gypsyItemDataInfo_0 = new GypsyItemDataInfo[8];
					flag = true;
				}
				int num = 0;
				foreach (MysteryShopInfo item in mysteryShop)
				{
					if (num < MysteryShop.Length)
					{
						if (flag)
						{
							GypsyItemDataInfo gypsyItemDataInfo = new GypsyItemDataInfo();
							gypsyItemDataInfo.UserID = m_player.PlayerId;
							gypsyItemDataInfo.GypsyID = item.ID;
							gypsyItemDataInfo.InfoID = item.InfoID;
							gypsyItemDataInfo.Unit = item.Unit;
							gypsyItemDataInfo.Num = item.Num;
							gypsyItemDataInfo.Price = item.Price;
							gypsyItemDataInfo.CanBuy = item.CanBuy;
							gypsyItemDataInfo_0[num] = gypsyItemDataInfo;
						}
						else
						{
							gypsyItemDataInfo_0[num].GypsyID = item.ID;
							gypsyItemDataInfo_0[num].InfoID = item.InfoID;
							gypsyItemDataInfo_0[num].Unit = item.Unit;
							gypsyItemDataInfo_0[num].Num = item.Num;
							gypsyItemDataInfo_0[num].Price = item.Price;
							gypsyItemDataInfo_0[num].CanBuy = item.CanBuy;
						}
					}
					num++;
				}
			}
		}

		public void ResetMysteryShop()
		{
			lock (m_lock)
			{
				activeSystemInfo_0.CurRefreshedTimes = 0;
			}
		}

		public GSPacketIn SendGypsyShopPlayerInfo()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(278, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteInt(Info.CurRefreshedTimes);
			gSPacketIn.WriteInt(MysteryShop.Length);
			GypsyItemDataInfo[] mysteryShop = MysteryShop;
			foreach (GypsyItemDataInfo gypsyItemDataInfo in mysteryShop)
			{
				gSPacketIn.WriteInt(gypsyItemDataInfo.GypsyID);
				gSPacketIn.WriteInt(gypsyItemDataInfo.Unit);
				gSPacketIn.WriteInt(gypsyItemDataInfo.Price);
				gSPacketIn.WriteInt(gypsyItemDataInfo.Num);
				gSPacketIn.WriteInt(gypsyItemDataInfo.InfoID);
				gSPacketIn.WriteInt(gypsyItemDataInfo.CanBuy);
			}
			Player.Out.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public void SendEvent()
		{
			if (IsChickenBoxOpen())
			{
				m_player.Out.SendChickenBoxOpen(m_player.PlayerId, flushPrice, openCardPrice, eagleEyePrice);
			}
			if (IsLuckStarActivityOpen())
			{
				m_player.Out.SendLuckStarOpen(m_player.PlayerId);
			}
			SendCryptBossInitAllData();
			SendTreasurePuzzleOpenClose();
			SendBoguAdventureOpenClose();
			SendHalloweenOpenClose();
			SendCloudBuyLotteryOpenClose();
			SendDDPlayOpenClose();
			SendMagpieBridgeOpenClose();
			SendCatchInsectOpenClose();
			if (GypsyShopMgr.OpenOrClose)
			{
				SendGypsyShopOpenClose(open: true);
				RefreshMysteryShopByHour();
			}
			SendHorseRaceOpenClose();
		}

		public GSPacketIn SendHorseRaceOpenClose()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, m_player.PlayerId);
			gSPacketIn.WriteByte(160);
			gSPacketIn.WriteBoolean(IsHorseRaceOpen());
			m_player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendGypsyShopOpenClose(bool open)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(278, m_player.PlayerId);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteBoolean(open);
			m_player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendCatchInsectOpenClose()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, m_player.PlayerId);
			gSPacketIn.WriteByte(128);
			gSPacketIn.WriteBoolean(IsSummerOpen());
			m_player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendMagpieBridgeOpenClose()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(276, m_player.PlayerId);
			gSPacketIn.WriteByte(11);
			gSPacketIn.WriteBoolean(IsMagpieBridgeOpen());
			m_player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendDDPlayOpenClose()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, m_player.PlayerId);
			gSPacketIn.WriteByte(74);
			gSPacketIn.WriteBoolean(val: true);
			gSPacketIn.WriteDateTime(DateTime.Parse(GameProperties.DDPlayBeginDate));
			gSPacketIn.WriteDateTime(DateTime.Parse(GameProperties.DDPlayEndDate));
			gSPacketIn.WriteInt(GameProperties.int_0);
			gSPacketIn.WriteInt(GameProperties.ExchangeFold);
			m_player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendCloudBuyLotteryOpenClose()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, m_player.PlayerId);
			gSPacketIn.WriteByte(117);
			gSPacketIn.WriteBoolean(val: true);
			m_player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendHalloweenOpenClose()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, m_player.PlayerId);
			gSPacketIn.WriteByte(115);
			gSPacketIn.WriteBoolean(IsHalloweenOpen());
			m_player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendBoguAdventureOpenClose()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, m_player.PlayerId);
			gSPacketIn.WriteByte(89);
			gSPacketIn.WriteBoolean(val: true);
			m_player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendTreasurePuzzleOpenClose()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, m_player.PlayerId);
			gSPacketIn.WriteByte(102);
			gSPacketIn.WriteBoolean(val: true);
			m_player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendCryptBossInitAllData()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(275, m_player.PlayerId);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(CryptBoss.Length);
			CryptBossItemInfo[] cryptBoss = CryptBoss;
			foreach (CryptBossItemInfo cryptBossItemInfo in cryptBoss)
			{
				gSPacketIn.WriteInt(cryptBossItemInfo.id);
				gSPacketIn.WriteInt(cryptBossItemInfo.star);
				gSPacketIn.WriteInt(cryptBossItemInfo.state);
			}
			m_player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendLuckStarClose()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(87, m_player.PlayerId);
			gSPacketIn.WriteInt(26);
			m_player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendCloudBuyLotteryUpdateInfos(CloudBuyLotteryInfo info, bool isGame)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, m_player.PlayerId);
			gSPacketIn.WriteByte(122);
			gSPacketIn.WriteInt(info.templateId);
			gSPacketIn.WriteInt(info.templatedIdCount);
			gSPacketIn.WriteInt(info.validDate);
			gSPacketIn.WriteString(info.property);
			gSPacketIn.WriteInt(info.maxNum);
			gSPacketIn.WriteInt(info.currentNum);
			gSPacketIn.WriteDateTime(DateTime.Parse(GameProperties.CloudBuyLotteryEndDate));
			gSPacketIn.WriteInt(activeSystemInfo_0.luckCount);
			gSPacketIn.WriteInt(activeSystemInfo_0.remainTimes);
			gSPacketIn.WriteBoolean(isGame);
			m_player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendCloudBuyLotteryEnter(CloudBuyLotteryInfo info, bool isGame)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(118);
			gSPacketIn.WriteInt(info.templateId);
			gSPacketIn.WriteInt(info.templatedIdCount);
			gSPacketIn.WriteInt(info.validDate);
			gSPacketIn.WriteString(info.property);
			string[] array = info.buyItemsArr.Split(',');
			gSPacketIn.WriteInt(array.Length);
			for (int i = 0; i < array.Length; i++)
			{
				string[] array2 = array[i].Split('|');
				gSPacketIn.WriteInt(int.Parse(array2[0]));
				gSPacketIn.WriteInt(int.Parse(array2[1]));
			}
			gSPacketIn.WriteInt(info.buyMoney);
			gSPacketIn.WriteInt(info.maxNum);
			gSPacketIn.WriteInt(info.currentNum);
			gSPacketIn.WriteDateTime(DateTime.Parse(GameProperties.CloudBuyLotteryEndDate));
			gSPacketIn.WriteInt(activeSystemInfo_0.luckCount);
			gSPacketIn.WriteInt(activeSystemInfo_0.remainTimes);
			gSPacketIn.WriteBoolean(isGame);
			m_player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public void ResetLuckCount()
		{
			lock (activeSystemInfo_0)
			{
				activeSystemInfo_0.luckCount = 0;
			}
		}

		public CryptBossItemInfo GetCryptBossData(int id)
		{
			lock (m_lock)
			{
				for (int i = 0; i < cryptBossItemInfo_0.Length; i++)
				{
					if (cryptBossItemInfo_0[i].id == id)
					{
						return cryptBossItemInfo_0[i];
					}
				}
			}
			return null;
		}

		private void method_2()
		{
			List<CryptBossItemInfo> list = new List<CryptBossItemInfo>();
			if (string.IsNullOrEmpty(activeSystemInfo_0.CryptBoss))
			{
				for (int i = 0; i < string_0.Length; i++)
				{
					string[] array = string_0[i].Split(',');
					list.Add(new CryptBossItemInfo
					{
						id = int.Parse(array[0]),
						star = 0,
						state = method_4(array)
					});
				}
			}
			else
			{
				list = JsonConvert.DeserializeObject<List<CryptBossItemInfo>>(activeSystemInfo_0.CryptBoss);
			}
			lock (m_lock)
			{
				cryptBossItemInfo_0 = list.ToArray();
			}
		}

		public void ResetCryptBossData()
		{
			if (cryptBossItemInfo_0 == null)
			{
				return;
			}
			lock (m_lock)
			{
				for (int i = 0; i < CryptBoss.Length; i++)
				{
					if (CryptBoss[i] != null)
					{
						int id = cryptBossItemInfo_0[i].id;
						string[] string_ = method_3(id);
						cryptBossItemInfo_0[i].state = method_4(string_);
					}
				}
			}
		}

		private string[] method_3(int int_27)
		{
			string[] array = string_0;
			foreach (string text in array)
			{
				string[] array2 = text.Split(',');
				if (int_27.ToString() == array2[0])
				{
					return array2;
				}
			}
			return null;
		}

		private int method_4(string[] string_1)
		{
			if (string_1 == null)
			{
				return 2;
			}
			for (int i = 1; i < string_1.Length; i++)
			{
				string s = string_1[i];
				if (DateTime.Now.DayOfWeek == (DayOfWeek)int.Parse(s))
				{
					return 1;
				}
			}
			return 2;
		}

		public void UpdateStar(int id)
		{
			lock (m_lock)
			{
				for (int i = 0; i < cryptBossItemInfo_0.Length; i++)
				{
					CryptBossItemInfo cryptBossItemInfo = cryptBossItemInfo_0[i];
					if (cryptBossItemInfo.id == id)
					{
						if (cryptBossItemInfo.star < 5)
						{
							cryptBossItemInfo.star++;
						}
						cryptBossItemInfo.state = 2;
						SendUpdateSingleData(cryptBossItemInfo);
						cryptBossItemInfo_0[i] = cryptBossItemInfo;
						SendCryptBossAward(id, cryptBossItemInfo.star);
					}
				}
			}
		}

		public GSPacketIn SendUpdateSingleData(CryptBossItemInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(275, m_player.PlayerId);
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteInt(info.id);
			gSPacketIn.WriteInt(info.star);
			gSPacketIn.WriteInt(info.state);
			m_player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public void SendCryptBossAward(int id, int star)
		{
			int templateId = 0;
			switch (id)
			{
			case 1:
				if (star > 0 && star <= int_16.Length)
				{
					templateId = int_16[star - 1];
				}
				break;
			case 2:
				if (star > 0 && star <= int_17.Length)
				{
					templateId = int_17[star - 1];
				}
				break;
			case 3:
				if (star > 0 && star <= int_18.Length)
				{
					templateId = int_18[star - 1];
				}
				break;
			case 4:
				if (star > 0 && star <= int_19.Length)
				{
					templateId = int_19[star - 1];
				}
				break;
			case 5:
				if (star > 0 && star <= int_20.Length)
				{
					templateId = int_20[star - 1];
				}
				break;
			case 6:
				if (star > 0 && star <= int_21.Length)
				{
					templateId = int_21[star - 1];
				}
				break;
			}
			ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(templateId);
			if (ıtemTemplateInfo != null)
			{
				List<ItemInfo> list = new List<ItemInfo>();
				ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 102);
				ıtemInfo.Count = 1;
				ıtemInfo.ValidDate = 0;
				ıtemInfo.IsBinds = true;
				list.Add(ıtemInfo);
				string translation = LanguageMgr.GetTranslation("GamePlayer.Msg23", id, star);
				WorldEventMgr.SendItemsToMail(list, Player.PlayerCharacter.ID, Player.PlayerCharacter.NickName, translation);
				QXDropId = 0;
			}
		}

		private void method_5()
		{
			lock (m_lock)
			{
				pyramidConfigInfo_0 = new PyramidConfigInfo();
				pyramidConfigInfo_0.isOpen = IsPyramidOpen();
				pyramidConfigInfo_0.isScoreExchange = !IsPyramidOpen();
				pyramidConfigInfo_0.beginTime = Convert.ToDateTime(GameProperties.PyramidBeginTime);
				pyramidConfigInfo_0.endTime = Convert.ToDateTime(GameProperties.PyramidEndTime);
				pyramidConfigInfo_0.freeCount = 3;
				pyramidConfigInfo_0.revivePrice = GameProperties.ConvertStringArrayToIntArray("PyramidRevivePrice");
				pyramidConfigInfo_0.turnCardPrice = GameProperties.PyramydTurnCardPrice;
			}
		}

		public bool IsHalloweenOpen()
		{
			DateTime dateTime = Convert.ToDateTime(GameProperties.HalloweenEndDate);
			return DateTime.Now.Date < dateTime.Date;
		}

		public bool IsChristmasOpen()
		{
			DateTime dateTime = Convert.ToDateTime(GameProperties.ChristmasEndDate);
			return DateTime.Now.Date < dateTime.Date;
		}

		public bool IsChickenBoxOpen()
		{
			DateTime dateTime = Convert.ToDateTime(GameProperties.NewChickenEndTime);
			return DateTime.Now.Date < dateTime.Date;
		}

		public bool IsLuckStarActivityOpen()
		{
			DateTime dateTime = Convert.ToDateTime(GameProperties.LuckStarActivityEndDate);
			return DateTime.Now.Date < dateTime.Date;
		}

		public bool IsPyramidOpen()
		{
			DateTime dateTime = Convert.ToDateTime(GameProperties.PyramidEndTime);
			return DateTime.Now.Date < dateTime.Date;
		}

		public bool IsYearMonsterOpen()
		{
			DateTime dateTime = Convert.ToDateTime(GameProperties.YearMonsterEndDate);
			return DateTime.Now.Date < dateTime.Date;
		}

		public bool IsWorshipTheMoonOpen()
		{
			DateTime dateTime = Convert.ToDateTime(GameProperties.WorshipMoonEndDate);
			return DateTime.Now.Date < dateTime.Date;
		}

		public bool IsMagpieBridgeOpen()
		{
			DateTime dateTime = Convert.ToDateTime(GameProperties.TanabataActiveEndTime);
			return DateTime.Now.Date < dateTime.Date;
		}

		public bool IsSummerOpen()
		{
			DateTime dateTime = Convert.ToDateTime(GameProperties.SummerAcitveEndTime);
			return DateTime.Now.Date < dateTime.Date;
		}

		public bool IsHorseRaceOpen()
		{
			DateTime dateTime = Convert.ToDateTime(GameProperties.HorseGameEndTime);
			return DateTime.Now.Date < dateTime.Date;
		}

		public NewChickenBoxItemInfo GetAward(int pos)
		{
			NewChickenBoxItemInfo[] array = newChickenBoxItemInfo_0;
			foreach (NewChickenBoxItemInfo newChickenBoxItemInfo in array)
			{
				if (newChickenBoxItemInfo.Position == pos && !newChickenBoxItemInfo.IsSelected)
				{
					return newChickenBoxItemInfo;
				}
			}
			return null;
		}

		public NewChickenBoxItemInfo ViewAward(int pos)
		{
			NewChickenBoxItemInfo[] array = newChickenBoxItemInfo_0;
			foreach (NewChickenBoxItemInfo newChickenBoxItemInfo in array)
			{
				if (newChickenBoxItemInfo.Position == pos && !newChickenBoxItemInfo.IsSeeded)
				{
					return newChickenBoxItemInfo;
				}
			}
			return null;
		}

		public bool UpdateChickenBoxAward(NewChickenBoxItemInfo box)
		{
			for (int i = 0; i < newChickenBoxItemInfo_0.Length; i++)
			{
				if (newChickenBoxItemInfo_0[i].Position == box.Position)
				{
					newChickenBoxItemInfo_0[i] = box;
					return true;
				}
			}
			return false;
		}

		public void LoadChickenBox()
		{
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			newChickenBoxItemInfo_0 = playerBussiness.GetSingleNewChickenBox(Player.PlayerCharacter.ID);
			if (newChickenBoxItemInfo_0.Length == 0)
			{
				PayFlushView();
			}
		}

		public void EnterChickenBox()
		{
			if (newChickenBoxItemInfo_0 == null)
			{
				LoadChickenBox();
			}
		}

		public void RandomPosition()
		{
			List<int> list = new List<int>();
			for (int i = 0; i < newChickenBoxItemInfo_0.Length; i++)
			{
				list.Add(newChickenBoxItemInfo_0[i].Position);
			}
			threadSafeRandom_0.Shuffer(newChickenBoxItemInfo_0);
			for (int j = 0; j < list.Count; j++)
			{
				newChickenBoxItemInfo_0[j].Position = list[j];
			}
		}

		public NewChickenBoxItemInfo[] CreateChickenBoxAward(int count, eEventType DataId)
		{
			List<NewChickenBoxItemInfo> list = new List<NewChickenBoxItemInfo>();
			Dictionary<int, NewChickenBoxItemInfo> dictionary = new Dictionary<int, NewChickenBoxItemInfo>();
			int num = 0;
			int num2 = 0;
			while (list.Count < count)
			{
				List<NewChickenBoxItemInfo> newChickenBoxAward = EventAwardMgr.GetNewChickenBoxAward(DataId);
				if (newChickenBoxAward.Count > 0)
				{
					NewChickenBoxItemInfo newChickenBoxItemInfo = newChickenBoxAward[0];
					if (!dictionary.Keys.Contains(newChickenBoxItemInfo.TemplateID))
					{
						dictionary.Add(newChickenBoxItemInfo.TemplateID, newChickenBoxItemInfo);
						newChickenBoxItemInfo.Position = num;
						list.Add(newChickenBoxItemInfo);
						num++;
					}
				}
				num2++;
			}
			return list.ToArray();
		}

		public void PayFlushView()
		{
			activeSystemInfo_0.lastFlushTime = DateTime.Now;
			activeSystemInfo_0.isShowAll = true;
			activeSystemInfo_0.canOpenCounts = 5;
			activeSystemInfo_0.canEagleEyeCounts = 5;
			RemoveChickenBoxRewards();
			newChickenBoxItemInfo_0 = CreateChickenBoxAward(int_6, eEventType.CHICKEN_BOX);
			for (int i = 0; i < newChickenBoxItemInfo_0.Length; i++)
			{
				newChickenBoxItemInfo_0[i].UserID = Player.PlayerCharacter.ID;
			}
		}

		public void RemoveChickenBoxRewards()
		{
			for (int i = 0; i < newChickenBoxItemInfo_0.Length; i++)
			{
				NewChickenBoxItemInfo newChickenBoxItemInfo = newChickenBoxItemInfo_0[i];
				if (newChickenBoxItemInfo != null && newChickenBoxItemInfo.ID > 0)
				{
					newChickenBoxItemInfo.Position = -1;
					list_0.Add(newChickenBoxItemInfo);
				}
			}
		}

		public bool IsFreeFlushTime()
		{
			DateTime lastFlushTime = Info.lastFlushTime;
			DateTime dateTime = lastFlushTime.AddMinutes(freeFlushTime);
			TimeSpan timeSpan = DateTime.Now - Info.lastFlushTime;
			double num = (dateTime - lastFlushTime).TotalMinutes - timeSpan.TotalMinutes;
			return num > 0.0;
		}

		public bool LoadPyramid()
		{
			if (pyramidInfo_0 == null)
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				pyramidInfo_0 = playerBussiness.GetSinglePyramid(Player.PlayerCharacter.ID);
				if (pyramidInfo_0 == null)
				{
					CreatePyramidInfo();
				}
			}
			return true;
		}

		public void CreatePyramidInfo()
		{
			lock (m_lock)
			{
				pyramidInfo_0 = new PyramidInfo();
				pyramidInfo_0.ID = 0;
				pyramidInfo_0.UserID = Player.PlayerCharacter.ID;
				pyramidInfo_0.currentLayer = 1;
				pyramidInfo_0.maxLayer = 1;
				pyramidInfo_0.totalPoint = 0;
				pyramidInfo_0.turnPoint = 0;
				pyramidInfo_0.pointRatio = 0;
				pyramidInfo_0.currentFreeCount = 0;
				pyramidInfo_0.currentReviveCount = 0;
				pyramidInfo_0.isPyramidStart = false;
				pyramidInfo_0.LayerItems = "";
			}
		}

		public void ResetChristmas()
		{
			lock (m_lock)
			{
				if (userChristmasInfo_0 != null)
				{
					userChristmasInfo_0.dayPacks = 0;
					userChristmasInfo_0.AvailTime = 0;
					userChristmasInfo_0.isEnter = false;
				}
			}
		}

		public void ResetTanabata()
		{
			lock (m_lock)
			{
				activeSystemInfo_0.activityTanabataNum = 0;
			}
		}

		public void ResetDragonBoatDayScore()
		{
			lock (m_lock)
			{
				activeSystemInfo_0.dayScore = 0;
			}
		}

		public void ResetActive()
		{
			ResetChristmas();
			ResetCryptBossData();
			if (activeSystemInfo_0 != null)
			{
				ResetDragonBoatDayScore();
				ResetTanabata();
				ResetMysteryShop();
			}
		}

		public void method_6()
		{
			if (QXDropId <= 0)
			{
				return;
			}
			int templateId = 0;
			switch (QXDropId)
			{
			case 70001:
				templateId = 112308;
				break;
			case 70002:
				templateId = 112309;
				break;
			case 70003:
				templateId = 112310;
				break;
			case 70006:
				templateId = 112311;
				break;
			case 70007:
				templateId = 112312;
				break;
			case 70008:
				templateId = 112313;
				break;
			case 70009:
				templateId = 112314;
				break;
			case 70010:
				templateId = 112365;
				break;
			case 70011:
				templateId = 112366;
				break;
			}
			ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(templateId);
			if (ıtemTemplateInfo != null)
			{
				List<ItemInfo> list = new List<ItemInfo>();
				ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 102);
				ıtemInfo.Count = 1;
				ıtemInfo.ValidDate = 0;
				ıtemInfo.IsBinds = true;
				list.Add(ıtemInfo);
				int num = QXDropId - 70000;
				if (QXDropId >= 70006)
				{
					num -= 2;
				}
				string translation = LanguageMgr.GetTranslation("GamePlayer.Msg22", num);
				WorldEventMgr.SendItemsToMail(list, Player.PlayerCharacter.ID, Player.PlayerCharacter.NickName, translation);
				QXDropId = 0;
			}
		}

		public void RemoveGetDragonBoatAward()
		{
			lock (m_lock)
			{
				activeSystemInfo_0.CanGetGift = false;
			}
		}

		public void BeginChristmasTimer()
		{
			int num = 60000;
			if (_christmasTimer == null)
			{
				_christmasTimer = new Timer(ChristmasTimeCheck, null, num, num);
			}
			else
			{
				_christmasTimer.Change(num, num);
			}
		}

		protected void ChristmasTimeCheck(object sender)
		{
			try
			{
				int tickCount = Environment.TickCount;
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				UpdateChristmasTime();
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
			}
			catch (Exception ex)
			{
				Console.WriteLine("ChristmasTimeCheck: " + ex);
			}
		}

		public void StopChristmasTimer()
		{
			if (_christmasTimer != null)
			{
				_christmasTimer.Dispose();
				_christmasTimer = null;
			}
		}

		public void UpdateChristmasTime()
		{
			DateTime gameBeginTime = Christmas.gameBeginTime;
			DateTime gameEndTime = Christmas.gameEndTime;
			TimeSpan timeSpan = DateTime.Now - gameBeginTime;
			double num = (gameEndTime - gameBeginTime).TotalMinutes - timeSpan.TotalMinutes;
			lock (userChristmasInfo_0)
			{
				userChristmasInfo_0.AvailTime = (((int)num >= 0) ? ((int)num) : 0);
			}
		}

		public void AddTime(int min)
		{
			lock (userChristmasInfo_0)
			{
				userChristmasInfo_0.AvailTime += min;
			}
		}

		private void method_7()
		{
			int num = 1000;
			if (_labyrinthTimer == null)
			{
				_labyrinthTimer = new Timer(LabyrinthCheck, null, num, num);
			}
			else
			{
				_labyrinthTimer.Change(num, num);
			}
		}

		protected void LabyrinthCheck(object sender)
		{
			try
			{
				int tickCount = Environment.TickCount;
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				UpdateLabyrinthTime();
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
			}
			catch (Exception ex)
			{
				Console.WriteLine("LabyrinthCheck: " + ex);
			}
		}

		public void StopLabyrinthTimer()
		{
			if (_labyrinthTimer != null)
			{
				_labyrinthTimer.Change(-1, -1);
				_labyrinthTimer.Dispose();
				_labyrinthTimer = null;
			}
		}

		public void UpdateLabyrinthTime()
		{
			UserLabyrinthInfo labyrinth = Player.Labyrinth;
			labyrinth.isCleanOut = true;
			labyrinth.isInGame = true;
			if (labyrinth.remainTime > 0 && labyrinth.currentRemainTime > 0)
			{
				labyrinth.remainTime--;
				labyrinth.currentRemainTime--;
				int_8--;
			}
			if (int_8 == 0)
			{
				method_8();
				int_8 = 120;
				labyrinth.currentFloor++;
				if (labyrinth.currentFloor > labyrinth.myProgress)
				{
					labyrinth.currentFloor = labyrinth.myProgress;
					labyrinth.isCleanOut = false;
					labyrinth.isInGame = false;
					labyrinth.completeChallenge = false;
					labyrinth.remainTime = 0;
					labyrinth.currentRemainTime = 0;
					labyrinth.cleanOutAllTime = 0;
					StopLabyrinthTimer();
				}
			}
			Player.Out.SendLabyrinthUpdataInfo(Player.PlayerId, labyrinth);
		}

		public void CleantOutLabyrinth()
		{
			method_7();
		}

		private void method_8()
		{
			int currentFloor = m_player.Labyrinth.currentFloor;
			currentFloor--;
			int[] array = m_player.CreateExps();
			int num = array[currentFloor];
			string text = m_player.labyrinthGolds[currentFloor];
			int num2 = int.Parse(text.Split('|')[0]);
			int num3 = int.Parse(text.Split('|')[1]);
			ItemInfo ıtemByTemplateID = m_player.PropBag.GetItemByTemplateID(0, 11916);
			if (ıtemByTemplateID == null || !m_player.RemoveTemplate(11916, 1))
			{
				m_player.Labyrinth.isDoubleAward = false;
			}
			if (m_player.Labyrinth.isDoubleAward)
			{
				num *= 2;
				num2 *= 2;
				num3 *= 2;
			}
			m_player.Labyrinth.accumulateExp += num;
			List<ItemInfo> list = new List<ItemInfo>();
			if (method_9())
			{
				list = m_player.CopyDrop(2, 40002);
				m_player.AddTemplate(list, num2);
				m_player.AddHardCurrency(num3);
			}
			m_player.AddGP(num);
			method_10(m_player.Labyrinth.currentFloor, num, num3, list);
		}

		private bool method_9()
		{
			bool result = false;
			for (int i = 0; i <= m_player.Labyrinth.myProgress; i += 2)
			{
				if (i == m_player.Labyrinth.currentFloor)
				{
					return true;
				}
			}
			return result;
		}

		private void method_10(int int_27, int int_28, int int_29, List<ItemInfo> lists)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(131, m_player.PlayerId);
			gSPacketIn.WriteByte(7);
			gSPacketIn.WriteInt(int_27);
			gSPacketIn.WriteInt(int_28);
			gSPacketIn.WriteInt(lists.Count);
			foreach (ItemInfo list in lists)
			{
				gSPacketIn.WriteInt(list.TemplateID);
				gSPacketIn.WriteInt(list.Count);
			}
			gSPacketIn.WriteInt(int_29);
			m_player.SendTCP(gSPacketIn);
		}

		public void StopCleantOutLabyrinth()
		{
			UserLabyrinthInfo labyrinth = Player.Labyrinth;
			labyrinth.isCleanOut = false;
			Player.Out.SendLabyrinthUpdataInfo(Player.PlayerId, labyrinth);
			StopLabyrinthTimer();
		}

		public void SpeededUpCleantOutLabyrinth()
		{
			UserLabyrinthInfo labyrinth = Player.Labyrinth;
			labyrinth.isCleanOut = false;
			labyrinth.isInGame = false;
			labyrinth.completeChallenge = false;
			labyrinth.remainTime = 0;
			labyrinth.currentRemainTime = 0;
			labyrinth.cleanOutAllTime = 0;
			for (int i = labyrinth.currentFloor; i <= labyrinth.myProgress; i++)
			{
				method_8();
				labyrinth.currentFloor++;
			}
			labyrinth.currentFloor = labyrinth.myProgress;
			Player.Out.SendLabyrinthUpdataInfo(Player.PlayerId, labyrinth);
			StopLabyrinthTimer();
		}

		public bool AvailTime()
		{
			DateTime gameBeginTime = Christmas.gameBeginTime;
			DateTime gameEndTime = Christmas.gameEndTime;
			TimeSpan timeSpan = DateTime.Now - gameBeginTime;
			double num = (gameEndTime - gameBeginTime).TotalMinutes - timeSpan.TotalMinutes;
			return num > 0.0;
		}

		public void CreateActiveSystemInfo()
		{
			lock (m_lock)
			{
				activeSystemInfo_0 = new ActiveSystemInfo();
				activeSystemInfo_0.ID = 0;
				activeSystemInfo_0.UserID = Player.PlayerCharacter.ID;
				activeSystemInfo_0.useableScore = 0;
				activeSystemInfo_0.totalScore = 0;
				activeSystemInfo_0.AvailTime = 0;
				activeSystemInfo_0.NickName = Player.PlayerCharacter.NickName;
				activeSystemInfo_0.ZoneName = Player.ZoneName;
				activeSystemInfo_0.dayScore = 0;
				activeSystemInfo_0.CanGetGift = true;
				activeSystemInfo_0.canOpenCounts = 5;
				activeSystemInfo_0.canEagleEyeCounts = 5;
				activeSystemInfo_0.lastFlushTime = DateTime.Now;
				activeSystemInfo_0.isShowAll = true;
				activeSystemInfo_0.ActiveMoney = 0;
				activeSystemInfo_0.activityTanabataNum = 0;
				activeSystemInfo_0.LuckystarCoins = int_4;
				activeSystemInfo_0.Int32_0 = 0;
				activeSystemInfo_0.updateFreeCounts = int.Parse(GameProperties.WorshipMoonPriceInfo.Split('|')[0]);
				activeSystemInfo_0.updateWorshipedCounts = 0;
				activeSystemInfo_0.update200State = 0;
				activeSystemInfo_0.lastEnterWorshiped = DateTime.Now;
				activeSystemInfo_0.luckCount = 0;
				activeSystemInfo_0.remainTimes = 0;
				activeSystemInfo_0.ChallengeNum = GameProperties.YearMonsterFightNum;
				activeSystemInfo_0.BuyBuffNum = GameProperties.YearMonsterFightNum;
				activeSystemInfo_0.lastEnterYearMonter = DateTime.Now;
				activeSystemInfo_0.DamageNum = 0;
				activeSystemInfo_0.LastRefresh = DateTime.Now;
				activeSystemInfo_0.CurRefreshedTimes = 0;
				activeSystemInfo_0.ChickActiveData = "0";
				CreateYearMonterBoxState();
			}
		}

		public string DefaultChickActiveData()
		{
			return string.Concat("0,0,", DateTime.Now, ",", DateTime.Now.ToShortDateString(), ",", DateTime.Now.ToShortDateString(), ",", DateTime.Now.ToShortDateString(), ",0");
		}

		public UserChickActiveInfo GetChickActiveData()
		{
			UserChickActiveInfo userChickActiveInfo = null;
			if (activeSystemInfo_0.ChickActiveData == "0")
			{
				activeSystemInfo_0.ChickActiveData = DefaultChickActiveData();
			}
			string[] array = activeSystemInfo_0.ChickActiveData.Split(',');
			if (array.Length > 0)
			{
				userChickActiveInfo = new UserChickActiveInfo();
				userChickActiveInfo.IsKeyOpened = int.Parse(array[0]);
				userChickActiveInfo.KeyOpenedType = int.Parse(array[1]);
				userChickActiveInfo.KeyOpenedTime = DateTime.Parse(array[2]);
				userChickActiveInfo.EveryDay = DateTime.Parse(array[3]);
				userChickActiveInfo.Weekly = DateTime.Parse(array[4]);
				userChickActiveInfo.AfterThreeDays = DateTime.Parse(array[5]);
				userChickActiveInfo.CurrentLvAward = int.Parse(array[6]);
			}
			return userChickActiveInfo;
		}

		public bool SaveChickActiveData(UserChickActiveInfo data)
		{
			if (data != null)
			{
				string[] value = new string[7]
				{
					data.IsKeyOpened.ToString(),
					data.KeyOpenedType.ToString(),
					data.KeyOpenedTime.ToString(),
					data.EveryDay.ToShortDateString(),
					data.Weekly.ToShortDateString(),
					data.AfterThreeDays.ToShortDateString(),
					data.CurrentLvAward.ToString()
				};
				activeSystemInfo_0.ChickActiveData = string.Join(",", value);
				return true;
			}
			return false;
		}

		public void SendUpdateChickActivation()
		{
			UserChickActiveInfo chickActiveData = GetChickActiveData();
			if (chickActiveData != null)
			{
				GSPacketIn gSPacketIn = new GSPacketIn(84);
				gSPacketIn.WriteInt(2);
				gSPacketIn.WriteInt(2);
				gSPacketIn.WriteInt(chickActiveData.IsKeyOpened);
				gSPacketIn.WriteInt(1);
				gSPacketIn.WriteDateTime(chickActiveData.KeyOpenedTime);
				gSPacketIn.WriteInt(chickActiveData.KeyOpenedType);
				PacketIn packetIn = gSPacketIn;
				int val = ((chickActiveData.EveryDay.Day >= DateTime.Now.Day || DateTime.Now.DayOfWeek != DayOfWeek.Monday) ? 1 : 0);
				packetIn.WriteInt(val);
				PacketIn packetIn2 = gSPacketIn;
				int val2 = ((chickActiveData.EveryDay.Day >= DateTime.Now.Day || DateTime.Now.DayOfWeek != DayOfWeek.Tuesday) ? 1 : 0);
				packetIn2.WriteInt(val2);
				PacketIn packetIn3 = gSPacketIn;
				int val3 = ((chickActiveData.EveryDay.Day >= DateTime.Now.Day || DateTime.Now.DayOfWeek != DayOfWeek.Wednesday) ? 1 : 0);
				packetIn3.WriteInt(val3);
				PacketIn packetIn4 = gSPacketIn;
				int val4 = ((chickActiveData.EveryDay.Day >= DateTime.Now.Day || DateTime.Now.DayOfWeek != DayOfWeek.Thursday) ? 1 : 0);
				packetIn4.WriteInt(val4);
				PacketIn packetIn5 = gSPacketIn;
				int val5 = ((chickActiveData.EveryDay.Day >= DateTime.Now.Day || DateTime.Now.DayOfWeek != DayOfWeek.Friday) ? 1 : 0);
				packetIn5.WriteInt(val5);
				PacketIn packetIn6 = gSPacketIn;
				int val6 = ((chickActiveData.EveryDay.Day >= DateTime.Now.Day || DateTime.Now.DayOfWeek != DayOfWeek.Saturday) ? 1 : 0);
				packetIn6.WriteInt(val6);
				gSPacketIn.WriteInt((chickActiveData.EveryDay.Day >= DateTime.Now.Day || DateTime.Now.DayOfWeek != DayOfWeek.Sunday) ? 1 : 0);
				gSPacketIn.WriteInt((chickActiveData.AfterThreeDays.Day >= DateTime.Now.Day || !chickActiveData.OnThreeDay(DateTime.Now)) ? 1 : 0);
				gSPacketIn.WriteInt((chickActiveData.AfterThreeDays.Day >= DateTime.Now.Day || !chickActiveData.OnThreeDay(DateTime.Now)) ? 1 : 0);
				gSPacketIn.WriteInt((chickActiveData.AfterThreeDays.Day >= DateTime.Now.Day || !chickActiveData.OnThreeDay(DateTime.Now)) ? 1 : 0);
				PacketIn packetIn7 = gSPacketIn;
				int val7 = ((!(chickActiveData.Weekly < chickActiveData.StartOfWeek(DateTime.Now, DayOfWeek.Saturday)) || DateTime.Now.DayOfWeek != DayOfWeek.Saturday) ? 1 : 0);
				packetIn7.WriteInt(val7);
				gSPacketIn.WriteInt(chickActiveData.CurrentLvAward);
				m_player.SendTCP(gSPacketIn);
			}
		}

		public bool YearMonterValidate()
		{
			if (Info.lastEnterYearMonter.Date < DateTime.Now.Date)
			{
				lock (m_lock)
				{
					activeSystemInfo_0.ChallengeNum = GameProperties.YearMonsterFightNum;
					activeSystemInfo_0.BuyBuffNum = GameProperties.YearMonsterFightNum;
					activeSystemInfo_0.lastEnterYearMonter = DateTime.Now;
					activeSystemInfo_0.DamageNum = 0;
					CreateYearMonterBoxState();
				}
			}
			return true;
		}

		public void CreateYearMonterBoxState()
		{
			string[] array = GameProperties.YearMonsterBoxInfo.Split('|');
			int num = array.Length;
			string[] array2 = new string[num];
			for (int i = 0; i < num; i++)
			{
				int num2 = int.Parse(array[i].Split(',')[1]) * 10000;
				if (num2 <= activeSystemInfo_0.DamageNum)
				{
					array2[i] = "2";
				}
				else
				{
					array2[i] = "1";
				}
			}
			activeSystemInfo_0.BoxState = string.Join("-", array2);
		}

		public void SetYearMonterBoxState(int id)
		{
			string[] array = activeSystemInfo_0.BoxState.Split('-');
			int num = array.Length;
			string[] array2 = new string[num];
			for (int i = 0; i < num; i++)
			{
				if (i == id)
				{
					array2[i] = "3";
				}
				else
				{
					array2[i] = array[i];
				}
			}
			activeSystemInfo_0.BoxState = string.Join("-", array2);
		}

		public void CreateChristmasInfo(int UserID)
		{
			lock (m_lock)
			{
				userChristmasInfo_0 = new UserChristmasInfo();
				userChristmasInfo_0.ID = 0;
				userChristmasInfo_0.UserID = UserID;
				userChristmasInfo_0.count = 0;
				userChristmasInfo_0.exp = 0;
				userChristmasInfo_0.awardState = 0;
				userChristmasInfo_0.lastPacks = 1100;
				userChristmasInfo_0.packsNumber = -1;
				userChristmasInfo_0.gameBeginTime = DateTime.Now;
				userChristmasInfo_0.gameEndTime = DateTime.Now.AddMinutes(60.0);
				userChristmasInfo_0.isEnter = false;
				userChristmasInfo_0.dayPacks = 0;
				userChristmasInfo_0.AvailTime = 0;
			}
		}

		public void SendChickenBoxItemList()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(87);
			gSPacketIn.WriteInt(3);
			gSPacketIn.WriteDateTime(Info.lastFlushTime);
			gSPacketIn.WriteInt(freeFlushTime);
			gSPacketIn.WriteInt(freeRefreshBoxCount);
			gSPacketIn.WriteInt(freeEyeCount);
			gSPacketIn.WriteInt(freeOpenCardCount);
			gSPacketIn.WriteBoolean(Info.isShowAll);
			gSPacketIn.WriteInt(ChickenBoxRewards.Length);
			NewChickenBoxItemInfo[] chickenBoxRewards = ChickenBoxRewards;
			foreach (NewChickenBoxItemInfo newChickenBoxItemInfo in chickenBoxRewards)
			{
				gSPacketIn.WriteInt(newChickenBoxItemInfo.TemplateID);
				gSPacketIn.WriteInt(newChickenBoxItemInfo.StrengthenLevel);
				gSPacketIn.WriteInt(newChickenBoxItemInfo.Count);
				gSPacketIn.WriteInt(newChickenBoxItemInfo.ValidDate);
				gSPacketIn.WriteInt(newChickenBoxItemInfo.AttackCompose);
				gSPacketIn.WriteInt(newChickenBoxItemInfo.DefendCompose);
				gSPacketIn.WriteInt(newChickenBoxItemInfo.AgilityCompose);
				gSPacketIn.WriteInt(newChickenBoxItemInfo.LuckCompose);
				gSPacketIn.WriteInt(newChickenBoxItemInfo.Position);
				gSPacketIn.WriteBoolean(newChickenBoxItemInfo.IsSelected);
				gSPacketIn.WriteBoolean(newChickenBoxItemInfo.IsSeeded);
				gSPacketIn.WriteBoolean(newChickenBoxItemInfo.IsBinds);
			}
			m_player.SendTCP(gSPacketIn);
		}

		private void method_11()
		{
			dateTime_0 = DateTime.Parse(GameProperties.LuckStarActivityBeginDate);
			dateTime_1 = DateTime.Parse(GameProperties.LuckStarActivityEndDate);
			int_25 = GameProperties.MinUseNum;
			LuckyStartStartTurn = DateTime.Now;
		}

		public void CreateLuckyStartAward()
		{
			newChickenBoxItemInfo_1 = CreateChickenBoxAward(int_7, eEventType.LUCKY_STAR);
			NewChickenBoxItemInfo newChickenBoxItemInfo = new NewChickenBoxItemInfo();
			newChickenBoxItemInfo.TemplateID = coinTemplateID;
			newChickenBoxItemInfo.StrengthenLevel = 0;
			newChickenBoxItemInfo.Count = 1;
			newChickenBoxItemInfo.IsBinds = true;
			newChickenBoxItemInfo.Quality = 1;
			newChickenBoxItemInfo_1[0] = newChickenBoxItemInfo;
			threadSafeRandom_0.Shuffer(newChickenBoxItemInfo_1);
		}

		public void ChangeLuckyStartAwardPlace()
		{
			threadSafeRandom_0.Shuffer(newChickenBoxItemInfo_1);
		}

		public void SendLuckStarAllGoodsInfo()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(87, m_player.PlayerId);
			gSPacketIn.WriteInt(21);
			gSPacketIn.WriteInt(activeSystemInfo_0.LuckystarCoins);
			gSPacketIn.WriteDateTime(LuckyBegindate);
			gSPacketIn.WriteDateTime(LuckyEnddate);
			gSPacketIn.WriteInt(minUseNum);
			int num = newChickenBoxItemInfo_1.Length;
			int i = 0;
			gSPacketIn.WriteInt(num);
			for (; i < num; i++)
			{
				gSPacketIn.WriteInt(newChickenBoxItemInfo_1[i].TemplateID);
				gSPacketIn.WriteInt(newChickenBoxItemInfo_1[i].StrengthenLevel);
				gSPacketIn.WriteInt(newChickenBoxItemInfo_1[i].Count);
				gSPacketIn.WriteInt(newChickenBoxItemInfo_1[i].ValidDate);
				gSPacketIn.WriteInt(newChickenBoxItemInfo_1[i].AttackCompose);
				gSPacketIn.WriteInt(newChickenBoxItemInfo_1[i].DefendCompose);
				gSPacketIn.WriteInt(newChickenBoxItemInfo_1[i].AgilityCompose);
				gSPacketIn.WriteInt(newChickenBoxItemInfo_1[i].LuckCompose);
				gSPacketIn.WriteBoolean(newChickenBoxItemInfo_1[i].IsBinds);
				gSPacketIn.WriteInt(newChickenBoxItemInfo_1[i].Quality);
			}
			m_player.SendTCP(gSPacketIn);
		}

		public void SendLuckStarRewardRecord()
		{
			List<LuckStarRewardRecordInfo> recordList = ActiveSystemMgr.RecordList;
			GSPacketIn gSPacketIn = new GSPacketIn(87, m_player.PlayerId);
			gSPacketIn.WriteInt(22);
			gSPacketIn.WriteInt(recordList.Count);
			foreach (LuckStarRewardRecordInfo item in recordList)
			{
				gSPacketIn.WriteInt(item.TemplateID);
				gSPacketIn.WriteInt(item.Count);
				gSPacketIn.WriteString(item.nickName);
			}
			m_player.SendTCP(gSPacketIn);
		}

		public void SendUpdateReward()
		{
			if (Award.TemplateID != coinTemplateID)
			{
				GSPacketIn gSPacketIn = new GSPacketIn(87, m_player.PlayerId);
				gSPacketIn.WriteInt(24);
				gSPacketIn.WriteInt(Award.TemplateID);
				gSPacketIn.WriteInt(Award.Count);
				gSPacketIn.WriteString(m_player.PlayerCharacter.NickName);
				m_player.SendTCP(gSPacketIn);
			}
		}

		private void method_12()
		{
			int num = threadSafeRandom_0.Next(newChickenBoxItemInfo_1.Length - 1);
			NewChickenBoxItemInfo newChickenBoxItemInfo = newChickenBoxItemInfo_1[num];
			if (newChickenBoxItemInfo.TemplateID == coinTemplateID && threadSafeRandom_0.Next(100) > 3)
			{
				List<NewChickenBoxItemInfo> list = new List<NewChickenBoxItemInfo>();
				NewChickenBoxItemInfo[] array = newChickenBoxItemInfo_1;
				foreach (NewChickenBoxItemInfo newChickenBoxItemInfo2 in array)
				{
					if (newChickenBoxItemInfo2.TemplateID != coinTemplateID)
					{
						list.Add(newChickenBoxItemInfo2);
					}
				}
				num = threadSafeRandom_0.Next(list.Count - 1);
				newChickenBoxItemInfo = list[num];
			}
			lock (m_lock)
			{
				newChickenBoxItemInfo_2 = newChickenBoxItemInfo;
			}
		}

		public void SendLuckStarTurnGoodsInfo()
		{
			method_12();
			activeSystemInfo_0.LuckystarCoins += int_5;
			GSPacketIn gSPacketIn = new GSPacketIn(87, m_player.PlayerId);
			gSPacketIn.WriteInt(23);
			gSPacketIn.WriteInt(activeSystemInfo_0.LuckystarCoins);
			gSPacketIn.WriteInt(Award.TemplateID);
			gSPacketIn.WriteInt(Award.StrengthenLevel);
			gSPacketIn.WriteInt(Award.Count);
			gSPacketIn.WriteInt(Award.ValidDate);
			gSPacketIn.WriteInt(Award.AttackCompose);
			gSPacketIn.WriteInt(Award.DefendCompose);
			gSPacketIn.WriteInt(Award.AgilityCompose);
			gSPacketIn.WriteInt(Award.LuckCompose);
			gSPacketIn.WriteBoolean(Award.IsBinds);
			m_player.SendTCP(gSPacketIn);
			if (Award.TemplateID == coinTemplateID)
			{
				if (GameProperties.IsActiveMoney)
				{
					m_player.AddActiveMoney(activeSystemInfo_0.LuckystarCoins);
				}
				else
				{
					m_player.AddMoney(activeSystemInfo_0.LuckystarCoins);
				}
				activeSystemInfo_0.LuckystarCoins = int_4;
			}
			ActiveSystemMgr.UpdateLuckStarRewardRecord(m_player.PlayerCharacter.ID, m_player.PlayerCharacter.NickName, Award.TemplateID, Award.Count, m_player.PlayerCharacter.typeVIP);
		}

		public void SendLuckStarRewardRank()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(87, m_player.PlayerId);
			gSPacketIn.WriteInt(27);
			List<LuckyStartToptenAwardInfo> luckyStartToptenAward = WorldEventMgr.GetLuckyStartToptenAward();
			gSPacketIn.WriteInt(luckyStartToptenAward.Count);
			foreach (LuckyStartToptenAwardInfo item in luckyStartToptenAward)
			{
				gSPacketIn.WriteInt(item.TemplateID);
				gSPacketIn.WriteInt(item.StrengthenLevel);
				gSPacketIn.WriteInt(item.Count);
				gSPacketIn.WriteInt(item.Validate);
				gSPacketIn.WriteInt(item.AttackCompose);
				gSPacketIn.WriteInt(item.DefendCompose);
				gSPacketIn.WriteInt(item.AgilityCompose);
				gSPacketIn.WriteInt(item.LuckCompose);
				gSPacketIn.WriteBoolean(item.IsBinds);
				gSPacketIn.WriteInt(item.Type);
			}
			m_player.SendTCP(gSPacketIn);
		}

		public GSPacketIn SendLightriddleRank(int myRank, List<RankingLightriddleInfo> list)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, m_player.PlayerId);
			gSPacketIn.WriteByte(42);
			gSPacketIn.WriteInt(myRank);
			gSPacketIn.WriteInt(list.Count);
			foreach (RankingLightriddleInfo item in list)
			{
				gSPacketIn.WriteInt(item.Rank);
				gSPacketIn.WriteString(item.NickName);
				gSPacketIn.WriteByte((byte)item.TypeVIP);
				gSPacketIn.WriteInt(item.Integer);
				List<LuckyStartToptenAwardInfo> lanternriddlesAwardByRank = WorldEventMgr.GetLanternriddlesAwardByRank(item.Rank);
				gSPacketIn.WriteInt(lanternriddlesAwardByRank.Count);
				foreach (LuckyStartToptenAwardInfo item2 in lanternriddlesAwardByRank)
				{
					gSPacketIn.WriteInt(item2.TemplateID);
					gSPacketIn.WriteInt(item2.Count);
					gSPacketIn.WriteBoolean(item2.IsBinds);
					gSPacketIn.WriteInt(item2.Validate);
				}
			}
			m_player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendLightriddleQuestion(LanternriddlesInfo Lanternriddles)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, m_player.PlayerId);
			gSPacketIn.WriteByte(38);
			gSPacketIn.WriteInt(Lanternriddles.QuestionIndex);
			gSPacketIn.WriteInt(Lanternriddles.GetQuestionID);
			gSPacketIn.WriteInt(Lanternriddles.QuestionView);
			gSPacketIn.WriteDateTime(Lanternriddles.EndDate);
			gSPacketIn.WriteInt(Lanternriddles.DoubleFreeCount);
			gSPacketIn.WriteInt(Lanternriddles.DoublePrice);
			gSPacketIn.WriteInt(Lanternriddles.HitFreeCount);
			gSPacketIn.WriteInt(Lanternriddles.HitPrice);
			gSPacketIn.WriteInt(Lanternriddles.MyInteger);
			gSPacketIn.WriteInt(Lanternriddles.QuestionNum);
			gSPacketIn.WriteInt(Lanternriddles.Option);
			gSPacketIn.WriteBoolean(Lanternriddles.IsHint);
			gSPacketIn.WriteBoolean(Lanternriddles.IsDouble);
			m_player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendLightriddleAnswerResult(bool Iscorrect, int option, string award)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, m_player.PlayerId);
			gSPacketIn.WriteByte(39);
			gSPacketIn.WriteBoolean(Iscorrect);
			gSPacketIn.WriteBoolean(Iscorrect);
			gSPacketIn.WriteInt(option);
			gSPacketIn.WriteString(award);
			m_player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public void BeginLightriddleTimer()
		{
			int num = 1000;
			if (_lightriddleTimer == null)
			{
				_lightriddleTimer = new Timer(LightriddleCheck, null, num, num);
			}
			else
			{
				_lightriddleTimer.Change(num, num);
			}
		}

		protected void LightriddleCheck(object sender)
		{
			try
			{
				if (bool_1)
				{
					bool_1 = true;
				}
				int tickCount = Environment.TickCount;
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				if (int_26 > 0)
				{
					int_26--;
					if (int_26 == 1)
					{
						LanternriddlesInfo lanternriddles = ActiveSystemMgr.GetLanternriddles(m_player.PlayerId);
						if (lanternriddles == null)
						{
							StopLightriddleTimer();
							return;
						}
						LightriddleQuestInfo getCurrentQuestion = lanternriddles.GetCurrentQuestion;
						string translation = LanguageMgr.GetTranslation("Lightriddle.Msg1");
						string translation2 = LanguageMgr.GetTranslation("Lightriddle.Msg2");
						string award = LanguageMgr.GetTranslation("Lightriddle.Msg3");
						int gp = 1000;
						ItemTemplateInfo goods = ItemMgr.FindItemTemplate(100100);
						ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(goods, 1, 105);
						bool ıscorrect = false;
						if (getCurrentQuestion != null)
						{
							if (lanternriddles.IsHint)
							{
								lanternriddles.Option = getCurrentQuestion.OptionTrue;
							}
							if (lanternriddles.Option == getCurrentQuestion.OptionTrue)
							{
								ıtemInfo.Count = 5;
								gp = 10000;
								lanternriddles.MyInteger += 29;
								lanternriddles.QuestionNum++;
								if (lanternriddles.IsDouble)
								{
									translation = LanguageMgr.GetTranslation("Lightriddle.Msg4");
									lanternriddles.MyInteger += 29;
								}
								award = translation;
								ıscorrect = true;
							}
							else
							{
								ıtemInfo.Count = 1;
								award = translation2;
							}
						}
						if (lanternriddles.Option > 0)
						{
							m_player.AddGP(gp);
							ıtemInfo.IsBinds = true;
							m_player.AddTemplate(ıtemInfo);
							SendLightriddleAnswerResult(ıscorrect, lanternriddles.Option, award);
							GameServer.Instance.LoginServer.SendLightriddleUpateRank(lanternriddles.MyInteger, m_player.PlayerCharacter);
						}
						GameServer.Instance.LoginServer.SendLightriddleInfo(lanternriddles);
					}
				}
				else
				{
					LanternriddlesInfo lanternriddles2 = ActiveSystemMgr.GetLanternriddles(m_player.PlayerId);
					if (lanternriddles2 == null)
					{
						StopLightriddleTimer();
						return;
					}
					if (lanternriddles2.CanNextQuest)
					{
						lanternriddles2.QuestionIndex++;
						lanternriddles2.Option = -1;
						lanternriddles2.IsHint = false;
						lanternriddles2.IsDouble = false;
						lanternriddles2.EndDate = ActiveSystemMgr.EndDate;
						SendLightriddleQuestion(lanternriddles2);
						int_26 = 15;
						GameServer.Instance.LoginServer.SendLightriddleRank(m_player.PlayerCharacter.NickName, m_player.PlayerCharacter.ID);
					}
					else
					{
						lanternriddles2.QuestionIndex = lanternriddles2.QuestionView;
						lanternriddles2.IsHint = true;
						lanternriddles2.IsDouble = true;
						lanternriddles2.EndDate = DateTime.Now;
						SendLightriddleQuestion(lanternriddles2);
						StopLightriddleTimer();
					}
					GameServer.Instance.LoginServer.SendLightriddleInfo(lanternriddles2);
				}
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
			}
			catch (Exception ex)
			{
				Console.WriteLine("LabyrinthCheck: " + ex);
			}
		}

		public void StopLightriddleTimer()
		{
			if (_lightriddleTimer != null)
			{
				int_26 = 15;
				bool_1 = false;
				_lightriddleTimer.Dispose();
				_lightriddleTimer = null;
			}
		}

		static PlayerActives()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
