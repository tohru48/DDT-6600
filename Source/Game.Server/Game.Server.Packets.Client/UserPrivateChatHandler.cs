using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(37, "用户与用户之间的聊天")]
	public class UserPrivateChatHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			GameServer.Instance.LoginServer.SendPacket(packet);
			return 1;
		}
	}
}
