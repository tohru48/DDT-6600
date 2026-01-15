using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(258, "场景用户离开")]
	public class MagicStoneHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.MagicStoneHandler != null)
			{
				client.Player.MagicStoneHandler.ProcessData(client.Player, packet);
			}
			return 0;
		}
	}
}
