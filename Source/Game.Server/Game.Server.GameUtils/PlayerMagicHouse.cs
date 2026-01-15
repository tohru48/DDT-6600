using System;
using System.Collections.Generic;
using System.Reflection;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using log4net;
using Newtonsoft.Json;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public class PlayerMagicHouse : PlayerInventory
	{
		private static readonly ILog ilog_1;

		public int FREEBOX_MAXCOUNT;

		public int CHARGEBOX_MAXCOUNT;

		private string[] string_0;

		private string[] string_1;

		private string[] string_2;

		private string[] string_3;

		private string[] string_4;

		private string[] string_5;

		private string[] string_6;

		private string[] string_7;

		private int[] int_4;

		private UsersMagicHouseInfo usersMagicHouseInfo_0;

		private static int int_5;

		public readonly int TITLE_JUNIOR_ID;

		public readonly int TITLE_MID_ID;

		public readonly int TITLE_SENIOR_ID;

		public UsersMagicHouseInfo Info => usersMagicHouseInfo_0;

		public int BaseDepotCount => int_5;

		public PlayerMagicHouse(GamePlayer player)
			: base(player, saveTodb: true, 100, 51, 0, autoStack: true)
		{
			FREEBOX_MAXCOUNT = 5;
			CHARGEBOX_MAXCOUNT = 20;
			TITLE_JUNIOR_ID = 1010;
			TITLE_MID_ID = 1011;
			TITLE_SENIOR_ID = 1012;
			string_0 = GameProperties.MagicRoomJuniorWeaponList.Split('|');
			string_1 = GameProperties.MagicRoomJuniorWeaponList.Split('|');
			string_2 = GameProperties.MagicRoomJuniorWeaponList.Split('|');
			string_3 = GameProperties.MagicRoomJuniorAddAttribute.Split('|');
			string_4 = GameProperties.MagicRoomMidAddAttribute.Split('|');
			string_5 = GameProperties.MagicRoomSeniorAddAttribute.Split('|');
			string_6 = GameProperties.MagicRoomLevelUpCount.Split('|');
			string_7 = GameProperties.MagicRoomOpenNeedMoney.Split('|');
			int_4 = new int[9];
		}

		public override void LoadFromDatabase()
		{
			BeginChanges();
			try
			{
				base.LoadFromDatabase();
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				UsersMagicHouseInfo usersMagicHouseInfo = playerBussiness.GetAllUsersMagicHouseByID(base.Player.PlayerId);
				if (usersMagicHouseInfo == null)
				{
					usersMagicHouseInfo = new UsersMagicHouseInfo();
					usersMagicHouseInfo.UserID = base.Player.PlayerId;
					usersMagicHouseInfo.isOpen = true;
					usersMagicHouseInfo.isMagicRoomShow = true;
					usersMagicHouseInfo.magicJuniorLv = 0;
					usersMagicHouseInfo.magicJuniorExp = 0;
					usersMagicHouseInfo.magicMidLv = 0;
					usersMagicHouseInfo.magicMidExp = 0;
					usersMagicHouseInfo.magicSeniorLv = 0;
					usersMagicHouseInfo.magicSeniorExp = 0;
					usersMagicHouseInfo.freeGetCount = 0;
					usersMagicHouseInfo.freeGetTime = DateTime.Now;
					usersMagicHouseInfo.chargeGetCount = 0;
					usersMagicHouseInfo.chargeGetTime = DateTime.Now;
					usersMagicHouseInfo.depotCount = int_5;
					usersMagicHouseInfo.activityWeapons = SerializeActivityWeapons();
				}
				lock (m_lock)
				{
					usersMagicHouseInfo_0 = usersMagicHouseInfo;
				}
			}
			finally
			{
				DeserializeActivityWeapons();
				CommitChanges();
			}
		}

		public override void SaveToDatabase()
		{
			base.SaveToDatabase();
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			if (usersMagicHouseInfo_0 != null && usersMagicHouseInfo_0.IsDirty)
			{
				usersMagicHouseInfo_0.activityWeapons = SerializeActivityWeapons();
				if (usersMagicHouseInfo_0.ID == 0)
				{
					playerBussiness.AddUsersMagicHouse(usersMagicHouseInfo_0);
				}
				else
				{
					playerBussiness.UpdateUsersMagicHouse(usersMagicHouseInfo_0);
				}
			}
		}

		public void DeserializeActivityWeapons()
		{
			try
			{
				if (Info == null || string.IsNullOrEmpty(Info.activityWeapons))
				{
					return;
				}
				int[] array = JsonConvert.DeserializeObject<int[]>(Info.activityWeapons);
				if (array.Length == int_4.Length)
				{
					for (int i = 0; i < int_4.Length; i++)
					{
						int_4[i] = array[i];
					}
				}
			}
			catch (Exception exception)
			{
				ilog_1.Error("DeserializeMagicHouse fail: ", exception);
			}
		}

		public string SerializeActivityWeapons()
		{
			return JsonConvert.SerializeObject(int_4);
		}

		public int[] JuniorWeaponList(int slot)
		{
			List<int> list = new List<int>();
			string[] array = string_0[slot].Split(',');
			string[] array2 = array;
			foreach (string s in array2)
			{
				list.Add(int.Parse(s));
			}
			return list.ToArray();
		}

		public int[] MidWeaponList(int slot)
		{
			List<int> list = new List<int>();
			string[] array = string_1[slot].Split(',');
			string[] array2 = array;
			foreach (string s in array2)
			{
				list.Add(int.Parse(s));
			}
			return list.ToArray();
		}

		public int[] SeniorWeaponList(int slot)
		{
			List<int> list = new List<int>();
			string[] array = string_2[slot].Split(',');
			string[] array2 = array;
			foreach (string s in array2)
			{
				list.Add(int.Parse(s));
			}
			return list.ToArray();
		}

		public int[] LevelUpExp()
		{
			List<int> list = new List<int>();
			string[] array = string_6;
			foreach (string s in array)
			{
				list.Add(int.Parse(s));
			}
			return list.ToArray();
		}

		public int[] OpenNeedMoney()
		{
			List<int> list = new List<int>();
			string[] array = string_7;
			foreach (string s in array)
			{
				list.Add(int.Parse(s));
			}
			return list.ToArray();
		}

		public void OpenMagicLib(int templateId, int type, int pos)
		{
			lock (m_lock)
			{
				int_4[(type - 1) * 3 + pos] = templateId;
			}
			if (EquipActive(type))
			{
				switch (type)
				{
				case 1:
					base.Player.Rank.AddNewRank(1010);
					break;
				case 2:
					base.Player.Rank.AddNewRank(1011);
					break;
				case 3:
					base.Player.Rank.AddNewRank(1012);
					break;
				}
				base.Player.Rank.UpdateRank();
				base.Player.EquipBag.UpdatePlayerProperties();
			}
		}

		public bool EquipActive(int type)
		{
			if (type == 1 && int_4[0] != 0 && int_4[1] != 0 && int_4[2] != 0)
			{
				base.Player.Rank.AddNewRank(1010);
				return true;
			}
			if (type == 2 && int_4[3] != 0 && int_4[4] != 0 && int_4[5] != 0)
			{
				base.Player.Rank.AddNewRank(1011);
				return true;
			}
			if (type == 3 && int_4[6] != 0 && int_4[7] != 0 && int_4[8] != 0)
			{
				base.Player.Rank.AddNewRank(1012);
				return true;
			}
			return false;
		}

		public void UpdateEnhanceProperties(int baseAttack, int baseDefence, ref int enhanceAtt, ref int enhanceDef, ref int attack, ref int defence, ref int agility, ref int lucky, ref int critBonus)
		{
			int attack2 = 0;
			int defence2 = 0;
			int crit = 0;
			if (EquipActive(1))
			{
				NewTitleInfo newTitleInfo = NewTitleMgr.FindNewTitle(TITLE_JUNIOR_ID);
				if (newTitleInfo != null)
				{
					attack += newTitleInfo.Att;
					defence += newTitleInfo.Def;
					agility += newTitleInfo.Agi;
					lucky += newTitleInfo.Luck;
				}
				UpdateAddAttribute(1, ref attack2, ref defence2, ref crit);
			}
			if (EquipActive(2))
			{
				NewTitleInfo newTitleInfo2 = NewTitleMgr.FindNewTitle(TITLE_MID_ID);
				if (newTitleInfo2 != null)
				{
					attack += newTitleInfo2.Att;
					defence += newTitleInfo2.Def;
					agility += newTitleInfo2.Agi;
					lucky += newTitleInfo2.Luck;
				}
				UpdateAddAttribute(2, ref attack2, ref defence2, ref crit);
			}
			if (EquipActive(3))
			{
				NewTitleInfo newTitleInfo3 = NewTitleMgr.FindNewTitle(TITLE_SENIOR_ID);
				if (newTitleInfo3 != null)
				{
					attack += newTitleInfo3.Att;
					defence += newTitleInfo3.Def;
					agility += newTitleInfo3.Agi;
					lucky += newTitleInfo3.Luck;
				}
				UpdateAddAttribute(3, ref attack2, ref defence2, ref crit);
			}
			enhanceAtt = baseAttack + baseAttack * attack2 / 100;
			enhanceDef = baseDefence + baseDefence * defence2 / 100;
			critBonus = crit;
		}

		public void UpdateAddAttribute(int type, ref int attack, ref int defence, ref int crit)
		{
			switch (type)
			{
			case 1:
			{
				for (int j = 0; j <= Info.magicJuniorLv; j++)
				{
					attack += int.Parse(string_3[j].Split(',')[0]);
					defence += int.Parse(string_3[j].Split(',')[1]);
					crit += int.Parse(string_3[j].Split(',')[2]);
				}
				break;
			}
			case 2:
			{
				for (int k = 0; k <= Info.magicMidLv; k++)
				{
					attack += int.Parse(string_4[k].Split(',')[0]);
					defence += int.Parse(string_4[k].Split(',')[1]);
					crit += int.Parse(string_4[k].Split(',')[2]);
				}
				break;
			}
			default:
			{
				for (int i = 0; i <= Info.magicSeniorLv; i++)
				{
					attack += int.Parse(string_5[i].Split(',')[0]);
					defence += int.Parse(string_5[i].Split(',')[1]);
					crit += int.Parse(string_5[i].Split(',')[2]);
				}
				break;
			}
			}
		}

		public void Init()
		{
			LoginMessage();
		}

		public void Reset()
		{
			lock (m_lock)
			{
				if (Info.freeGetTime.Date < DateTime.Now.Date)
				{
					usersMagicHouseInfo_0.freeGetCount = 0;
				}
				if (Info.chargeGetTime.Date < DateTime.Now.Date)
				{
					usersMagicHouseInfo_0.chargeGetCount = 0;
				}
			}
		}

		public ItemInfo[] GetAward(int count, eEventType DataId)
		{
			List<ItemInfo> list = new List<ItemInfo>();
			int num = 0;
			while (list.Count < count)
			{
				List<ItemInfo> eventAwardByType = EventAwardMgr.GetEventAwardByType(DataId);
				if (eventAwardByType.Count > 0)
				{
					ItemInfo item = eventAwardByType[0];
					list.Add(item);
				}
				num++;
			}
			return list.ToArray();
		}

		public void LoginMessage()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(84, base.Player.PlayerId);
			gSPacketIn.WriteInt(4);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteBoolean(val: true);
			int[] array = int_4;
			foreach (int val in array)
			{
				gSPacketIn.WriteInt(val);
			}
			gSPacketIn.WriteInt(Info.magicJuniorLv);
			gSPacketIn.WriteInt(Info.magicJuniorExp);
			gSPacketIn.WriteInt(Info.magicMidLv);
			gSPacketIn.WriteInt(Info.magicMidExp);
			gSPacketIn.WriteInt(Info.magicSeniorLv);
			gSPacketIn.WriteInt(Info.magicSeniorExp);
			gSPacketIn.WriteInt(Info.freeGetCount);
			gSPacketIn.WriteDateTime(Info.freeGetTime);
			gSPacketIn.WriteInt(Info.chargeGetCount);
			gSPacketIn.WriteDateTime(Info.chargeGetTime);
			gSPacketIn.WriteInt(Info.depotCount);
			base.Player.SendTCP(gSPacketIn);
		}

		public void UpdateMessage()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(84, base.Player.PlayerId);
			gSPacketIn.WriteInt(4);
			gSPacketIn.WriteInt(2);
			gSPacketIn.WriteBoolean(val: true);
			int[] array = int_4;
			foreach (int val in array)
			{
				gSPacketIn.WriteInt(val);
			}
			gSPacketIn.WriteInt(Info.magicJuniorLv);
			gSPacketIn.WriteInt(Info.magicJuniorExp);
			gSPacketIn.WriteInt(Info.magicMidLv);
			gSPacketIn.WriteInt(Info.magicMidExp);
			gSPacketIn.WriteInt(Info.magicSeniorLv);
			gSPacketIn.WriteInt(Info.magicSeniorExp);
			gSPacketIn.WriteInt(Info.freeGetCount);
			gSPacketIn.WriteDateTime(Info.freeGetTime);
			gSPacketIn.WriteInt(Info.chargeGetCount);
			gSPacketIn.WriteDateTime(Info.chargeGetTime);
			gSPacketIn.WriteInt(Info.depotCount);
			base.Player.SendTCP(gSPacketIn);
		}

		static PlayerMagicHouse()
		{
			ilog_1 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			int_5 = 10;
		}
	}
}
