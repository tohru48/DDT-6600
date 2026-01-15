using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(278, "场景用户离开")]
	public class GypsyShopHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.GypsyShopHandler != null)
			{
				client.Player.GypsyShopHandler.ProcessData(client.Player, packet);
			}
			return 0;
		}
	}
}
