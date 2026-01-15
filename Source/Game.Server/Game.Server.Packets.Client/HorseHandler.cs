using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(260, "场景用户离开")]
	public class HorseHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.HorseHandler != null)
			{
				client.Player.HorseHandler.ProcessData(client.Player, packet);
			}
			return 0;
		}
	}
}
