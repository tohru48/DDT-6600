using System;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Packets.Client
{
	[PacketHandler(148, "物品强化")]
	public class SevenDoubleHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			byte b = packet.ReadByte();
			GSPacketIn gSPacketIn = new GSPacketIn(148);
			switch (b)
			{
			case 3:
			{
				int val = packet.ReadInt();
				packet.ReadBoolean();
				gSPacketIn.WriteByte(3);
				gSPacketIn.WriteInt(val);
				client.Out.SendTCP(gSPacketIn);
				return 0;
			}
			case 6:
				gSPacketIn.WriteByte(6);
				client.Out.SendTCP(gSPacketIn);
				return 0;
			case 7:
				return 0;
			case 9:
				gSPacketIn.WriteByte(16);
				gSPacketIn.WriteDateTime(DateTime.Now.AddMinutes(20.0));
				client.Out.SendTCP(gSPacketIn);
				return 0;
			case 35:
				gSPacketIn.WriteByte(35);
				gSPacketIn.WriteBoolean(val: true);
				client.Out.SendTCP(gSPacketIn);
				return 0;
			default:
				Console.WriteLine("SevenDoubleHandler." + (SevenDoublePackageType)b);
				return 0;
			}
		}

		public void SendSevenDoubleStartGame(GamePlayer player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(148);
			gSPacketIn.WriteByte(8);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(4);
			gSPacketIn.WriteInt(player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(2);
			gSPacketIn.WriteString(player.PlayerCharacter.NickName);
			player.SendTCP(gSPacketIn);
		}
	}
}
