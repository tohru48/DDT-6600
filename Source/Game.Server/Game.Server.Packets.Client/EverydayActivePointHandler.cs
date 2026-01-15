using System;
using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(155, "场景用户离开")]
	public class EverydayActivePointHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			byte b = packet.ReadByte();
			int ıD = client.Player.PlayerCharacter.ID;
			byte b2 = b;
			if (b2 == 8)
			{
				client.Player.Out.SendExpBlessedData(ıD);
			}
			else
			{
				Console.WriteLine("ActivityPackageType." + (ActivityPackageType)b);
			}
			return 0;
		}
	}
}
