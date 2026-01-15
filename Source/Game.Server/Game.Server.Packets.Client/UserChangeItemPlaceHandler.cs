using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameUtils;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(49, "改变物品位置")]
	public class UserChangeItemPlaceHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			eBageType eBageType = (eBageType)packet.ReadByte();
			int num = packet.ReadInt();
			eBageType eBageType2 = (eBageType)packet.ReadByte();
			int num2 = packet.ReadInt();
			int num3 = packet.ReadInt();
			packet.ReadBoolean();
			PlayerInventory playerInventory = client.Player.GetInventory(eBageType);
			PlayerInventory playerInventory2 = client.Player.GetInventory(eBageType2);
			ItemInfo ıtemAt = playerInventory.GetItemAt(num);
			if (playerInventory == null || ıtemAt == null)
			{
				Console.WriteLine("User change item place but item not found!");
				return 0;
			}
			if (num3 >= 0 && num3 <= ıtemAt.Count && num3 <= ıtemAt.Template.MaxCount)
			{
				if (eBageType == eBageType.EquipBag && ıtemAt.isDress() && num > playerInventory.Capalility - 1)
				{
					playerInventory = client.Player.AvatarBag;
				}
				if (eBageType2 == eBageType.EquipBag && ıtemAt.isDress())
				{
					playerInventory2 = client.Player.AvatarBag;
				}
				if (eBageType2 == eBageType.Consortia)
				{
					ConsortiaInfo consortiaInfo = ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
					if (consortiaInfo != null)
					{
						playerInventory2.Capalility = consortiaInfo.StoreLevel * 10;
					}
				}
				if (eBageType2 == eBageType.MagicHouseBag)
				{
					UsersMagicHouseInfo ınfo = client.Player.MagicHouse.Info;
					if (ınfo != null)
					{
						playerInventory2.Capalility = ınfo.depotCount;
					}
				}
				if (num2 == -1)
				{
					bool flag = false;
					if (eBageType == eBageType.CaddyBag && eBageType2 == eBageType.BeadBag)
					{
						num2 = playerInventory2.FindFirstEmptySlot();
						if (playerInventory2.AddItemTo(ıtemAt, num2))
						{
							playerInventory.TakeOutItem(ıtemAt);
						}
						else
						{
							flag = true;
						}
					}
					else if (eBageType == eBageType2 && eBageType2 == eBageType.EquipBag)
					{
						if (ıtemAt.isDress())
						{
							num2 = playerInventory2.FindFirstEmptySlot();
							ItemInfo item = ıtemAt.Clone();
							if (playerInventory2.AddItemTo(item, num2))
							{
								playerInventory.TakeOutItem(ıtemAt);
							}
							else
							{
								flag = true;
							}
						}
						else
						{
							num2 = playerInventory2.FindFirstEmptySlot();
							if (!playerInventory.MoveItem(num, num2, num3))
							{
								flag = true;
							}
						}
					}
					else if (!playerInventory2.StackItemToAnother(ıtemAt) && !playerInventory2.AddItem(ıtemAt))
					{
						flag = true;
					}
					else
					{
						playerInventory.TakeOutItem(ıtemAt);
					}
					if (flag)
					{
						client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"));
						return 0;
					}
				}
				else if (eBageType == eBageType2)
				{
					if (eBageType2 == eBageType.EquipBag && num2 < playerInventory.BeginSlot)
					{
						ıtemAt.IsBinds = true;
					}
					if (ıtemAt.isDress())
					{
						switch (eBageType)
						{
						case eBageType.Consortia:
						{
							ItemInfo ıtemAt2 = playerInventory.GetItemAt(num2);
							if (ıtemAt2 != null && num2 >= playerInventory.BeginSlot)
							{
								num2 = playerInventory.FindFirstEmptySlot();
								playerInventory.MoveItem(num, num2, num3);
							}
							else
							{
								playerInventory.MoveItem(num, num2, num3);
							}
							break;
						}
						case eBageType.EquipBag:
							if (num > 79 && num2 < 31)
							{
								playerInventory2 = client.Player.EquipBag;
								int num4 = playerInventory2.FindItemEpuipSlot(ıtemAt.Template);
								if (num4 != num2)
								{
									num2 = num4;
								}
								smethod_0(num, num2, playerInventory, playerInventory2, ıtemAt);
							}
							break;
						}
					}
					else
					{
						ItemInfo ıtemAt3 = playerInventory.GetItemAt(num2);
						if (ıtemAt3 != null && num2 >= playerInventory.BeginSlot)
						{
							num2 = playerInventory.FindFirstEmptySlot();
							playerInventory.MoveItem(num, num2, num3);
						}
						else
						{
							playerInventory.MoveItem(num, num2, num3);
						}
					}
					client.Player.OnNewGearEvent(ıtemAt.Template.CategoryID);
				}
				else
				{
					switch (eBageType)
					{
					case eBageType.Store:
						MoveFromStore(client, playerInventory, ıtemAt, num2, playerInventory2, num3);
						break;
					case eBageType.Consortia:
					{
						ItemInfo ıtemAt7 = playerInventory2.GetItemAt(num2);
						if (ıtemAt7 != null)
						{
							num2 = playerInventory2.FindFirstEmptySlot(playerInventory2.BeginSlot);
							smethod_2(client, num, num2, playerInventory, playerInventory2, ıtemAt);
							break;
						}
						if (eBageType2 == eBageType.EquipBag && num2 < playerInventory2.BeginSlot)
						{
							num2 = playerInventory2.FindFirstEmptySlot(playerInventory2.BeginSlot);
						}
						smethod_2(client, num, num2, playerInventory, playerInventory2, ıtemAt);
						break;
					}
					case eBageType.MagicHouseBag:
					{
						ItemInfo ıtemAt6 = playerInventory2.GetItemAt(num2);
						if (ıtemAt6 != null)
						{
							num2 = playerInventory2.FindFirstEmptySlot(playerInventory2.BeginSlot);
							smethod_4(client, num, num2, playerInventory, playerInventory2, ıtemAt);
							break;
						}
						if (eBageType2 == eBageType.EquipBag && num2 < playerInventory2.BeginSlot)
						{
							num2 = playerInventory2.FindFirstEmptySlot(playerInventory2.BeginSlot);
						}
						smethod_4(client, num, num2, playerInventory, playerInventory2, ıtemAt);
						break;
					}
					default:
						switch (eBageType2)
						{
						case eBageType.Store:
							if (ıtemAt.IsAdvanceDate())
							{
								ıtemAt.StrengthenExp = 0;
								ıtemAt.AdvanceDate = DateTime.Now;
							}
							MoveToStore(client, playerInventory, ıtemAt, num2, playerInventory2, num3);
							break;
						case eBageType.Consortia:
						{
							ItemInfo ıtemAt5 = playerInventory2.GetItemAt(num2);
							if (ıtemAt5 != null)
							{
								num2 = playerInventory2.FindFirstEmptySlot();
								smethod_1(num, num2, playerInventory, playerInventory2, ıtemAt);
							}
							else
							{
								smethod_1(num, num2, playerInventory, playerInventory2, ıtemAt);
							}
							break;
						}
						case eBageType.MagicHouseBag:
						{
							if (num2 > playerInventory2.Capalility)
							{
								client.Player.SendMessage(LanguageMgr.GetTranslation("MagicHouse.Full"));
								break;
							}
							ItemInfo ıtemAt4 = playerInventory2.GetItemAt(num2);
							if (ıtemAt4 != null)
							{
								num2 = playerInventory2.FindFirstEmptySlot();
								smethod_3(num, num2, playerInventory, playerInventory2, ıtemAt);
							}
							else
							{
								smethod_3(num, num2, playerInventory, playerInventory2, ıtemAt);
							}
							break;
						}
						default:
							if (playerInventory2.AddItemTo(ıtemAt, num2))
							{
								playerInventory.TakeOutItem(ıtemAt);
								Console.WriteLine("User: {1} Add item to: {0}", playerInventory2.BagType, client.Player.PlayerCharacter.UserName);
							}
							break;
						}
						break;
					}
				}
				return 0;
			}
			client.Disconnect();
			return 0;
		}

		private static void smethod_0(int int_0, int int_1, PlayerInventory playerInventory_0, PlayerInventory playerInventory_1, ItemInfo itemInfo_0)
		{
			if (playerInventory_0 != null && itemInfo_0 != null && playerInventory_0 != null)
			{
				ItemInfo ıtemAt = playerInventory_1.GetItemAt(int_1);
				ItemInfo item = itemInfo_0.Clone();
				if (ıtemAt != null)
				{
					playerInventory_0.TakeOutItem(itemInfo_0);
					playerInventory_1.TakeOutItem(ıtemAt);
					playerInventory_0.AddItemTo(ıtemAt, int_0);
					playerInventory_1.AddItemTo(itemInfo_0, int_1);
				}
				else if (playerInventory_1.AddItemTo(item, int_1))
				{
					playerInventory_0.TakeOutItem(itemInfo_0);
				}
			}
		}

		public void MoveFromStore(GameClient client, PlayerInventory storeBag, ItemInfo item, int toSlot, PlayerInventory bag, int count)
		{
			if (client.Player == null || item == null || storeBag == null || bag == null || item.Template.BagType != (eBageType)bag.BagType)
			{
				return;
			}
			if (toSlot < bag.BeginSlot || toSlot > bag.Capalility)
			{
				if (bag.StackItemToAnother(item))
				{
					storeBag.RemoveItem(item, eItemRemoveType.Stack);
					return;
				}
				toSlot = bag.FindFirstEmptySlot();
			}
			if (bag.StackItemToAnother(item) || bag.AddItemTo(item, toSlot))
			{
				storeBag.TakeOutItem(item);
				return;
			}
			toSlot = bag.FindFirstEmptySlot();
			if (bag.AddItemTo(item, toSlot))
			{
				storeBag.TakeOutItem(item);
				return;
			}
			ItemInfo item2 = item.Clone();
			storeBag.RemoveItem(item);
			client.Player.SendItemToMail(item2, LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"), LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"), eMailType.ItemOverdue);
			client.Player.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
		}

		public void MoveToStore(GameClient client, PlayerInventory bag, ItemInfo item, int toSlot, PlayerInventory storeBag, int count)
		{
			if (client.Player == null || bag == null || item == null || storeBag == null)
			{
				return;
			}
			int place = item.Place;
			ItemInfo ıtemAt = storeBag.GetItemAt(toSlot);
			if (ıtemAt != null)
			{
				if (item.Count == 1 && item.BagType == ıtemAt.BagType)
				{
					bag.TakeOutItem(item);
					storeBag.TakeOutItem(ıtemAt);
					bag.AddItemTo(ıtemAt, place);
					storeBag.AddItemTo(item, toSlot);
				}
				else
				{
					PlayerInventory playerInventory = client.Player.GetItemInventory(ıtemAt.Template);
					if (playerInventory.BagType == 0)
					{
						if (ıtemAt.isDress())
						{
							playerInventory = client.Player.AvatarBag;
						}
						int place2 = playerInventory.FindFirstEmptySlot(playerInventory.BeginSlot);
						if (playerInventory.AddItemTo(ıtemAt, place2))
						{
							storeBag.TakeOutItem(ıtemAt);
						}
					}
					else if (playerInventory.StackItemToAnother(ıtemAt))
					{
						storeBag.RemoveItem(ıtemAt, eItemRemoveType.Stack);
					}
					else if (playerInventory.AddItem(ıtemAt))
					{
						storeBag.TakeOutItem(ıtemAt);
					}
					else
					{
						client.Player.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"));
					}
				}
			}
			if (!storeBag.IsEmpty(toSlot))
			{
				return;
			}
			if (item.Count == 1)
			{
				if (storeBag.AddItemTo(item, toSlot))
				{
					bag.TakeOutItem(item);
				}
				return;
			}
			ItemInfo ıtemInfo = item.Clone();
			ıtemInfo.Count = count;
			if (bag.RemoveCountFromStack(item, count, eItemRemoveType.Stack) && !storeBag.AddItemTo(ıtemInfo, toSlot))
			{
				bag.AddCountToStack(item, count);
			}
		}

		private static void smethod_1(int int_0, int int_1, PlayerInventory playerInventory_0, PlayerInventory playerInventory_1, ItemInfo itemInfo_0)
		{
			if (playerInventory_0 == null || itemInfo_0 == null || playerInventory_0 == null)
			{
				return;
			}
			ItemInfo ıtemAt = playerInventory_1.GetItemAt(int_1);
			if (ıtemAt != null)
			{
				if (itemInfo_0.CanStackedTo(ıtemAt) && itemInfo_0.Count + ıtemAt.Count <= itemInfo_0.Template.MaxCount)
				{
					if (playerInventory_1.AddCountToStack(ıtemAt, itemInfo_0.Count))
					{
						playerInventory_0.RemoveCountFromStack(itemInfo_0, itemInfo_0.Count);
					}
				}
				else if (ıtemAt.Template.BagType == (eBageType)playerInventory_0.BagType)
				{
					playerInventory_0.TakeOutItem(itemInfo_0);
					playerInventory_1.TakeOutItem(ıtemAt);
					playerInventory_0.AddItemTo(ıtemAt, int_0);
					playerInventory_1.AddItemTo(itemInfo_0, int_1);
				}
			}
			else if (playerInventory_1.AddItemTo(itemInfo_0, int_1))
			{
				playerInventory_0.TakeOutItem(itemInfo_0);
			}
		}

		private static void smethod_2(GameClient gameClient_0, int int_0, int int_1, PlayerInventory playerInventory_0, PlayerInventory playerInventory_1, ItemInfo itemInfo_0)
		{
			if (itemInfo_0 == null)
			{
				return;
			}
			PlayerInventory ıtemInventory = gameClient_0.Player.GetItemInventory(itemInfo_0.Template);
			if (ıtemInventory == playerInventory_1)
			{
				ItemInfo ıtemAt = ıtemInventory.GetItemAt(int_1);
				if (ıtemAt == null)
				{
					if (ıtemInventory.AddItemTo(itemInfo_0, int_1))
					{
						playerInventory_0.TakeOutItem(itemInfo_0);
					}
				}
				else if (!itemInfo_0.CanStackedTo(ıtemAt) || itemInfo_0.Count + ıtemAt.Count > itemInfo_0.Template.MaxCount)
				{
					ıtemInventory.TakeOutItem(ıtemAt);
					playerInventory_0.TakeOutItem(itemInfo_0);
					ıtemInventory.AddItemTo(itemInfo_0, int_1);
					playerInventory_0.AddItemTo(ıtemAt, int_0);
				}
				else if (ıtemInventory.AddCountToStack(ıtemAt, itemInfo_0.Count))
				{
					playerInventory_0.RemoveCountFromStack(itemInfo_0, itemInfo_0.Count);
				}
			}
			else if (ıtemInventory.AddItem(itemInfo_0))
			{
				playerInventory_0.TakeOutItem(itemInfo_0);
			}
		}

		private static void smethod_3(int int_0, int int_1, PlayerInventory playerInventory_0, PlayerInventory playerInventory_1, ItemInfo itemInfo_0)
		{
			if (playerInventory_0 == null || itemInfo_0 == null || playerInventory_0 == null)
			{
				return;
			}
			ItemInfo ıtemAt = playerInventory_1.GetItemAt(int_1);
			if (ıtemAt != null)
			{
				if (itemInfo_0.CanStackedTo(ıtemAt) && itemInfo_0.Count + ıtemAt.Count <= itemInfo_0.Template.MaxCount)
				{
					if (playerInventory_1.AddCountToStack(ıtemAt, itemInfo_0.Count))
					{
						playerInventory_0.RemoveCountFromStack(itemInfo_0, itemInfo_0.Count);
					}
				}
				else if (ıtemAt.Template.BagType == (eBageType)playerInventory_0.BagType)
				{
					playerInventory_0.TakeOutItem(itemInfo_0);
					playerInventory_1.TakeOutItem(ıtemAt);
					playerInventory_0.AddItemTo(ıtemAt, int_0);
					playerInventory_1.AddItemTo(itemInfo_0, int_1);
				}
			}
			else if (playerInventory_1.AddItemTo(itemInfo_0, int_1))
			{
				playerInventory_0.TakeOutItem(itemInfo_0);
			}
		}

		private static void smethod_4(GameClient gameClient_0, int int_0, int int_1, PlayerInventory playerInventory_0, PlayerInventory playerInventory_1, ItemInfo itemInfo_0)
		{
			if (itemInfo_0 == null)
			{
				return;
			}
			PlayerInventory ıtemInventory = gameClient_0.Player.GetItemInventory(itemInfo_0.Template);
			if (ıtemInventory == playerInventory_1)
			{
				ItemInfo ıtemAt = ıtemInventory.GetItemAt(int_1);
				if (ıtemAt == null)
				{
					if (ıtemInventory.AddItemTo(itemInfo_0, int_1))
					{
						playerInventory_0.TakeOutItem(itemInfo_0);
					}
				}
				else if (!itemInfo_0.CanStackedTo(ıtemAt) || itemInfo_0.Count + ıtemAt.Count > itemInfo_0.Template.MaxCount)
				{
					ıtemInventory.TakeOutItem(ıtemAt);
					playerInventory_0.TakeOutItem(itemInfo_0);
					ıtemInventory.AddItemTo(itemInfo_0, int_1);
					playerInventory_0.AddItemTo(ıtemAt, int_0);
				}
				else if (ıtemInventory.AddCountToStack(ıtemAt, itemInfo_0.Count))
				{
					playerInventory_0.RemoveCountFromStack(itemInfo_0, itemInfo_0.Count);
				}
			}
			else if (ıtemInventory.AddItem(itemInfo_0))
			{
				playerInventory_0.TakeOutItem(itemInfo_0);
			}
		}
	}
}
