using System;
using System.Collections.Generic;
using System.Reflection;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Buffer;
using Game.Server.GameObjects;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public class PlayerExtra
	{
		public class FlopCardInfo
		{
			public int TemplateID { get; set; }

			public int Count { get; set; }
		}

		public const int STRENGTH_ENCHANCE = 1;

		public const int PET_REFRESH = 2;

		public const int BEAD_MASTER = 3;

		public const int HELP_STRAW = 4;

		public const int DUNGEON_HERO = 5;

		public const int TASK_SPIRIT = 6;

		public const int TIME_DEITY = 7;

		public const int PET_GRANT = 10;

		public const int PET_STAR = 11;

		public const int HORSE_LIGHT = 12;

		public const int HORSE_ANGER = 13;

		private static ThreadSafeRandom threadSafeRandom_0;

		private static readonly ILog ilog_0;

		protected object m_lock;

		protected GamePlayer m_player;

		private bool bool_0;

		private int[] int_0;

		private int[] int_1;

		private UsersExtraInfo usersExtraInfo_0;

		private Dictionary<int, int> dictionary_0;

		private List<EventAwardInfo> list_0;

		private List<FlopCardInfo> list_1;

		private QuestInfo[] questInfo_0;

		private Dictionary<int, int> dictionary_1;

		private List<EventAwardInfo> list_2;

		private int[] int_2;

		public int MapId;

		public int takeCardLimit;

		private string[] string_0;

		private string[] string_1;

		public GamePlayer Player => m_player;

		public UsersExtraInfo Info
		{
			get
			{
				return usersExtraInfo_0;
			}
			set
			{
				usersExtraInfo_0 = value;
			}
		}

		public Dictionary<int, int> KingBlessInfo
		{
			get
			{
				return dictionary_0;
			}
			set
			{
				dictionary_0 = value;
			}
		}

		public List<EventAwardInfo> SearchGoodItems
		{
			get
			{
				return list_0;
			}
			set
			{
				list_0 = value;
			}
		}

		public Dictionary<int, int> DeedInfo
		{
			get
			{
				return dictionary_1;
			}
			set
			{
				dictionary_1 = value;
			}
		}

		public List<EventAwardInfo> MagpieBridgeItems
		{
			get
			{
				return list_2;
			}
			set
			{
				list_2 = value;
			}
		}

		public int[] PrizeStatus
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

		public PlayerExtra(GamePlayer player, bool saveTodb)
		{
			m_lock = new object();
			int_0 = new int[7] { 1, 2, 3, 4, 5, 6, 7 };
			int_1 = new int[4] { 10, 11, 12, 13 };
			MapId = 1;
			takeCardLimit = 3;
			string_0 = GameProperties.TanabataActiveEventNum.Split('|');
			string_1 = GameProperties.TanabataActiveDestinationAWardID.Split('|');
			m_player = player;
			dictionary_0 = new Dictionary<int, int>();
			dictionary_1 = new Dictionary<int, int>();
			list_0 = new List<EventAwardInfo>();
			list_2 = new List<EventAwardInfo>();
			list_1 = new List<FlopCardInfo>();
			bool_0 = saveTodb;
			questInfo_0 = null;
			int_2 = new int[7];
		}

		public virtual void LoadFromDatabase()
		{
			if (bool_0)
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				usersExtraInfo_0 = playerBussiness.GetSingleUsersExtra(Player.PlayerCharacter.ID);
				if (usersExtraInfo_0 == null)
				{
					usersExtraInfo_0 = CreateUsersExtra(Player.PlayerCharacter.ID);
				}
				else
				{
					SetupKingBlessFromData();
					SetupDeedFromData();
					m_player.AvatarBag.CurrentModel = usersExtraInfo_0.CurentDressModel;
					m_player.AvatarBag.StringToDressModelArr(usersExtraInfo_0.DressModelArr);
					if (!string.IsNullOrEmpty(Info.CatchInsectGetPrize))
					{
						string[] array = Info.CatchInsectGetPrize.Split('-');
						int num = 0;
						string[] array2 = array;
						foreach (string s in array2)
						{
							if (num < array.Length)
							{
								int_2[num] = int.Parse(s);
							}
							num++;
						}
					}
				}
			}
			if (usersExtraInfo_0.DressModelArr == ",," || string.IsNullOrEmpty(usersExtraInfo_0.DressModelArr))
			{
				m_player.AvatarBag.LoadDefaulModelArr = true;
			}
		}

		public virtual void SaveToDatabase()
		{
			if (!bool_0)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			ConvertDeed();
			ConvertKingBless();
			ConvertSearchGoodItems();
			ConvertMagpieBridgeItems();
			ConvertCatchInsectGetPrize();
			lock (m_lock)
			{
				if (usersExtraInfo_0 != null && usersExtraInfo_0.IsDirty)
				{
					usersExtraInfo_0.DressModelArr = m_player.AvatarBag.DressModelArrToString();
					usersExtraInfo_0.CurentDressModel = m_player.AvatarBag.CurrentModel;
					if (usersExtraInfo_0.ID > 0)
					{
						playerBussiness.UpdateUsersExtra(usersExtraInfo_0);
					}
					else
					{
						playerBussiness.AddUsersExtra(usersExtraInfo_0);
					}
				}
			}
		}

		public void ConvertCatchInsectGetPrize()
		{
			string text = "";
			int[] prizeStatus = PrizeStatus;
			foreach (int num in prizeStatus)
			{
				text = text + num + "-";
			}
			lock (m_lock)
			{
				usersExtraInfo_0.CatchInsectGetPrize = text.Substring(0, text.Length - 1);
			}
		}

		public UsersExtraInfo CreateUsersExtra(int UserID)
		{
			UsersExtraInfo usersExtraInfo = new UsersExtraInfo();
			usersExtraInfo.UserID = UserID;
			usersExtraInfo.starlevel = 1;
			usersExtraInfo.nowPosition = 0;
			usersExtraInfo.FreeCount = GameProperties.SearchGoodsFreeCount;
			usersExtraInfo.SearchGoodItems = "";
			usersExtraInfo.FreeAddAutionCount = 0;
			usersExtraInfo.FreeSendMailCount = 0;
			usersExtraInfo.KingBlessInfo = "";
			usersExtraInfo.KingBlessEnddate = DateTime.Now;
			usersExtraInfo.KingBlessIndex = 0;
			usersExtraInfo.MissionEnergy = GameProperties.MaxMissionEnergy;
			usersExtraInfo.buyEnergyCount = 1;
			usersExtraInfo.DressModelArr = ",,";
			usersExtraInfo.CurentDressModel = 0;
			usersExtraInfo.ScoreMagicstone = 0;
			usersExtraInfo.DeedInfo = "";
			usersExtraInfo.DeedEnddate = DateTime.Now;
			usersExtraInfo.DeedIndex = 0;
			usersExtraInfo.Score = 0;
			usersExtraInfo.SummerScore = 0;
			usersExtraInfo.CatchInsectGetPrize = "0-0-0-0-0-0-0";
			usersExtraInfo.PrizeStatus = 0;
			usersExtraInfo.CakeStatus = false;
			usersExtraInfo.NormalFightNum = 1;
			usersExtraInfo.HardFightNum = 1;
			usersExtraInfo.IsDoubleScore = false;
			usersExtraInfo.MagpieBridgeItems = "";
			usersExtraInfo.NowPositionMB = 0;
			usersExtraInfo.LastNum = 5;
			usersExtraInfo.MagpieNum = 0;
			return usersExtraInfo;
		}

		public void ResetUsersExtra()
		{
			SetupKingBless(isFriend: false, Info.KingBlessIndex);
			SetupDeed();
			usersExtraInfo_0.starlevel = 1;
			usersExtraInfo_0.nowPosition = 0;
			usersExtraInfo_0.FreeCount = GameProperties.SearchGoodsFreeCount;
			usersExtraInfo_0.FreeAddAutionCount = 0;
			usersExtraInfo_0.FreeSendMailCount = 0;
			usersExtraInfo_0.MissionEnergy = GameProperties.MaxMissionEnergy;
			usersExtraInfo_0.buyEnergyCount = 1;
			CreateSaveLifeBuff();
			CreateSearchGoodItems();
		}

		public void LoadBuriedQuests()
		{
			if (questInfo_0 == null)
			{
				questInfo_0 = QuestMgr.GetAllBuriedQuest();
			}
		}

		public string SetupKingBless(bool isFriend, int kingBlessIndex)
		{
			string result = "";
			if (usersExtraInfo_0.KingBlessEnddate > DateTime.Now)
			{
				int num = 100;
				int num2 = 1;
				int num3 = 3;
				int num4 = 1;
				int num5 = 1;
				int num6 = 0;
				int num7 = 1;
				switch (kingBlessIndex)
				{
				case 2:
					num2 = 2;
					num3 = 4;
					break;
				case 3:
					num = 200;
					num2 = 3;
					num3 = 6;
					num4 = 2;
					num5 = 2;
					break;
				}
				if (isFriend)
				{
					result = "STRENGTH_ENCHANCE," + num;
					result = result + "|PET_REFRESH," + num2;
					result = result + "|BEAD_MASTER," + num3;
					result = result + "|HELP_STRAW," + num4;
					result = result + "|DUNGEON_HERO," + num5;
					result = result + "|TASK_SPIRIT," + num6;
					return result + "|TIME_DEITY," + num7;
				}
				dictionary_0.Clear();
				int[] array = int_0;
				foreach (int num8 in array)
				{
					switch (num8)
					{
					case 1:
						dictionary_0.Add(num8, num);
						break;
					case 2:
						dictionary_0.Add(num8, num2);
						break;
					case 3:
						dictionary_0.Add(num8, num3);
						break;
					case 4:
						dictionary_0.Add(num8, num4);
						break;
					case 5:
						dictionary_0.Add(num8, num5);
						break;
					case 6:
						dictionary_0.Add(num8, num6);
						break;
					case 7:
						dictionary_0.Add(num8, num7);
						break;
					}
				}
				ConvertKingBless();
			}
			return result;
		}

		public void SetupKingBlessFromData()
		{
			if (string.IsNullOrEmpty(usersExtraInfo_0.KingBlessInfo))
			{
				return;
			}
			dictionary_0.Clear();
			string[] array = usersExtraInfo_0.KingBlessInfo.Split('|');
			string[] array2 = array;
			foreach (string text in array2)
			{
				int value = int.Parse(text.Split(',')[1]);
				string text2;
				switch (text2 = text.Split(',')[0])
				{
				case "STRENGTH_ENCHANCE":
					dictionary_0.Add(1, value);
					break;
				case "PET_REFRESH":
					dictionary_0.Add(2, value);
					break;
				case "BEAD_MASTER":
					dictionary_0.Add(3, value);
					break;
				case "HELP_STRAW":
					dictionary_0.Add(4, value);
					break;
				case "DUNGEON_HERO":
					dictionary_0.Add(5, value);
					break;
				case "TASK_SPIRIT":
					dictionary_0.Add(6, value);
					break;
				case "TIME_DEITY":
					dictionary_0.Add(7, value);
					break;
				}
			}
		}

		public void ConvertKingBless()
		{
			if (KingBlessInfo.Count == 0)
			{
				return;
			}
			string text = "";
			using (Dictionary<int, int>.KeyCollection.Enumerator enumerator = KingBlessInfo.Keys.GetEnumerator())
			{
				while (enumerator.MoveNext())
				{
					switch (enumerator.Current)
					{
					case 1:
						text = text + "STRENGTH_ENCHANCE," + KingBlessInfo[1];
						break;
					case 2:
						text = text + "|PET_REFRESH," + KingBlessInfo[2];
						break;
					case 3:
						text = text + "|BEAD_MASTER," + KingBlessInfo[3];
						break;
					case 4:
						text = text + "|HELP_STRAW," + KingBlessInfo[4];
						break;
					case 5:
						text = text + "|DUNGEON_HERO," + KingBlessInfo[5];
						break;
					case 6:
						text = text + "|TASK_SPIRIT," + KingBlessInfo[6];
						break;
					case 7:
						text = text + "|TIME_DEITY," + KingBlessInfo[7];
						break;
					}
				}
			}
			usersExtraInfo_0.KingBlessInfo = text;
		}

		public bool UseKingBless(int key)
		{
			if (KingBlessInfo.ContainsKey(key) && KingBlessInfo[key] > 0)
			{
				dictionary_0[key]--;
				Player.Out.SendKingBlessUpdateBuffData(Player.PlayerCharacter.ID, key, KingBlessInfo[key]);
				return true;
			}
			return false;
		}

		public void KingBlessStrengthEnchance(bool isUp)
		{
			if (isUp && KingBlessInfo.ContainsKey(1))
			{
				Player.PlayerCharacter.StrengthEnchance = KingBlessInfo[1];
			}
			else
			{
				Player.PlayerCharacter.StrengthEnchance = 0;
			}
		}

		public bool UseDeed(int key)
		{
			if (DeedInfo.ContainsKey(key) && DeedInfo[key] > 0)
			{
				dictionary_1[key]--;
				Player.Out.SendDeedUpdateBuffData(Player.PlayerCharacter.ID, key, DeedInfo[key]);
				return true;
			}
			return false;
		}

		public void ConvertDeed()
		{
			if (DeedInfo.Count == 0)
			{
				return;
			}
			string text = "";
			using (Dictionary<int, int>.KeyCollection.Enumerator enumerator = DeedInfo.Keys.GetEnumerator())
			{
				while (enumerator.MoveNext())
				{
					switch (enumerator.Current)
					{
					case 10:
						text = text + "PET_GRANT," + DeedInfo[10];
						break;
					case 11:
						text = text + "|PET_STAR," + DeedInfo[11];
						break;
					case 12:
						text = text + "|HORSE_LIGHT," + DeedInfo[12];
						break;
					case 13:
						text = text + "|HORSE_ANGER," + DeedInfo[13];
						break;
					}
				}
			}
			usersExtraInfo_0.DeedInfo = text;
		}

		public string SetupDeed()
		{
			string result = "";
			if (usersExtraInfo_0.DeedEnddate > DateTime.Now)
			{
				int value = 3;
				int value2 = 2;
				int value3 = 2;
				int value4 = 3;
				dictionary_1.Clear();
				int[] array = int_1;
				foreach (int num in array)
				{
					switch (num)
					{
					case 10:
						dictionary_1.Add(num, value);
						break;
					case 11:
						dictionary_1.Add(num, value2);
						break;
					case 12:
						dictionary_1.Add(num, value3);
						break;
					case 13:
						dictionary_1.Add(num, value4);
						break;
					}
					ConvertDeed();
				}
			}
			return result;
		}

		public void SetupDeedFromData()
		{
			if (string.IsNullOrEmpty(Info.DeedInfo))
			{
				return;
			}
			dictionary_1.Clear();
			string[] array = Info.DeedInfo.Split('|');
			string[] array2 = array;
			foreach (string text in array2)
			{
				int value = int.Parse(text.Split(',')[1]);
				switch (text.Split(',')[0])
				{
				case "HORSE_ANGER":
					dictionary_1.Add(13, value);
					break;
				case "HORSE_LIGHT":
					dictionary_1.Add(12, value);
					break;
				case "PET_STAR":
					dictionary_1.Add(11, value);
					break;
				case "PET_GRANT":
					dictionary_1.Add(10, value);
					break;
				}
			}
		}

		public List<EventAwardInfo> CreateSearchGoodsAward()
		{
			SearchGoodsTempInfo searchGoodsTempInfo = SearchGoodsMgr.GetSearchGoodsTempInfo(usersExtraInfo_0.starlevel);
			new Dictionary<int, EventAwardInfo>();
			string text = ((searchGoodsTempInfo == null) ? "10,2,3,1" : searchGoodsTempInfo.ExtractNumber);
			int[] array = new int[5] { -1, -2, -3, -4, -7 };
			threadSafeRandom_0.Shuffer(array);
			int count = int.Parse(text.Split(',')[0]);
			int num = int.Parse(text.Split(',')[1]);
			int num2 = int.Parse(text.Split(',')[3]);
			int num3 = int.Parse(text.Split(',')[2]);
			GetTotal(text);
			List<int> list = CreateRandomPos();
			List<EventAwardInfo> list2 = new List<EventAwardInfo>();
			EventAwardInfo[] array2 = EventAwardMgr.CreateSearchGoodsAward(count);
			for (int i = 0; i < array2.Length; i++)
			{
				int num4 = list[i];
				EventAwardInfo eventAwardInfo = array2[i];
				eventAwardInfo.Position = num4;
				list2.Add(eventAwardInfo);
				list.Remove(num4);
			}
			for (int j = 0; j < num; j++)
			{
				int num4 = list[j];
				list2.Add(GetSpecialTem(-5, num4));
				list.Remove(num4);
			}
			for (int k = 0; k < num3; k++)
			{
				int num4 = list[k];
				int num5 = threadSafeRandom_0.Next(array.Length);
				list2.Add(GetSpecialTem(array[num5], num4));
				list.Remove(num4);
			}
			for (int l = 0; l < num2; l++)
			{
				int num4 = list[l];
				list2.Add(GetSpecialTem(-6, num4));
				list.Remove(num4);
			}
			return list2;
		}

		public EventAwardInfo GetSpecialTem(int type, int pos)
		{
			EventAwardInfo eventAwardInfo = new EventAwardInfo();
			eventAwardInfo.TemplateID = type;
			eventAwardInfo.Position = pos;
			eventAwardInfo.Count = 1;
			return eventAwardInfo;
		}

		public int GetTotal(string number)
		{
			string[] array = number.Split(',');
			int num = 0;
			string[] array2 = array;
			foreach (string s in array2)
			{
				num += int.Parse(s);
			}
			return num;
		}

		public List<int> CreateRandomPos()
		{
			List<int> list = new List<int>();
			for (int i = 1; i < 35; i++)
			{
				list.Add(i);
			}
			threadSafeRandom_0.ShufferList(list);
			return list;
		}

		public void CreateSearchGoodItems()
		{
			list_0.Clear();
			List<EventAwardInfo> list = CreateSearchGoodsAward();
			lock (m_lock)
			{
				foreach (EventAwardInfo item in list)
				{
					list_0.Add(item);
				}
			}
		}

		public void GetSearchGoodItemsDb()
		{
			if (!string.IsNullOrEmpty(usersExtraInfo_0.SearchGoodItems) && usersExtraInfo_0.starlevel != 1)
			{
				string[] array = usersExtraInfo_0.SearchGoodItems.Split('|');
				string[] array2 = array;
				foreach (string text in array2)
				{
					EventAwardInfo eventAwardInfo = new EventAwardInfo();
					eventAwardInfo.TemplateID = int.Parse(text.Split(',')[0]);
					eventAwardInfo.Position = int.Parse(text.Split(',')[1]);
					eventAwardInfo.Count = int.Parse(text.Split(',')[2]);
					list_0.Add(eventAwardInfo);
				}
			}
			else
			{
				CreateSearchGoodItems();
			}
		}

		public void ConvertSearchGoodItems()
		{
			if (SearchGoodItems.Count <= 0)
			{
				return;
			}
			string text = "";
			foreach (EventAwardInfo searchGoodItem in SearchGoodItems)
			{
				text += $"{searchGoodItem.TemplateID},{searchGoodItem.Position},{searchGoodItem.Count}|";
			}
			text = text.Substring(0, text.Length - 1);
			usersExtraInfo_0.SearchGoodItems = text;
		}

		public void RollDiceCallBack(bool isRemindRollBind)
		{
			int num = threadSafeRandom_0.Next(1, 6);
			bool flag = false;
			if (Info.FreeCount > 0)
			{
				Info.FreeCount--;
				flag = true;
			}
			else if (Player.MoneyDirect(GameProperties.SearchGoodsPayMoney))
			{
				flag = true;
			}
			if (flag)
			{
				usersExtraInfo_0.nowPosition += num;
				if (usersExtraInfo_0.nowPosition > 35)
				{
					usersExtraInfo_0.nowPosition = 35;
				}
				GSPacketIn gSPacketIn = new GSPacketIn(98);
				gSPacketIn.WriteByte(17);
				gSPacketIn.WriteInt(usersExtraInfo_0.FreeCount);
				gSPacketIn.WriteInt(num);
				gSPacketIn.WriteInt(usersExtraInfo_0.nowPosition);
				Player.SendTCP(gSPacketIn);
			}
			EventAwardInfo eventAwardInfo = method_1();
			if (eventAwardInfo != null)
			{
				switch (eventAwardInfo.TemplateID)
				{
				case -4:
					usersExtraInfo_0.nowPosition = 35;
					PlayNowPosition(eventAwardInfo);
					break;
				case -3:
					usersExtraInfo_0.nowPosition++;
					PlayNowPosition(eventAwardInfo);
					break;
				case -2:
					usersExtraInfo_0.nowPosition--;
					PlayNowPosition(eventAwardInfo);
					break;
				case -1:
					usersExtraInfo_0.nowPosition = 0;
					PlayNowPosition(eventAwardInfo);
					break;
				default:
					UpdateGoodItems(eventAwardInfo);
					break;
				case 0:
					break;
				}
			}
			GetEndAward();
		}

		public void RollDiceCallBack()
		{
			EventAwardInfo eventAwardInfo = method_1();
			if (eventAwardInfo != null)
			{
				switch (eventAwardInfo.TemplateID)
				{
				case -4:
					usersExtraInfo_0.nowPosition = 35;
					PlayNowPosition(eventAwardInfo);
					break;
				case -3:
					usersExtraInfo_0.nowPosition++;
					PlayNowPosition(eventAwardInfo);
					break;
				case -2:
					usersExtraInfo_0.nowPosition--;
					PlayNowPosition(eventAwardInfo);
					break;
				case -1:
					usersExtraInfo_0.nowPosition = 0;
					PlayNowPosition(eventAwardInfo);
					break;
				default:
					UpdateGoodItems(eventAwardInfo);
					break;
				case 0:
					break;
				}
			}
			GetEndAward();
		}

		public void GetEndAward()
		{
			if (usersExtraInfo_0.nowPosition == 35)
			{
				SearchGoodsTempInfo searchGoodsTempInfo = SearchGoodsMgr.GetSearchGoodsTempInfo(usersExtraInfo_0.starlevel);
				if (searchGoodsTempInfo != null)
				{
					method_0(searchGoodsTempInfo.DestinationReward, 1);
				}
			}
		}

		public void PlayNowPosition(EventAwardInfo good)
		{
			if (good.TemplateID == -2 || good.TemplateID == -3)
			{
				UpdateGoodItems(good);
				RollDiceCallBack();
			}
			GSPacketIn gSPacketIn = new GSPacketIn(98);
			gSPacketIn.WriteByte(25);
			gSPacketIn.WriteInt(usersExtraInfo_0.nowPosition);
			Player.SendTCP(gSPacketIn);
		}

		private void method_0(int int_3, int int_4)
		{
			if (int_3 > 0)
			{
				ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(int_3);
				if (ıtemTemplateInfo != null)
				{
					ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 105);
					ıtemInfo.IsBinds = true;
					ıtemInfo.Count = int_4;
					Player.AddTemplate(ıtemInfo, ıtemInfo.Template.BagType, int_4, eGameView.OtherTypeGet, "Bản đồ kho báu");
				}
			}
		}

		private EventAwardInfo method_1()
		{
			lock (m_lock)
			{
				foreach (EventAwardInfo item in list_0)
				{
					if (item.Position == usersExtraInfo_0.nowPosition)
					{
						return item;
					}
				}
			}
			return null;
		}

		private void method_2()
		{
			if (questInfo_0 != null && questInfo_0.Length != 0)
			{
				int num = threadSafeRandom_0.Next(questInfo_0.Length);
				QuestInfo info = questInfo_0[num];
				Player.QuestInventory.AddQuest(info, out var _);
			}
		}

		private void method_3()
		{
			list_1.Clear();
			for (int i = 0; i < 5; i++)
			{
				int count = threadSafeRandom_0.Next(5, 75);
				FlopCardInfo flopCardInfo = new FlopCardInfo();
				flopCardInfo.Count = count;
				flopCardInfo.TemplateID = 11680;
				list_1.Add(flopCardInfo);
			}
			takeCardLimit = 3;
			threadSafeRandom_0.ShufferList(list_1);
			GSPacketIn gSPacketIn = new GSPacketIn(98);
			gSPacketIn.WriteByte(24);
			gSPacketIn.WriteInt(takeCardLimit);
			gSPacketIn.WriteInt(list_1.Count);
			foreach (FlopCardInfo item in list_1)
			{
				gSPacketIn.WriteInt(item.TemplateID);
				gSPacketIn.WriteInt(item.Count);
			}
			Player.SendTCP(gSPacketIn);
		}

		public void TakeCard(bool UseMoney)
		{
			string[] array = GameProperties.SearchGoodsTakeCardMoney.Split('|');
			if (takeCardLimit > 0)
			{
				if (Player.MoneyDirect(int.Parse(array[3 - takeCardLimit])))
				{
					threadSafeRandom_0.ShufferList(list_1);
					FlopCardInfo flopCardInfo = list_1[takeCardLimit];
					method_0(flopCardInfo.TemplateID, flopCardInfo.Count);
					takeCardLimit--;
					if (flopCardInfo != null)
					{
						GSPacketIn gSPacketIn = new GSPacketIn(98);
						gSPacketIn.WriteByte(32);
						gSPacketIn.WriteInt(takeCardLimit);
						gSPacketIn.WriteInt(flopCardInfo.TemplateID);
						gSPacketIn.WriteInt(flopCardInfo.Count);
						Player.SendTCP(gSPacketIn);
					}
				}
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("PlayerExtra.TakeCard"));
			}
		}

		public void UpdateGoodItems(EventAwardInfo good)
		{
			if (good.TemplateID == -5)
			{
				method_3();
			}
			if (good.TemplateID == -6)
			{
				method_2();
			}
			method_0(good.TemplateID, good.Count);
			for (int i = 0; i < list_0.Count; i++)
			{
				if (list_0[i].Position == good.Position)
				{
					list_0[i].TemplateID = 0;
					break;
				}
			}
			GSPacketIn gSPacketIn = new GSPacketIn(98);
			gSPacketIn.WriteByte(23);
			gSPacketIn.WriteInt((good.TemplateID >= 0) ? good.TemplateID : 0);
			Player.SendTCP(gSPacketIn);
		}

		public void CreateSaveLifeBuff()
		{
			if (m_player.PlayerCharacter.VIPLevel >= 4 && !m_player.PlayerCharacter.method_0())
			{
				BufferList.CreateSaveLifeBuffer(3)?.Start(Player);
			}
			else
			{
				BufferList.CreateSaveLifeBuffer(0)?.Start(Player);
			}
		}

		public void MagpieBridgeRollDiceCallBack(bool isRemindRollBind)
		{
			int num = threadSafeRandom_0.Next(1, 6);
			bool flag = false;
			if (Info.FreeCount > 0)
			{
				Info.FreeCount--;
				flag = true;
			}
			else if (Player.MoneyDirect(GameProperties.SearchGoodsPayMoney))
			{
				flag = true;
			}
			if (flag)
			{
				usersExtraInfo_0.NowPositionMB += num;
				if (usersExtraInfo_0.NowPositionMB > 35)
				{
					usersExtraInfo_0.NowPositionMB = 35;
				}
				GSPacketIn gSPacketIn = new GSPacketIn(276);
				gSPacketIn.WriteByte(2);
				gSPacketIn.WriteInt(usersExtraInfo_0.LastNum);
				gSPacketIn.WriteInt(num);
				gSPacketIn.WriteInt(usersExtraInfo_0.NowPositionMB);
				Player.SendTCP(gSPacketIn);
			}
			EventAwardInfo eventAwardInfo = method_4();
			if (eventAwardInfo != null)
			{
				switch (eventAwardInfo.TemplateID)
				{
				case -4:
					usersExtraInfo_0.NowPositionMB = 35;
					MagpieBridgePlayNowPosition(eventAwardInfo);
					break;
				case -3:
					usersExtraInfo_0.NowPositionMB++;
					MagpieBridgePlayNowPosition(eventAwardInfo);
					break;
				case -2:
					usersExtraInfo_0.NowPositionMB--;
					MagpieBridgePlayNowPosition(eventAwardInfo);
					break;
				case -1:
					usersExtraInfo_0.NowPositionMB = 0;
					MagpieBridgePlayNowPosition(eventAwardInfo);
					break;
				case 0:
					break;
				default:
					UpdateMagpieBridgeGoodItems(eventAwardInfo);
					break;
				}
			}
		}

		public void MagpieBridgePlayNowPosition(EventAwardInfo good)
		{
			if (good.TemplateID == -2 || good.TemplateID == -3)
			{
				UpdateMagpieBridgeGoodItems(good);
				MagpieBridgeRollDiceCallBack();
			}
			GSPacketIn gSPacketIn = new GSPacketIn(276);
			gSPacketIn.WriteByte(7);
			gSPacketIn.WriteInt(usersExtraInfo_0.NowPositionMB);
			Player.SendTCP(gSPacketIn);
		}

		public void MagpieBridgeRollDiceCallBack()
		{
			EventAwardInfo eventAwardInfo = method_1();
			if (eventAwardInfo != null)
			{
				switch (eventAwardInfo.TemplateID)
				{
				case -4:
					usersExtraInfo_0.NowPositionMB = 35;
					MagpieBridgePlayNowPosition(eventAwardInfo);
					break;
				case -3:
					usersExtraInfo_0.NowPositionMB++;
					MagpieBridgePlayNowPosition(eventAwardInfo);
					break;
				case -2:
					usersExtraInfo_0.NowPositionMB--;
					MagpieBridgePlayNowPosition(eventAwardInfo);
					break;
				case -1:
					usersExtraInfo_0.NowPositionMB = 0;
					MagpieBridgePlayNowPosition(eventAwardInfo);
					break;
				case 0:
					break;
				default:
					UpdateMagpieBridgeGoodItems(eventAwardInfo);
					break;
				}
			}
		}

		public void UpdateMagpieBridgeGoodItems(EventAwardInfo good)
		{
			if (Info.NowPositionMB != 35)
			{
				if (good.TemplateID == -6)
				{
					usersExtraInfo_0.MagpieNum++;
					UpdateMagpieNum();
				}
				method_0(good.TemplateID, good.Count);
				for (int i = 0; i < list_2.Count; i++)
				{
					if (list_2[i].Position == good.Position)
					{
						list_2[i].TemplateID = 0;
						break;
					}
				}
				GSPacketIn gSPacketIn = new GSPacketIn(276);
				gSPacketIn.WriteByte(6);
				gSPacketIn.WriteInt((good.TemplateID >= 0) ? good.TemplateID : 0);
				Player.SendTCP(gSPacketIn);
			}
			else
			{
				method_0(good.TemplateID, 1);
				usersExtraInfo_0.MagpieNum += 2;
			}
			if (Info.MagpieNum >= 10)
			{
				method_0(1120155, 1);
				GSPacketIn gSPacketIn2 = new GSPacketIn(276);
				gSPacketIn2.WriteByte(12);
				Player.SendTCP(gSPacketIn2);
				Info.MagpieNum = 0;
			}
		}

		public void UpdateMagpieNum()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(276);
			gSPacketIn.WriteByte(10);
			gSPacketIn.WriteInt(Info.MagpieNum);
			Player.SendTCP(gSPacketIn);
		}

		private EventAwardInfo method_4()
		{
			lock (m_lock)
			{
				foreach (EventAwardInfo item in list_2)
				{
					if (item.Position == usersExtraInfo_0.NowPositionMB)
					{
						return item;
					}
				}
			}
			return null;
		}

		public List<EventAwardInfo> CreateMagpieBridgeAward()
		{
			new Dictionary<int, EventAwardInfo>();
			int[] array = new int[5] { -1, -2, -3, -4, -7 };
			threadSafeRandom_0.Shuffer(array);
			int num = threadSafeRandom_0.Next(string_0.Length - 1);
			string[] array2 = string_0[num].Split(',');
			int count = int.Parse(array2[0]);
			int num2 = int.Parse(array2[1]);
			int num3 = int.Parse(array2[2]);
			List<int> list = CreateRandomPos();
			List<EventAwardInfo> list2 = new List<EventAwardInfo>();
			EventAwardInfo[] array3 = EventAwardMgr.CreateMagpieBridgeAward(count);
			int num4;
			for (int i = 0; i < array3.Length; i++)
			{
				num4 = list[i];
				EventAwardInfo eventAwardInfo = array3[i];
				eventAwardInfo.Position = num4;
				list2.Add(eventAwardInfo);
				list.Remove(num4);
			}
			for (int j = 0; j < num2; j++)
			{
				num4 = list[j];
				int num5 = threadSafeRandom_0.Next(array.Length);
				list2.Add(GetSpecialTem(array[num5], num4));
				list.Remove(num4);
			}
			for (int k = 0; k < num3; k++)
			{
				num4 = list[k];
				list2.Add(GetSpecialTem(-6, num4));
				list.Remove(num4);
			}
			num4 = threadSafeRandom_0.Next(string_1.Length - 1);
			list2.Add(GetSpecialTem(int.Parse(string_1[num4]), 35));
			return list2;
		}

		public void CreateMagpieBridgeItems(bool Refresh)
		{
			if (Refresh)
			{
				list_2.Clear();
				usersExtraInfo_0.NowPositionMB = 0;
			}
			List<EventAwardInfo> list = CreateMagpieBridgeAward();
			lock (m_lock)
			{
				foreach (EventAwardInfo item in list)
				{
					list_2.Add(item);
				}
			}
		}

		public void GetMagpieBridgeItemsDb()
		{
			list_2.Clear();
			if (string.IsNullOrEmpty(usersExtraInfo_0.MagpieBridgeItems))
			{
				CreateMagpieBridgeItems(Refresh: false);
				return;
			}
			string[] array = usersExtraInfo_0.MagpieBridgeItems.Split('|');
			string[] array2 = array;
			foreach (string text in array2)
			{
				EventAwardInfo eventAwardInfo = new EventAwardInfo();
				eventAwardInfo.TemplateID = int.Parse(text.Split(',')[0]);
				eventAwardInfo.Position = int.Parse(text.Split(',')[1]);
				eventAwardInfo.Count = int.Parse(text.Split(',')[2]);
				list_2.Add(eventAwardInfo);
			}
		}

		public void ConvertMagpieBridgeItems()
		{
			if (MagpieBridgeItems.Count <= 0)
			{
				return;
			}
			string text = "";
			foreach (EventAwardInfo magpieBridgeItem in MagpieBridgeItems)
			{
				text += $"{magpieBridgeItem.TemplateID},{magpieBridgeItem.Position},{magpieBridgeItem.Count}|";
			}
			text = text.Substring(0, text.Length - 1);
			usersExtraInfo_0.MagpieBridgeItems = text;
		}

		public GSPacketIn SendMagpieBridgeEnter()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(276, Player.PlayerId);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(MapId);
			gSPacketIn.WriteInt(Info.NowPositionMB);
			gSPacketIn.WriteInt(Info.LastNum);
			gSPacketIn.WriteInt(Info.MagpieNum);
			gSPacketIn.WriteInt(MagpieBridgeItems.Count);
			foreach (EventAwardInfo magpieBridgeItem in MagpieBridgeItems)
			{
				gSPacketIn.WriteInt(magpieBridgeItem.Position);
				gSPacketIn.WriteInt(magpieBridgeItem.TemplateID);
			}
			Player.SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		static PlayerExtra()
		{
			threadSafeRandom_0 = new ThreadSafeRandom();
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
