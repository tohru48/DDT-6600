using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(276, "场景用户离开")]
	public class MagpieBridgeHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.MagpieBridgeHandler != null)
			{
				client.Player.MagpieBridgeHandler.ProcessData(client.Player, packet);
			}
			return 0;
		}
	}
}
