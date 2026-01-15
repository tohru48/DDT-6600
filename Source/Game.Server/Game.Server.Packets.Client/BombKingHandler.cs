using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(263, "场景用户离开")]
	public class BombKingHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.BombKingHandler != null)
			{
				client.Player.BombKingHandler.ProcessData(client.Player, packet);
			}
			return 0;
		}
	}
}
