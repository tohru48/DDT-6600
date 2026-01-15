using System.Collections.Generic;
using Game.Logic;
using Game.Server.GameObjects;
using Game.Server.Games;

namespace Game.Server.Rooms
{
	public class CreateConsortiaBattleRoomAction : IAction
	{
		private GamePlayer gamePlayer_0;

		private GamePlayer gamePlayer_1;

		private string string_0;

		private string string_1;

		private eRoomType eRoomType_0;

		private byte byte_0;

		public CreateConsortiaBattleRoomAction(GamePlayer player, GamePlayer ChallengePlayer)
		{
			gamePlayer_0 = player;
			gamePlayer_1 = ChallengePlayer;
			string_0 = "Consortia Battle";
			string_1 = "12dasSda44";
			eRoomType_0 = eRoomType.ConsortiaBattle;
			byte_0 = 2;
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
			if (gamePlayer_1.CurrentRoom != null)
			{
				gamePlayer_1.CurrentRoom.RemovePlayerUnsafe(gamePlayer_0);
			}
			if (!gamePlayer_1.IsActive)
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
			baseRoom.UpdateRoom(string_0, string_1, eRoomType_0, byte_0, 0);
			gamePlayer_0.Out.SendRoomCreate(baseRoom);
			if (baseRoom.AddPlayerUnsafe(gamePlayer_0))
			{
				RoomMgr.WaitingRoom.RemovePlayer(gamePlayer_1);
				gamePlayer_1.Out.SendRoomLoginResult(result: true);
				gamePlayer_1.Out.SendRoomCreate(baseRoom);
				baseRoom.AddPlayerUnsafe(gamePlayer_1);
			}
			if (baseRoom.PlayerCount == 2)
			{
				List<IGamePlayer> list = new List<IGamePlayer>();
				List<IGamePlayer> list2 = new List<IGamePlayer>();
				list.Add(gamePlayer_0);
				list2.Add(gamePlayer_1);
				BaseGame baseGame = GameMgr.StartPVPGame(baseRoom.RoomId, list, list2, baseRoom.MapId, baseRoom.RoomType, baseRoom.GameType, baseRoom.TimeMode);
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
}
