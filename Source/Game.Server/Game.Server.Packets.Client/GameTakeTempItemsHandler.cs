using System.Collections.Generic;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(108, "选取")]
	public class GameTakeTempItemsHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			string string_ = string.Empty;
			int num = packet.ReadInt();
			if (num != -1)
			{
				ItemInfo ıtemAt = client.Player.TempBag.GetItemAt(num);
				method_0(client.Player, ıtemAt, ref string_);
			}
			else
			{
				List<ItemInfo> ıtems = client.Player.TempBag.GetItems();
				foreach (ItemInfo item in ıtems)
				{
					if (!method_0(client.Player, item, ref string_))
					{
						break;
					}
				}
			}
			if (!string.IsNullOrEmpty(string_))
			{
				client.Out.SendMessage(eMessageType.ERROR, string_);
			}
			return 0;
		}

		private bool method_0(GamePlayer gamePlayer_0, ItemInfo itemInfo_0, ref string string_0)
		{
			if (itemInfo_0 == null)
			{
				return false;
			}
			PlayerInventory ıtemInventory = gamePlayer_0.GetItemInventory(itemInfo_0.Template);
			if (ıtemInventory.AddItem(itemInfo_0))
			{
				gamePlayer_0.TempBag.RemoveItem(itemInfo_0);
				itemInfo_0.IsExist = true;
				return true;
			}
			ıtemInventory.UpdateChangedPlaces();
			string_0 = LanguageMgr.GetTranslation(itemInfo_0.GetBagName()) + LanguageMgr.GetTranslation("GameTakeTempItemsHandler.Msg");
			return false;
		}
	}
}
