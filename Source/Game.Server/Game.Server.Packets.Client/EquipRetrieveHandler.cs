using System;
using System.Collections.Generic;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameUtils;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(222, "场景用户离开")]
	public class EquipRetrieveHandler : IPacketHandler
	{
		private Random random_0;

		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int user = 0;
			PlayerInventory ınventory = client.Player.GetInventory(eBageType.Store);
			int num = 0;
			bool ısBinds = false;
			for (int i = 1; i < 5; i++)
			{
				ItemInfo ıtemAt = ınventory.GetItemAt(i);
				if (ıtemAt != null)
				{
					ınventory.RemoveItemAt(i);
				}
				if (ıtemAt.IsBinds)
				{
					ısBinds = true;
				}
				num += ıtemAt.Template.Quality;
			}
			int num2 = num;
			if (num2 <= 12)
			{
				if (num2 == 8 || num2 == 12)
				{
					goto IL_00b4;
				}
			}
			else if (num2 == 15 || num2 == 20)
			{
				goto IL_00b4;
			}
			goto IL_00b6;
			IL_00b4:
			user = num;
			goto IL_00b6;
			IL_00b6:
			List<ItemInfo> info = null;
			DropInventory.RetrieveDrop(user, ref info);
			int index = random_0.Next(info.Count);
			int templateID = info[index].TemplateID;
			ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(templateID), 1, 105);
			ıtemInfo.IsBinds = ısBinds;
			ıtemInfo.BeginDate = DateTime.Now;
			if (ıtemInfo.Template.CategoryID != 11)
			{
				ıtemInfo.ValidDate = 30;
				ıtemInfo.IsBinds = true;
			}
			ıtemInfo.IsBinds = true;
			ınventory.AddItemTo(ıtemInfo, 0);
			return 1;
		}

		public EquipRetrieveHandler()
		{
			random_0 = new Random();
		}
	}
}
