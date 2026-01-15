using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(405, "场景用户离开")]
	public class WonderfulActivityInitHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int val = packet.ReadInt();
			GSPacketIn gSPacketIn = new GSPacketIn(405, client.Player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(val);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteString("4ac24166-267e-99fa-b875-824323d1ad83");
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteString("03ff7e54-2af1-3f8a-6543-051a4116c4c2");
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(8);
			client.Player.SendTCP(gSPacketIn);
			return 0;
		}
	}
}
