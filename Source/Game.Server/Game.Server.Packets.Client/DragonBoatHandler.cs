using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(100, "客户端日记")]
	public class DragonBoatHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.DragonBoatHandler != null)
			{
				client.Player.DragonBoatHandler.ProcessData(client.Player, packet);
			}
			return 0;
		}
	}
}
