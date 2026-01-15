using System;
using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(165, "场景用户离开")]
	public class LuckStoneEnableHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = packet.Clone();
			gSPacketIn.ClearContext();
			gSPacketIn.WriteDateTime(DateTime.Now);
			gSPacketIn.WriteDateTime(DateTime.Now.AddDays(7.0));
			gSPacketIn.WriteBoolean(val: false);
			client.Out.SendTCP(gSPacketIn);
			return 0;
		}
	}
}
