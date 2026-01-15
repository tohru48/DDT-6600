using Bussiness;
using Game.Base.Packets;
using Game.Server.GameUtils;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(127, "物品比较")]
	public class ItemReclaimHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			eBageType eBageType = (eBageType)packet.ReadByte();
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			PlayerInventory playerInventory = client.Player.GetInventory(eBageType);
			ItemInfo ıtemAt = playerInventory.GetItemAt(num);
			if (playerInventory != null && ıtemAt != null)
			{
				if (eBageType == eBageType.EquipBag && ıtemAt.isDress() && num > playerInventory.Capalility - 1)
				{
					playerInventory = client.Player.AvatarBag;
				}
				if (playerInventory.GetItemAt(num).Count <= num2)
				{
					num2 = playerInventory.GetItemAt(num).Count;
				}
				int num3 = num2 * ıtemAt.Template.ReclaimValue;
				if (ıtemAt.Template.ReclaimType == 2)
				{
					client.Player.AddGiftToken(num3);
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemReclaimHandler.Success1", num3));
				}
				if (ıtemAt.Template.ReclaimType == 1)
				{
					client.Player.AddGold(num3);
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemReclaimHandler.Success2", num3));
				}
				playerInventory.RemoveItemAt(num);
				return 0;
			}
			client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemReclaimHandler.NoSuccess"));
			return 1;
		}
	}
}
