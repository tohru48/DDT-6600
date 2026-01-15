using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(279, "场景用户离开")]
	public class ShowHideTitleStateHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			packet.ReadBoolean();
			return 0;
		}
	}
}
