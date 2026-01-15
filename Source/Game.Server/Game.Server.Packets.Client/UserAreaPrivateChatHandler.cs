using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(107, "用户与用户之间的聊天")]
	public class UserAreaPrivateChatHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			string str = packet.ReadString();
			string str2 = packet.ReadString();
			if (num != client.Player.ZoneId)
			{
				GSPacketIn gSPacketIn = new GSPacketIn(107);
				gSPacketIn.WriteInt(client.Player.ZoneId);
				gSPacketIn.WriteString(str);
				gSPacketIn.WriteString(str2);
				gSPacketIn.WriteString(client.Player.PlayerCharacter.NickName);
				GameServer.Instance.LoginCrossServer.SendPacket(gSPacketIn);
			}
			return 1;
		}
	}
}
