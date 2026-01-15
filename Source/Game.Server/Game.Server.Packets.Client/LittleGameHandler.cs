using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(166, "场景用户离开")]
	public class LittleGameHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			byte b = packet.ReadByte();
			int ıD = client.Player.PlayerCharacter.ID;
			GSPacketIn gSPacketIn = new GSPacketIn(166, ıD);
			switch (b)
			{
			case 2:
				gSPacketIn.WriteByte(2);
				gSPacketIn.WriteInt(1);
				gSPacketIn.WriteInt(1);
				gSPacketIn.WriteString("bogu1,bogu2,bogu3,bogu4,bogu5,bogu6,bogu7,bogu8");
				gSPacketIn.WriteString("2001");
				client.Player.SendTCP(gSPacketIn);
				break;
			case 3:
			{
				int num = 1;
				gSPacketIn.WriteByte(3);
				gSPacketIn.WriteInt(1);
				for (int i = 0; i < num; i++)
				{
					gSPacketIn.WriteInt(1);
					gSPacketIn.WriteInt(2039);
					gSPacketIn.WriteInt(123);
					gSPacketIn.WriteInt(1);
					gSPacketIn.WriteInt(client.Player.PlayerCharacter.ID);
					gSPacketIn.WriteInt(client.Player.PlayerCharacter.Grade);
					gSPacketIn.WriteInt(client.Player.PlayerCharacter.Repute);
					gSPacketIn.WriteString(client.Player.PlayerCharacter.NickName);
					gSPacketIn.WriteByte(client.Player.PlayerCharacter.typeVIP);
					gSPacketIn.WriteInt(client.Player.PlayerCharacter.VIPLevel);
					gSPacketIn.WriteBoolean(client.Player.PlayerCharacter.Sex);
					gSPacketIn.WriteString(client.Player.PlayerCharacter.Style);
					gSPacketIn.WriteString(client.Player.PlayerCharacter.Colors);
					gSPacketIn.WriteString(client.Player.PlayerCharacter.Skin);
					gSPacketIn.WriteInt(client.Player.PlayerCharacter.Hide);
					gSPacketIn.WriteInt(client.Player.PlayerCharacter.FightPower);
					gSPacketIn.WriteInt(client.Player.PlayerCharacter.Win);
					gSPacketIn.WriteInt(client.Player.PlayerCharacter.Total);
					gSPacketIn.WriteBoolean(val: false);
					int num2 = 1;
					int j = 0;
					gSPacketIn.WriteInt(1);
					for (; j < num2; j++)
					{
						gSPacketIn.WriteString("livingInhale");
						gSPacketIn.WriteInt(1);
						gSPacketIn.WriteString("stand");
						gSPacketIn.WriteString("1");
						gSPacketIn.WriteInt(1);
						gSPacketIn.WriteInt(2039);
						gSPacketIn.WriteInt(123);
					}
				}
				client.Player.SendTCP(gSPacketIn);
				break;
			}
			}
			return 0;
		}
	}
}
