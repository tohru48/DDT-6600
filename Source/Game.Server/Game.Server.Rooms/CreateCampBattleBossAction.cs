using System.Collections.Generic;
using Game.Logic;
using Game.Server.GameObjects;
using Game.Server.Games;

namespace Game.Server.Rooms
{
	public class CreateCampBattleBossAction : IAction
	{
		private GamePlayer gamePlayer_0;

		private string string_0;

		private string string_1;

		private eRoomType eRoomType_0;

		private byte byte_0;

		private int int_0;

		private int int_1;

		public CreateCampBattleBossAction(GamePlayer player, eRoomType roomType, int bossLevel, int mapId)
		{
			gamePlayer_0 = player;
			string_0 = "Camp Battle Boss";
			string_1 = "12dasSda44";
			eRoomType_0 = roomType;
			byte_0 = 2;
			int_0 = bossLevel;
			int_1 = mapId;
		}

		public void Execute()
		{
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
			baseRoom.HardLevel = eHardLevel.Normal;
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
