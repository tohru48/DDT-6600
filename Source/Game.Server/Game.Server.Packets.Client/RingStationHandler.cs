using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(404, "场景用户离开")]
	public class RingStationHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.RingStationHandler != null)
			{
				client.Player.RingStationHandler.ProcessData(client.Player, packet);
			}
			return 0;
		}
	}
}
