using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(259, "场景用户离开")]
	public class ConsumeRankHandlerHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			return 0;
		}
	}
}
