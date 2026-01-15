using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(261, "场景用户离开")]
	public class CollectionTaskHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.CollectionTaskHandler != null)
			{
				client.Player.CollectionTaskHandler.ProcessData(client.Player, packet);
			}
			return 0;
		}
	}
}
