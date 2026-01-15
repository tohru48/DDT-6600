using Bussiness;
using Game.Base.Packets;
using Game.Server.GameUtils;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(77, "物品过期")]
	public class ItemOverdueHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.CurrentRoom != null && client.Player.CurrentRoom.IsPlaying)
			{
				return 0;
			}
			int num = packet.ReadByte();
			int num2 = packet.ReadInt();
			PlayerInventory ınventory = client.Player.GetInventory((eBageType)num);
			ItemInfo ıtemAt = ınventory.GetItemAt(num2);
			if (ıtemAt != null && !ıtemAt.IsValidItem())
			{
				if (num == 0 && num2 < 30)
				{
					int num3 = ınventory.FindFirstEmptySlot();
					if (num3 == -1 || !ınventory.MoveItem(ıtemAt.Place, num3, ıtemAt.Count))
					{
						client.Player.SendItemToMail(ıtemAt, LanguageMgr.GetTranslation("ItemOverdueHandler.Content"), LanguageMgr.GetTranslation("ItemOverdueHandler.Title"), eMailType.ItemOverdue);
						client.Player.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
					}
				}
				else
				{
					ınventory.UpdateItem(ıtemAt);
				}
			}
			return 0;
		}
	}
}
