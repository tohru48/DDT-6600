using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.Rooms;

namespace Game.Server.Packets.Client
{
	[PacketHandler(153, "场景用户离开")]
	public class ConsortiaBattleHander : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			byte b = packet.ReadByte();
			BaseConsBatRoom consBatRoom = RoomMgr.ConsBatRoom;
			int ıD = client.Player.PlayerCharacter.ID;
			switch (b)
			{
			case 3:
				consBatRoom.SendUpdateRoom(client.Player);
				break;
			case 4:
			{
				int num2 = packet.ReadInt();
				int num3 = packet.ReadInt();
				string str = packet.ReadString();
				GSPacketIn gSPacketIn = new GSPacketIn(153, ıD);
				gSPacketIn.WriteByte(4);
				gSPacketIn.WriteInt(ıD);
				gSPacketIn.WriteInt(num2);
				gSPacketIn.WriteInt(num3);
				gSPacketIn.WriteString(str);
				consBatRoom.PlayerMove(num2, num3, ıD);
				consBatRoom.method_0(gSPacketIn);
				break;
			}
			case 5:
				consBatRoom.RemovePlayer(client.Player);
				break;
			case 6:
			{
				int challengeId = packet.ReadInt();
				if (client.Player.MainWeapon == null)
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.SceneGames.NoEquip"));
					return 0;
				}
				consBatRoom.Challenge(ıD, challengeId);
				break;
			}
			case 16:
			{
				byte b2 = packet.ReadByte();
				Console.WriteLine("UPDATE_SCORE. " + b2);
				break;
			}
			case 17:
			{
				int num = packet.ReadInt();
				packet.ReadBoolean();
				Console.WriteLine("CONSUME. " + num);
				break;
			}
			default:
				Console.WriteLine("ConsortiaBattleType." + (ConsBatPackageType)b);
				break;
			case 21:
				consBatRoom.SendConfirmEnterRoom(client.Player);
				break;
			}
			return 0;
		}
	}
}
