using System;
using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameObjects;
using Game.Server.Managers;
using Game.Server.Rooms;
using SqlDataProvider.Data;

namespace Game.Server.GameRoom.Handle
{
	[Attribute7(18)]
	public class SingleRoomBegin : IGameRoomCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			if (Player.MainWeapon == null)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.SceneGames.NoEquip"));
				return false;
			}
			switch (num)
			{
			case 1:
				RoomMgr.CreateEncounterRoom(Player, eRoomType.Encounter);
				return true;
			case 2:
			{
				ConsortiaInfo consortiaById = ConsortiaBossMgr.GetConsortiaById(Player.PlayerCharacter.ConsortiaID);
				int bossLevel = 10;
				if (consortiaById != null)
				{
					bossLevel = consortiaById.callBossLevel;
				}
				RoomMgr.CreateConsortiaBossRoom(Player, eRoomType.ConsortiaBoss, bossLevel);
				return true;
			}
			case 3:
				RoomMgr.CreateBattleRoom(Player, eRoomType.BattleRoom);
				return true;
			case 4:
				if (Player.CurrentRoom != null)
				{
					Player.CurrentRoom.RemovePlayerUnsafe(Player);
				}
				if (!Player.IsActive)
				{
					return false;
				}
				RoomMgr.WaitingRoom.RemovePlayer(Player);
				RoomMgr.ConsBatRoom.AddPlayer(Player);
				return true;
			case 7:
			case 8:
			case 9:
			case 10:
				RoomMgr.CreateGroupBattleRoom(Player, num);
				return true;
			case 17:
				if (Player.CurrentRoom != null)
				{
					Player.CurrentRoom.RemovePlayerUnsafe(Player);
				}
				if (!Player.IsActive)
				{
					return false;
				}
				RoomMgr.WaitingRoom.RemovePlayer(Player);
				RoomMgr.CampBattleRoom.AddPlayer(Player);
				return true;
			case 20:
				Player.ClearFootballCard();
				RoomMgr.CreateFightFootballTimeRoom(Player, eRoomType.FightFootballTime);
				return true;
			case 60:
				if (Player.PlayerCharacter.horseRaceCanRaceTime <= 0)
				{
					Player.SendMessage(LanguageMgr.GetTranslation("GameServer.HorseGame.NoHaveTimes"));
					return false;
				}
				if (Player.PlayerCharacter.MountsType <= 0)
				{
					Player.SendMessage(LanguageMgr.GetTranslation("GameServer.HorseGame.NoHorse"));
					return false;
				}
				if (Player.PlayerCharacter.MountLv <= 0)
				{
					Player.SendMessage(LanguageMgr.GetTranslation("GameServer.HorseGame.NoHorseLevel"));
					return false;
				}
				RoomMgr.CreateHorseRaceRoom(Player);
				return true;
			default:
				Console.WriteLine("SINGLE_ROOM_BEGIN: {0}", num);
				return true;
			}
		}
	}
}
