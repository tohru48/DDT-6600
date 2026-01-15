using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(159, "场景用户离开")]
	public class WonderfulActivityHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			packet.ReadInt();
			GSPacketIn gSPacketIn = new GSPacketIn(159, client.Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte((byte)num);
			gSPacketIn.WriteInt(0);
			client.Player.SendTCP(gSPacketIn);
			return 0;
		}
	}
}
