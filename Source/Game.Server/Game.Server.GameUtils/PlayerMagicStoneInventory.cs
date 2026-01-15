using System;
using System.Collections.Generic;
using Bussiness;
using Bussiness.Managers;
using Game.Server.GameObjects;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public class PlayerMagicStoneInventory : PlayerInventory
	{
		public static ThreadSafeRandom random;

		public PlayerMagicStoneInventory(GamePlayer player)
			: base(player, saveTodb: true, 144, 41, 32, autoStack: true)
		{
		}

		public override void LoadFromDatabase()
		{
			BeginChanges();
			try
			{
				base.LoadFromDatabase();
				List<ItemInfo> list = new List<ItemInfo>();
				for (int i = 0; i < 32; i++)
				{
					ItemInfo ıtemInfo = m_items[i];
					if (m_items[i] != null && !CanEquip(m_items[i].Place))
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

		public bool CanEquip(int fromSlot)
		{
			if (m_items[fromSlot] == null)
			{
				return false;
			}
			if (fromSlot < base.BeginSlot - 1)
			{
				return true;
			}
			ItemInfo ıtemInfo = m_items[fromSlot];
			lock (m_lock)
			{
				for (int i = 0; i < base.BeginSlot - 1; i++)
				{
					if (m_items[i] != null)
					{
						if (m_items[i].SameMagicstone("att") && ıtemInfo.SameMagicstone("att"))
						{
							return false;
						}
						if (m_items[i].SameMagicstone("def") && ıtemInfo.SameMagicstone("def"))
						{
							return false;
						}
						if (m_items[i].SameMagicstone("agi") && ıtemInfo.SameMagicstone("agi"))
						{
							return false;
						}
						if (m_items[i].SameMagicstone("luc") && ıtemInfo.SameMagicstone("luc"))
						{
							return false;
						}
						if (m_items[i].SameMagicstone("mgatt") && ıtemInfo.SameMagicstone("mgatt"))
						{
							return false;
						}
						if (m_items[i].SameMagicstone("mgdef") && ıtemInfo.SameMagicstone("mgdef"))
						{
							return false;
						}
					}
				}
			}
			return true;
		}

		public override bool MoveItem(int fromSlot, int toSlot, int count)
		{
			return m_items[fromSlot] != null && base.MoveItem(fromSlot, toSlot, count);
		}

		public ItemInfo CreateMagicstone(ItemTemplateInfo info, int level)
		{
			MagicStoneInfo magicStoneInfo = MagicStoneMgr.FindMagicStoneByLevel(info.TemplateID, level);
			if (magicStoneInfo == null)
			{
				return null;
			}
			PropMgInfo[] array = MagicStoneMgr.CreateProp(magicStoneInfo);
			random.Shuffer(array);
			ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(info, 1, 102);
			int num = ((array.Length > info.Property3) ? info.Property3 : array.Length);
			for (int i = 0; i < num; i++)
			{
				switch (array[i].key)
				{
				case "mgdef":
					ıtemInfo.MagicDefence = array[i].value;
					break;
				case "mgatt":
					ıtemInfo.MagicAttack = array[i].value;
					break;
				case "luc":
					ıtemInfo.LuckCompose = array[i].value;
					break;
				case "def":
					ıtemInfo.DefendCompose = array[i].value;
					break;
				case "agi":
					ıtemInfo.AgilityCompose = array[i].value;
					break;
				case "att":
					ıtemInfo.AttackCompose = array[i].value;
					break;
				}
			}
			ıtemInfo.StrengthenLevel = level;
			ıtemInfo.StrengthenExp = magicStoneInfo.Exp;
			return ıtemInfo;
		}

		public override void UpdateChangedPlaces()
		{
			int[] array = m_changedPlaces.ToArray();
			bool flag = false;
			int[] array2 = array;
			foreach (int slot in array2)
			{
				if (!IsEquipSlot(slot))
				{
					continue;
				}
				ItemInfo ıtemAt = GetItemAt(slot);
				if (ıtemAt != null)
				{
					m_player.OnUsingItem(ıtemAt.TemplateID);
					ıtemAt.IsBinds = true;
					if (!ıtemAt.IsUsed)
					{
						ıtemAt.IsUsed = true;
						ıtemAt.BeginDate = DateTime.Now;
					}
				}
				flag = true;
				break;
			}
			base.UpdateChangedPlaces();
			if (flag)
			{
				base.Player.EquipBag.UpdatePlayerProperties();
			}
		}

		static PlayerMagicStoneInventory()
		{
			random = new ThreadSafeRandom();
		}
	}
}
