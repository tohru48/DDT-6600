using System;
using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(110, "场景用户离开")]
	public class SeparateActivityHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadByte();
			GSPacketIn gSPacketIn = new GSPacketIn(110, client.Player.PlayerCharacter.ID);
			switch (num)
			{
			case 17:
				gSPacketIn.WriteByte(17);
				gSPacketIn.WriteInt(4);
				client.Player.SendTCP(gSPacketIn);
				break;
			default:
				Console.WriteLine("TreasureHuntingType." + (TreasureHuntingType)num);
				break;
			case 2:
				gSPacketIn.WriteByte(2);
				gSPacketIn.WriteBoolean(val: true);
				gSPacketIn.WriteInt(1);
				gSPacketIn.WriteInt(13339);
				gSPacketIn.WriteInt(16);
				gSPacketIn.WriteString("Ủn ỉn cute");
				gSPacketIn.WriteInt(1);
				gSPacketIn.WriteInt(0);
				client.Player.SendTCP(gSPacketIn);
				break;
			}
			return 0;
		}
	}
}
