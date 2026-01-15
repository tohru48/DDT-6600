using System.Collections.Generic;
using System.Text;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameUtils;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(120, "物品倾向转移")]
	public class ItemTrendHandle : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			eBageType bagType = (eBageType)packet.ReadInt();
			int place = packet.ReadInt();
			eBageType bagType2 = (eBageType)packet.ReadInt();
			List<ShopItemInfo> list = new List<ShopItemInfo>();
			int num = packet.ReadInt();
			int operation = packet.ReadInt();
			ItemInfo ıtemInfo;
			if (num == -1)
			{
				packet.ReadInt();
				packet.ReadInt();
				int num2 = 0;
				int num3 = 0;
				ItemTemplateInfo goods = ItemMgr.FindItemTemplate(34101);
				ıtemInfo = ItemInfo.CreateFromTemplate(goods, 1, 102);
				list = ShopMgr.FindShopbyTemplatID(34101);
				for (int i = 0; i < list.Count; i++)
				{
					if (list[i].APrice1 == -1 && list[i].AValue1 != 0)
					{
						num3 = list[i].AValue1;
						ıtemInfo.ValidDate = list[i].AUnit;
					}
				}
				if (ıtemInfo != null)
				{
					if (num2 <= client.Player.PlayerCharacter.Gold && num3 <= client.Player.PlayerCharacter.Money)
					{
						client.Player.RemoveMoney(num3);
						client.Player.RemoveGold(num2);
					}
					else
					{
						ıtemInfo = null;
					}
				}
			}
			else
			{
				ıtemInfo = client.Player.GetItemAt(bagType2, num);
			}
			ItemInfo ıtemAt = client.Player.GetItemAt(bagType, place);
			StringBuilder stringBuilder = new StringBuilder();
			if (ıtemInfo == null || ıtemAt == null)
			{
				return 1;
			}
			bool result = false;
			ItemTemplateInfo ıtemTemplateInfo = RefineryMgr.RefineryTrend(operation, ıtemAt, ref result);
			if (result && ıtemTemplateInfo != null)
			{
				ItemInfo ıtemInfo2 = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 115);
				AbstractInventory ıtemInventory = client.Player.GetItemInventory(ıtemTemplateInfo);
				if (ıtemInventory.AddItem(ıtemInfo2, ıtemInventory.BeginSlot))
				{
					client.Player.UpdateItem(ıtemInfo2);
					client.Player.RemoveItem(ıtemAt);
					ıtemInfo.Count--;
					client.Player.UpdateItem(ıtemInfo);
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemTrendHandle.Success"));
				}
				else
				{
					stringBuilder.Append("NoPlace");
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation(ıtemInfo2.GetBagName()) + LanguageMgr.GetTranslation("ItemFusionHandler.NoPlace"));
				}
				return 1;
			}
			client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemTrendHandle.Fail"));
			return 1;
		}
	}
}
