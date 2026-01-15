using System;
using System.Collections.Generic;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameUtils;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(237, "场景用户离开")]
	public class PlayerDressHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadByte();
			GSPacketIn gSPacketIn = new GSPacketIn(237, client.Player.PlayerCharacter.ID);
			switch (num)
			{
			case 1:
			{
				PlayerInventory equipBag2 = client.Player.EquipBag;
				List<ItemInfo> list3 = new List<ItemInfo>();
				int slot2 = packet.ReadInt();
				int num4 = packet.ReadInt();
				int j = 0;
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					for (; j < num4; j++)
					{
						int num5 = packet.ReadInt();
						int slot3 = packet.ReadInt();
						ItemInfo ıtemAt3 = equipBag2.GetItemAt(slot3);
						if (ıtemAt3 != null && ıtemAt3.BagType == num5)
						{
							if (ıtemAt3.ItemID == 0)
							{
								playerBussiness.AddGoods(ıtemAt3);
							}
							client.Player.AvatarBag.DressEquip(ıtemAt3.Place);
							list3.Add(ıtemAt3);
						}
					}
				}
				if (list3.Count > 0)
				{
					client.Player.AvatarBag.SaveDressModel(slot2, list3);
					client.Player.AvatarBag.UpdateCurrentDressModels();
					client.Player.AvatarBag.UpdateChangedPlaces();
					return 0;
				}
				return 0;
			}
			case 2:
			{
				int currentModel = packet.ReadInt();
				client.Player.AvatarBag.SetCurrentModel(currentModel);
				return 0;
			}
			case 6:
			{
				PlayerInventory equipBag = client.Player.EquipBag;
				List<int> list = new List<int>();
				List<ItemInfo> list2 = new List<ItemInfo>();
				int num2 = packet.ReadInt();
				for (int i = 0; i < num2; i++)
				{
					packet.ReadInt();
					int slot = packet.ReadInt();
					packet.ReadInt();
					int num3 = packet.ReadInt();
					ItemInfo ıtemAt = equipBag.GetItemAt(slot);
					ItemInfo ıtemAt2 = equipBag.GetItemAt(num3);
					if (ıtemAt == null || ıtemAt2 == null || ıtemAt.TemplateID != ıtemAt2.TemplateID)
					{
						continue;
					}
					if (ıtemAt.ValidDate > 0 && ıtemAt2.IsValidItem())
					{
						if (!ıtemAt.IsValidItem())
						{
							ıtemAt.BeginDate = ıtemAt2.BeginDate;
						}
						ıtemAt.ValidDate += ıtemAt2.ValidDate;
						ıtemAt.ValidDate = ((ıtemAt.ValidDate > 365) ? 365 : ıtemAt.ValidDate);
					}
					list2.Add(ıtemAt);
					list.Add(num3);
				}
				equipBag.AllUpdateItem(list2);
				client.Player.AvatarBag.RemoveAllItem(list);
				return 0;
			}
			case 7:
				gSPacketIn.WriteByte(7);
				client.Player.SendTCP(gSPacketIn);
				return 0;
			default:
				Console.WriteLine("activeSystem_cmd:{0} ", (PlayerDressType)num);
				return 0;
			}
		}
	}
}
