using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(262, "场景用户离开")]
	public class NewHallHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.NewHallHandler != null)
			{
				client.Player.NewHallHandler.ProcessData(client.Player, packet);
			}
			return 0;
		}
	}
}
