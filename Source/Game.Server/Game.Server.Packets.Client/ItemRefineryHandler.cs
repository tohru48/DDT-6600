using System.Collections.Generic;
using System.Text;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameUtils;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(210, "物品炼化")]
	public class ItemRefineryHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(210, client.Player.PlayerCharacter.ID);
			bool flag = false;
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			List<ItemInfo> list = new List<ItemInfo>();
			new List<ItemInfo>();
			List<eBageType> list2 = new List<eBageType>();
			StringBuilder stringBuilder = new StringBuilder();
			int defaultprobability = 25;
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.locked"));
				return 1;
			}
			for (int i = 0; i < num2; i++)
			{
				eBageType eBageType = (eBageType)packet.ReadInt();
				int place = packet.ReadInt();
				ItemInfo ıtemAt = client.Player.GetItemAt(eBageType, place);
				if (ıtemAt != null)
				{
					if (list.Contains(ıtemAt))
					{
						client.Out.SendMessage(eMessageType.Normal, "Bad Input");
						return 1;
					}
					if (ıtemAt.IsBinds)
					{
						flag = true;
					}
					stringBuilder.Append(ıtemAt.ItemID + ":" + ıtemAt.TemplateID + ",");
					list.Add(ıtemAt);
					list2.Add(eBageType);
				}
			}
			eBageType bagType = (eBageType)packet.ReadInt();
			int place2 = packet.ReadInt();
			ItemInfo ıtemAt2 = client.Player.GetItemAt(bagType, place2);
			if (ıtemAt2 != null)
			{
				stringBuilder.Append(ıtemAt2.ItemID + ":" + ıtemAt2.TemplateID + ",");
			}
			eBageType bagType2 = (eBageType)packet.ReadInt();
			int place3 = packet.ReadInt();
			ItemInfo ıtemAt3 = client.Player.GetItemAt(bagType2, place3);
			bool flag2 = ıtemAt3 != null;
			if (num2 != 4 || ıtemAt2 == null)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemRefineryHandler.ItemNotEnough"));
				return 1;
			}
			bool result = false;
			bool IsFormula = false;
			if (num == 0)
			{
				ItemTemplateInfo ıtemTemplateInfo = RefineryMgr.Refinery(client.Player, list, ıtemAt2, flag2, num, ref result, ref defaultprobability, ref IsFormula);
				if (ıtemTemplateInfo != null)
				{
					client.Out.SendRefineryPreview(client.Player, ıtemTemplateInfo.TemplateID, flag, ıtemAt2);
				}
				return 0;
			}
			int value = 10000;
			if (client.Player.PlayerCharacter.Gold > 10000)
			{
				client.Player.RemoveGold(value);
				ItemTemplateInfo ıtemTemplateInfo2 = RefineryMgr.Refinery(client.Player, list, ıtemAt2, flag2, num, ref result, ref defaultprobability, ref IsFormula);
				if (ıtemTemplateInfo2 != null && IsFormula && result)
				{
					stringBuilder.Append("Success");
					result = true;
					ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo2, 1, 114);
					if (ıtemInfo != null)
					{
						client.Player.OnItemMelt(ıtemAt2.Template.CategoryID);
						ıtemInfo.IsBinds = flag;
						AbstractInventory ıtemInventory = client.Player.GetItemInventory(ıtemTemplateInfo2);
						if (!ıtemInventory.AddItem(ıtemInfo, ıtemInventory.BeginSlot))
						{
							stringBuilder.Append("NoPlace");
							client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation(ıtemInfo.GetBagName()) + LanguageMgr.GetTranslation("ItemFusionHandler.NoPlace"));
						}
						gSPacketIn.WriteByte(0);
						ıtemAt2.Count--;
						client.Player.UpdateItem(ıtemAt2);
					}
				}
				else
				{
					gSPacketIn.WriteByte(1);
				}
				if (flag2)
				{
					ıtemAt3.Count--;
					client.Player.UpdateItem(ıtemAt3);
				}
				for (int j = 0; j < list.Count; j++)
				{
					client.Player.UpdateItem(list[j]);
					if (list[j].Count <= 0)
					{
						client.Player.RemoveItem(list[j]);
					}
				}
				client.Player.RemoveItem(list[list.Count - 1]);
				client.Player.Out.SendTCP(gSPacketIn);
			}
			else
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemRefineryHandler.NoGold"));
			}
			return 1;
		}
	}
}
