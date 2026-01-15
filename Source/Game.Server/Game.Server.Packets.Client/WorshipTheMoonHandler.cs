using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(281, "客户端日记")]
	public class WorshipTheMoonHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.WorshipTheMoonHandler != null)
			{
				client.Player.WorshipTheMoonHandler.ProcessData(client.Player, packet);
			}
			return 0;
		}
	}
}
