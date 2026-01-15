using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.Rooms;

namespace Game.Server.Packets.Client
{
	[PacketHandler(146, "场景用户离开")]
	public class CampBattleHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			byte b = packet.ReadByte();
			int ıD = client.Player.PlayerCharacter.ID;
			BaseCampBattleRoom campBattleRoom = RoomMgr.CampBattleRoom;
			switch (b)
			{
			case 2:
			{
				int num = packet.ReadInt();
				int num2 = packet.ReadInt();
				int zoneId = packet.ReadInt();
				int playerId = packet.ReadInt();
				client.Player.X = num;
				client.Player.Y = num2;
				campBattleRoom.PlayerMove(client.Player, num, num2, zoneId, playerId);
				return 0;
			}
			case 3:
				campBattleRoom.RemovePlayer(client.Player);
				return 0;
			case 5:
				packet.ReadInt();
				if (client.Player.MainWeapon == null)
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.SceneGames.NoEquip"));
					return 0;
				}
				campBattleRoom.SendCampFightMonster(client.Player);
				return 0;
			case 6:
				campBattleRoom.SendCampInitSecen(client.Player);
				return 0;
			case 21:
				campBattleRoom.SendPerScoreRank(client.Player);
				return 0;
			default:
				Console.WriteLine("CampBattleHandler." + (CampPackageType)b);
				return 0;
			}
		}
	}
}
