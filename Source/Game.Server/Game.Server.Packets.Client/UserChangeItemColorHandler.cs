using System.Collections.Generic;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(182, "改变物品颜色")]
	public class UserChangeItemColorHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			eMessageType type = eMessageType.Normal;
			string translateId = "UserChangeItemColorHandler.Success";
			packet.ReadInt();
			int slot = packet.ReadInt();
			packet.ReadInt();
			int slot2 = packet.ReadInt();
			string text = packet.ReadString();
			string text2 = packet.ReadString();
			int num = packet.ReadInt();
			ItemInfo ıtemAt = client.Player.EquipBag.GetItemAt(slot2);
			ItemInfo ıtemAt2 = client.Player.PropBag.GetItemAt(slot);
			if (ıtemAt != null)
			{
				client.Player.BeginChanges();
				try
				{
					bool flag = false;
					if (ıtemAt2 != null && ıtemAt2.IsValidItem())
					{
						client.Player.PropBag.RemoveItem(ıtemAt2);
						flag = true;
					}
					else
					{
						ItemMgr.FindItemTemplate(num);
						List<ShopItemInfo> list = ShopMgr.FindShopbyTemplatID(num);
						int num2 = 0;
						for (int i = 0; i < list.Count; i++)
						{
							if (list[i].APrice1 == -1 && list[i].AValue1 != 0)
							{
								num2 = list[i].AValue1;
							}
						}
						if (num2 <= client.Player.PlayerCharacter.Money)
						{
							client.Player.RemoveMoney(num2);
							flag = true;
						}
					}
					if (flag)
					{
						ıtemAt.Color = ((text == null) ? "" : text);
						ıtemAt.Skin = ((text2 == null) ? "" : text2);
						client.Player.EquipBag.UpdateItem(ıtemAt);
					}
				}
				finally
				{
					client.Player.CommitChanges();
				}
			}
			client.Out.SendMessage(type, LanguageMgr.GetTranslation(translateId));
			return 0;
		}
	}
}
