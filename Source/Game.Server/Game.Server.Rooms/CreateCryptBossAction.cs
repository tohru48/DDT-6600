using System.Collections.Generic;
using Bussiness;
using Game.Logic;
using Game.Server.GameObjects;
using Game.Server.Games;

namespace Game.Server.Rooms
{
	public class CreateCryptBossAction : IAction
	{
		private GamePlayer gamePlayer_0;

		private string string_0;

		private string string_1;

		private eRoomType eRoomType_0;

		private byte byte_0;

		private int int_0;

		private int int_1;

		private eHardLevel eHardLevel_0;

		public CreateCryptBossAction(GamePlayer player, int id, int level)
		{
			gamePlayer_0 = player;
			string_0 = "CryptBoss";
			string_1 = "12dasS12dasda44C@tchBe@st";
			eRoomType_0 = eRoomType.Cryptboss;
			int_0 = 0;
			byte_0 = 3;
			switch (id)
			{
			case 1:
				int_1 = 50201;
				break;
			case 2:
				int_1 = 50202;
				break;
			case 3:
				int_1 = 50203;
				break;
			case 4:
				int_1 = 50204;
				break;
			case 5:
				int_1 = 50205;
				break;
			case 6:
				int_1 = 50206;
				break;
			default:
				int_1 = 50201;
				break;
			}
			switch (level)
			{
			case 1:
				eHardLevel_0 = eHardLevel.Easy;
				break;
			case 2:
				eHardLevel_0 = eHardLevel.Normal;
				break;
			case 3:
				eHardLevel_0 = eHardLevel.Hard;
				break;
			case 4:
				eHardLevel_0 = eHardLevel.Terror;
				byte_0 = 2;
				break;
			case 5:
				eHardLevel_0 = eHardLevel.Epic;
				byte_0 = 1;
				break;
			default:
				eHardLevel_0 = eHardLevel.Easy;
				break;
			}
		}

		public void Execute()
		{
			if (gamePlayer_0.MainWeapon == null)
			{
				gamePlayer_0.SendMessage(LanguageMgr.GetTranslation("Game.Server.SceneGames.NoEquip"));
				return;
			}
			if (gamePlayer_0.CurrentRoom != null)
			{
				gamePlayer_0.CurrentRoom.RemovePlayerUnsafe(gamePlayer_0);
			}
			if (!gamePlayer_0.IsActive)
			{
				return;
			}
			BaseRoom[] rooms = RoomMgr.Rooms;
			BaseRoom baseRoom = null;
			for (int i = 0; i < rooms.Length; i++)
			{
				if (!rooms[i].IsUsing)
				{
					baseRoom = rooms[i];
					break;
				}
			}
			if (baseRoom == null)
			{
				return;
			}
			RoomMgr.WaitingRoom.RemovePlayer(gamePlayer_0);
			baseRoom.Start();
			baseRoom.HardLevel = eHardLevel_0;
			baseRoom.LevelLimits = (int)baseRoom.GetLevelLimit(gamePlayer_0);
			baseRoom.isCrosszone = false;
			baseRoom.isOpenBoss = false;
			baseRoom.MapId = int_1;
			baseRoom.currentFloor = int_0;
			baseRoom.TimeMode = byte_0;
			baseRoom.UpdateRoom(string_0, string_1, eRoomType_0, byte_0, baseRoom.MapId);
			gamePlayer_0.Out.SendRoomCreate(baseRoom);
			if (!baseRoom.AddPlayerUnsafe(gamePlayer_0))
			{
				return;
			}
			List<GamePlayer> players = baseRoom.GetPlayers();
			List<IGamePlayer> list = new List<IGamePlayer>();
			foreach (GamePlayer item in players)
			{
				if (item != null)
				{
					list.Add(item);
				}
			}
			BaseGame baseGame = GameMgr.StartPVEGame(baseRoom.RoomId, list, baseRoom.MapId, baseRoom.RoomType, baseRoom.GameType, baseRoom.TimeMode, baseRoom.HardLevel, baseRoom.LevelLimits, baseRoom.currentFloor);
			if (baseGame != null)
			{
				baseRoom.IsPlaying = true;
				baseRoom.StartGame(baseGame);
			}
			else
			{
				baseRoom.IsPlaying = false;
				baseRoom.SendPlayerState();
			}
		}
	}
}
