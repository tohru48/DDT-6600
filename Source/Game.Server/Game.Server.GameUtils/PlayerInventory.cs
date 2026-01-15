using System;
using System.Collections.Generic;
using System.Text;
using Bussiness;
using Game.Server.GameObjects;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public class PlayerInventory : AbstractInventory
	{
		protected GamePlayer m_player;

		private bool bool_1;

		private List<ItemInfo> list_0;

		public GamePlayer Player => m_player;

		public PlayerInventory(GamePlayer player, bool saveTodb, int capibility, int type, int beginSlot, bool autoStack)
			: base(capibility, type, beginSlot, autoStack)
		{
			list_0 = new List<ItemInfo>();
			m_player = player;
			bool_1 = saveTodb;
		}

		public virtual void LoadFromDatabase()
		{
			if (!bool_1)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			ItemInfo[] userBagByType = playerBussiness.GetUserBagByType(m_player.PlayerCharacter.ID, base.BagType);
			string text = LanguageMgr.GetTranslation("LoadFromDb.ErrorItem") + " ";
			int num = 0;
			BeginChanges();
			try
			{
				ItemInfo[] array = userBagByType;
				foreach (ItemInfo ıtemInfo in array)
				{
					if (ıtemInfo.Template == null)
					{
						text = text + ıtemInfo.TemplateID + ",";
						num++;
					}
					else if (base.BagType == 0 && ıtemInfo.Place > 31 && ıtemInfo.isDress())
					{
						if (ıtemInfo.Place < 80)
						{
							ıtemInfo.Place = m_player.AvatarBag.FindFirstEmptySlot();
						}
						m_player.AvatarBag.AddItemTo(ıtemInfo, ıtemInfo.Place);
					}
					else
					{
						AddItemTo(ıtemInfo, ıtemInfo.Place);
					}
				}
			}
			finally
			{
				if (num > 0)
				{
					m_player.SendMailToUser(playerBussiness, text, LanguageMgr.GetTranslation("LoadFromDb.ErrorItem"), eMailType.Active);
				}
				CommitChanges();
			}
		}

		public virtual void SaveToDatabase()
		{
			if (!bool_1)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			lock (m_lock)
			{
				for (int i = 0; i < m_items.Length; i++)
				{
					ItemInfo ıtemInfo = m_items[i];
					if (ıtemInfo != null && ıtemInfo.IsDirty)
					{
						if (ıtemInfo.ItemID > 0)
						{
							playerBussiness.UpdateGoods(ıtemInfo);
						}
						else
						{
							playerBussiness.AddGoods(ıtemInfo);
						}
					}
				}
			}
			lock (list_0)
			{
				foreach (ItemInfo item in list_0)
				{
					if (item.ItemID > 0)
					{
						playerBussiness.UpdateGoods(item);
					}
				}
				list_0.Clear();
			}
		}

		public virtual void SaveNewItemToDatabase()
		{
			if (!bool_1)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			lock (m_lock)
			{
				for (int i = 0; i < m_items.Length; i++)
				{
					ItemInfo ıtemInfo = m_items[i];
					if (ıtemInfo != null && ıtemInfo.IsDirty && ıtemInfo.ItemID == 0)
					{
						playerBussiness.AddGoods(ıtemInfo);
					}
				}
			}
		}

		public int FindItemEpuipSlot(ItemTemplateInfo item)
		{
			switch (item.CategoryID)
			{
			case 13:
				return 11;
			case 14:
				return 12;
			case 15:
				return 13;
			case 16:
				return 14;
			case 17:
				return 15;
			case 27:
				return 6;
			case 31:
				return 15;
			case 40:
				return 17;
			case 8:
			case 28:
				if (m_items[7] == null)
				{
					return 7;
				}
				return 8;
			case 9:
			case 29:
				if (m_items[9] == null)
				{
					return 9;
				}
				return 10;
			default:
				return item.CategoryID - 1;
			}
		}

		public bool CanEquipSlotContains(int slot, ItemTemplateInfo temp)
		{
			if (temp.CategoryID != 8 && temp.CategoryID != 28)
			{
				if (temp.CategoryID != 9 && temp.CategoryID != 29)
				{
					if (temp.CategoryID == 13)
					{
						return slot == 11;
					}
					if (temp.CategoryID == 14)
					{
						return slot == 12;
					}
					if (temp.CategoryID == 15)
					{
						return slot == 13;
					}
					if (temp.CategoryID == 16)
					{
						return slot == 14;
					}
					if (temp.CategoryID != 17 && temp.CategoryID != 31)
					{
						if (temp.CategoryID == 27)
						{
							return slot == 6;
						}
						if (temp.CategoryID == 40)
						{
							return slot == 17;
						}
						return temp.CategoryID - 1 == slot;
					}
					return slot == 15;
				}
				if (Equip.isWeddingRing(temp))
				{
					return slot == 9 || slot == 10 || slot == 16;
				}
				return slot == 9 || slot == 10;
			}
			return slot == 7 || slot == 8;
		}

		public bool IsEquipSlot(int slot)
		{
			return slot >= 0 && slot < base.BeginSlot;
		}

		public List<ItemInfo> GetAllPetEquipByPetID(int petID)
		{
			List<ItemInfo> list = new List<ItemInfo>();
			lock (m_lock)
			{
				for (int i = 0; i < base.Capalility; i++)
				{
					ItemInfo ıtemInfo = m_items[i];
					if (ıtemInfo != null && ıtemInfo.Bless == petID)
					{
						list.Add(ıtemInfo);
					}
				}
			}
			return list;
		}

		public void ClearPetEquipByPetID(int petID)
		{
			lock (m_lock)
			{
				for (int i = 0; i < base.Capalility; i++)
				{
					ItemInfo ıtemInfo = m_items[i];
					if (ıtemInfo != null && ıtemInfo.Bless == petID)
					{
						ItemInfo item = ıtemInfo.Clone();
						if (m_player.EquipBag.AddItem(item))
						{
							TakeOutItem(ıtemInfo);
						}
					}
				}
			}
		}

		public ItemInfo GetPetEquipByPetID(int petID, int place)
		{
			lock (m_lock)
			{
				for (int i = 0; i < base.Capalility; i++)
				{
					if (m_items[i] != null && m_items[i].Bless == petID && place == m_items[i].eqType())
					{
						return m_items[i];
					}
				}
			}
			return null;
		}

		public override bool AddItemTo(ItemInfo item, int place)
		{
			if (base.AddItemTo(item, place))
			{
				item.UserID = m_player.PlayerCharacter.ID;
				item.IsExist = true;
				return true;
			}
			return false;
		}

		public override ItemInfo GetItemAt(int slot)
		{
			if (base.BagType == 0 && slot > base.Capalility - 1)
			{
				return m_player.AvatarBag.GetAvatarAt(slot);
			}
			return base.GetItemAt(slot);
		}

		public override bool TakeOutItem(ItemInfo item)
		{
			if (base.TakeOutItem(item))
			{
				if (bool_1)
				{
					lock (list_0)
					{
						list_0.Add(item);
					}
				}
				return true;
			}
			return false;
		}

		public override bool RemoveItem(ItemInfo item)
		{
			if (base.RemoveItem(item))
			{
				item.IsExist = false;
				if (bool_1)
				{
					lock (list_0)
					{
						list_0.Add(item);
					}
				}
				return true;
			}
			return false;
		}

		public override void UpdateChangedPlaces()
		{
			int[] updatedSlots = m_changedPlaces.ToArray();
			if (base.BagType != 5012)
			{
				m_player.Out.SendUpdateInventorySlot(this, updatedSlots);
			}
			base.UpdateChangedPlaces();
		}

		public bool SendAllItemsToMail(string sender, string title, eMailType type)
		{
			if (bool_1)
			{
				BeginChanges();
				try
				{
					using PlayerBussiness pb = new PlayerBussiness();
					lock (m_lock)
					{
						List<ItemInfo> ıtems = GetItems();
						int count = ıtems.Count;
						for (int i = 0; i < count; i += 5)
						{
							MailInfo mailInfo = new MailInfo();
							mailInfo.SenderID = 0;
							mailInfo.Sender = sender;
							mailInfo.ReceiverID = m_player.PlayerCharacter.ID;
							mailInfo.Receiver = m_player.PlayerCharacter.NickName;
							mailInfo.Title = title;
							mailInfo.Type = (int)type;
							mailInfo.Content = "";
							List<ItemInfo> list = new List<ItemInfo>();
							for (int j = 0; j < 5; j++)
							{
								int num = i * 5 + j;
								if (num < ıtems.Count)
								{
									list.Add(ıtems[num]);
								}
							}
							if (!SendItemsToMail(list, mailInfo, pb))
							{
								return false;
							}
						}
					}
				}
				catch (Exception ex)
				{
					Console.WriteLine("Send Items Mail Error:" + ex);
				}
				finally
				{
					SaveNewItemToDatabase();
					CommitChanges();
				}
				m_player.Out.SendMailResponse(m_player.PlayerCharacter.ID, eMailRespose.Receiver);
				return true;
			}
			return true;
		}

		public bool SendItemsToMail(List<ItemInfo> items, MailInfo mail, PlayerBussiness pb)
		{
			if (mail == null)
			{
				return false;
			}
			if (items.Count > 5)
			{
				return false;
			}
			if (bool_1)
			{
				List<ItemInfo> list = new List<ItemInfo>();
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(LanguageMgr.GetTranslation("Game.Server.GameUtils.CommonBag.AnnexRemark"));
				if (items.Count > 0 && TakeOutItem(items[0]))
				{
					ItemInfo ıtemInfo = items[0];
					mail.Annex1 = ıtemInfo.ItemID.ToString();
					mail.String_0 = ıtemInfo.Template.Name;
					stringBuilder.Append("1、" + mail.String_0 + "x" + ıtemInfo.Count + ";");
					list.Add(ıtemInfo);
				}
				if (items.Count > 1 && TakeOutItem(items[1]))
				{
					ItemInfo ıtemInfo2 = items[1];
					mail.Annex2 = ıtemInfo2.ItemID.ToString();
					mail.String_1 = ıtemInfo2.Template.Name;
					stringBuilder.Append("2、" + mail.String_1 + "x" + ıtemInfo2.Count + ";");
					list.Add(ıtemInfo2);
				}
				if (items.Count > 2 && TakeOutItem(items[2]))
				{
					ItemInfo ıtemInfo3 = items[2];
					mail.Annex3 = ıtemInfo3.ItemID.ToString();
					mail.String_2 = ıtemInfo3.Template.Name;
					stringBuilder.Append("3、" + mail.String_2 + "x" + ıtemInfo3.Count + ";");
					list.Add(ıtemInfo3);
				}
				if (items.Count > 3 && TakeOutItem(items[3]))
				{
					ItemInfo ıtemInfo4 = items[3];
					mail.Annex4 = ıtemInfo4.ItemID.ToString();
					mail.String_3 = ıtemInfo4.Template.Name;
					stringBuilder.Append("4、" + mail.String_3 + "x" + ıtemInfo4.Count + ";");
					list.Add(ıtemInfo4);
				}
				if (items.Count > 4 && TakeOutItem(items[4]))
				{
					ItemInfo ıtemInfo5 = items[4];
					mail.Annex5 = ıtemInfo5.ItemID.ToString();
					mail.String_4 = ıtemInfo5.Template.Name;
					stringBuilder.Append("5、" + mail.String_4 + "x" + ıtemInfo5.Count + ";");
					list.Add(ıtemInfo5);
				}
				mail.AnnexRemark = stringBuilder.ToString();
				if (pb.SendMail(mail))
				{
					return true;
				}
				foreach (ItemInfo item in list)
				{
					AddItem(item);
				}
			}
			return false;
		}
	}
}
