using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(47, "解除物品")]
	public class UserUnchainItemHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.CurrentRoom != null && client.Player.CurrentRoom.IsPlaying)
			{
				return 0;
			}
			int fromSlot = packet.ReadInt();
			int beginSlot = client.Player.EquipBag.BeginSlot;
			int toSlot = client.Player.EquipBag.FindFirstEmptySlot(beginSlot);
			client.Player.EquipBag.MoveItem(fromSlot, toSlot, 0);
			return 0;
		}
	}
}
