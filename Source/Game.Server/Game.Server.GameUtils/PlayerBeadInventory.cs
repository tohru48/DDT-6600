using System.Collections.Generic;
using Bussiness;
using Game.Server.GameObjects;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public class PlayerBeadInventory : PlayerInventory
	{
		private Dictionary<int, UserDrillInfo> dictionary_0;

		public Dictionary<int, UserDrillInfo> UserDrills
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

		public PlayerBeadInventory(GamePlayer player)
			: base(player, saveTodb: true, 179, 21, 32, autoStack: false)
		{
			dictionary_0 = new Dictionary<int, UserDrillInfo>();
		}

		public override void LoadFromDatabase()
		{
			BeginChanges();
			try
			{
				base.LoadFromDatabase();
				LoadDrills();
				List<ItemInfo> list = new List<ItemInfo>();
				for (int i = 1; i < 32; i++)
				{
					ItemInfo ıtemInfo = m_items[i];
					if (m_items[i] != null && !CanEquip(m_items[i], m_items[i].Place))
					{
						int num = FindFirstEmptySlot(32);
						if (num >= 0)
						{
							MoveItem(ıtemInfo.Place, num, ıtemInfo.Count);
							continue;
						}
						ItemInfo item = ıtemInfo.Clone();
						list.Add(item);
						TakeOutItem(ıtemInfo);
					}
				}
				if (list.Count > 0)
				{
					m_player.SendItemsToMail(list, "", "Cấp châu báu và cấp lỗ không khớp", eMailType.ItemOverdue);
					m_player.Out.SendMailResponse(m_player.PlayerCharacter.ID, eMailRespose.Receiver);
				}
			}
			finally
			{
				CommitChanges();
			}
		}

		public override void SaveToDatabase()
		{
			base.SaveToDatabase();
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			foreach (UserDrillInfo value in dictionary_0.Values)
			{
				playerBussiness.UpdateUserDrillInfo(value);
			}
		}

		public void LoadDrills()
		{
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			dictionary_0 = playerBussiness.GetPlayerDrillByID(m_player.PlayerCharacter.ID);
			if (dictionary_0.Count != 0)
			{
				return;
			}
			List<int> list = new List<int>();
			list.Add(13);
			list.Add(14);
			list.Add(15);
			list.Add(16);
			list.Add(17);
			list.Add(18);
			List<int> list2 = list;
			List<int> list3 = new List<int>();
			list3.Add(0);
			list3.Add(1);
			list3.Add(2);
			list3.Add(3);
			list3.Add(4);
			list3.Add(5);
			List<int> list4 = list3;
			for (int i = 0; i < list2.Count; i++)
			{
				UserDrillInfo userDrillInfo = new UserDrillInfo();
				userDrillInfo.UserID = m_player.PlayerCharacter.ID;
				userDrillInfo.BeadPlace = list2[i];
				userDrillInfo.HoleLv = 0;
				userDrillInfo.HoleExp = 0;
				userDrillInfo.DrillPlace = list4[i];
				playerBussiness.AddUserUserDrill(userDrillInfo);
				if (!dictionary_0.ContainsKey(userDrillInfo.DrillPlace))
				{
					dictionary_0.Add(userDrillInfo.DrillPlace, userDrillInfo);
				}
			}
		}

		public void UpdateDrill(int index, UserDrillInfo drill)
		{
			dictionary_0[index] = drill;
		}

		public int GetDrillLevel(int place)
		{
			if (place > 31)
			{
				return 5;
			}
			if (place < 13)
			{
				return 5;
			}
			lock (m_lock)
			{
				for (int i = 0; i < UserDrills.Count; i++)
				{
					if (UserDrills[i].BeadPlace == place)
					{
						return UserDrills[i].HoleLv;
					}
				}
			}
			return 0;
		}

		public void SendPlayerDrill()
		{
			m_player.Out.SendPlayerDrill(m_player.PlayerCharacter.ID, dictionary_0);
		}

		public override bool MoveItem(int fromSlot, int toSlot, int count)
		{
			return fromSlot >= 0 && toSlot >= 0 && fromSlot < base.Capalility && toSlot < base.Capalility && m_items[fromSlot] != null && (CanEquip(m_items[fromSlot], toSlot) || toSlot >= 31) && (m_items[toSlot] == null || fromSlot >= 31 || CanEquip(m_items[toSlot], fromSlot)) && base.MoveItem(fromSlot, toSlot, count);
		}

		public bool CanEquip(ItemInfo param1, int place)
		{
			if (param1.Template.Property1 == 31 && param1.Template.Property2 == 1 && place == 1)
			{
				return true;
			}
			if (param1.Template.Property1 == 31 && param1.Template.Property2 == 2 && (place == 2 || place == 3))
			{
				return true;
			}
			if (param1.Template.Property1 == 31 && param1.Template.Property2 == 3)
			{
				if (place != 1 && place != 2 && place != 3)
				{
					int drillLevel = GetDrillLevel(place);
					return JudgeLevel(param1.Hole1, drillLevel);
				}
				return false;
			}
			return false;
		}

		public int GetEquipPlace(ItemTemplateInfo param1)
		{
			if (param1.Property1 == 31 && param1.Property2 == 1)
			{
				return 1;
			}
			if (param1.Property1 == 31 && param1.Property2 == 2)
			{
				if (GetItemAt(2) == null)
				{
					return 2;
				}
				if (GetItemAt(3) != null)
				{
					return 2;
				}
				return 3;
			}
			if (param1.Property1 == 31 && param1.Property2 == 3)
			{
				int num = 5;
				if (m_player.Level >= 15)
				{
					num = 6;
				}
				if (m_player.Level >= 18)
				{
					num = 7;
				}
				if (m_player.Level >= 21)
				{
					num = 8;
				}
				if (m_player.Level >= 24)
				{
					num = 9;
				}
				if (m_player.Level >= 27)
				{
					num = 10;
				}
				if (m_player.Level >= 30)
				{
					num = 11;
				}
				if (m_player.Level >= 33)
				{
					num = 12;
				}
				for (int i = 4; i <= num; i++)
				{
					if (GetItemAt(i) == null)
					{
						return i;
					}
				}
				return 4;
			}
			return -1;
		}

		public bool JudgeLevel(int beadLv, int drillLv)
		{
			switch (drillLv)
			{
			case 1:
				if (beadLv >= 1 && beadLv <= 4)
				{
					return true;
				}
				break;
			case 2:
				if (beadLv >= 1 && beadLv <= 8)
				{
					return true;
				}
				break;
			case 3:
				if (beadLv >= 1 && beadLv <= 12)
				{
					return true;
				}
				break;
			case 4:
				if (beadLv >= 1 && beadLv <= 16)
				{
					return true;
				}
				break;
			case 5:
				return true;
			}
			return false;
		}

		public bool CheckEquipByLevel(int place, int grade, ref int needLv)
		{
			bool result = true;
			switch (place)
			{
			case 6:
				needLv = 15;
				if (grade < needLv)
				{
					result = false;
				}
				break;
			case 7:
				needLv = 18;
				if (grade < needLv)
				{
					result = false;
				}
				break;
			case 8:
				needLv = 21;
				if (grade < needLv)
				{
					result = false;
				}
				break;
			case 9:
				needLv = 24;
				if (grade < needLv)
				{
					result = false;
				}
				break;
			case 10:
				needLv = 27;
				if (grade < needLv)
				{
					result = false;
				}
				break;
			case 11:
				needLv = 30;
				if (grade < needLv)
				{
					result = false;
				}
				break;
			case 12:
				needLv = 33;
				if (grade < needLv)
				{
					result = false;
				}
				break;
			}
			return result;
		}

		public override void UpdateChangedPlaces()
		{
			int[] array = m_changedPlaces.ToArray();
			int[] array2 = array;
			foreach (int slot in array2)
			{
				if (IsEquipSlot(slot))
				{
					ItemInfo ıtemAt = GetItemAt(slot);
					if (ıtemAt != null)
					{
						ıtemAt.IsBinds = true;
					}
					break;
				}
			}
			base.UpdateChangedPlaces();
		}
	}
}
