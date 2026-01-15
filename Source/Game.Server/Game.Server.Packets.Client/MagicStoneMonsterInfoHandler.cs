using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(284, "场景用户离开")]
	public class MagicStoneMonsterInfoHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(284);
			gSPacketIn.WriteInt(client.Player.Extra.Info.NormalFightNum);
			gSPacketIn.WriteInt(client.Player.Extra.Info.HardFightNum);
			client.Player.SendTCP(gSPacketIn);
			return 0;
		}
	}
}
