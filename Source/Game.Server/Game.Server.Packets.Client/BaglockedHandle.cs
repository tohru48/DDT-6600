using System;
using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(403, "二级密码")]
	public class BaglockedHandle : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadByte();
			GSPacketIn gSPacketIn = new GSPacketIn(403, client.Player.PlayerCharacter.ID);
			int num2 = num;
			if (num2 == 5)
			{
				gSPacketIn.WriteByte(5);
				gSPacketIn.WriteBoolean(val: true);
				client.Out.SendTCP(gSPacketIn);
			}
			else
			{
				Console.WriteLine("BaglockedPackageType." + (BaglockedPackageType)num);
			}
			return 0;
		}
	}
}
