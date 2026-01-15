using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(55, "出售道具")]
	public class PropSellHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int slot = packet.ReadInt();
			int ıD = packet.ReadInt();
			ItemInfo ıtemAt = client.Player.FightBag.GetItemAt(slot);
			if (ıtemAt != null)
			{
				client.Player.FightBag.RemoveItem(ıtemAt);
				SpecialItemBoxInfo specialValue = new SpecialItemBoxInfo();
				ShopItemInfo shopItemInfoById = ShopMgr.GetShopItemInfoById(ıD);
				ShopMgr.SetItemType(shopItemInfoById, 1, ref specialValue);
				client.Player.AddGold(specialValue.Gold);
			}
			return 0;
		}
	}
}
