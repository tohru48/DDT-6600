using Game.Logic;
using Game.Server.Battle;
using Game.Server.GameObjects;
using Game.Server.RingStation;
using SqlDataProvider.Data;

namespace Game.Server.Rooms
{
	public class CreateRingStationRoomAction : IAction
	{
		private GamePlayer gamePlayer_0;

		private UserRingStationInfo userRingStationInfo_0;

		private string string_0;

		private string string_1;

		private eRoomType eRoomType_0;

		private byte byte_0;

		public CreateRingStationRoomAction(GamePlayer player, UserRingStationInfo challengePlayer)
		{
			gamePlayer_0 = player;
			userRingStationInfo_0 = challengePlayer;
			string_0 = "RingStation Battle";
			string_1 = "12dasSda44";
			eRoomType_0 = eRoomType.RingStation;
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
			if (baseRoom != null)
			{
				RoomMgr.WaitingRoom.RemovePlayer(gamePlayer_0);
				baseRoom.Start();
				baseRoom.UpdateRoom(string_0, string_1, eRoomType_0, byte_0, 0);
				gamePlayer_0.Out.SendRoomCreate(baseRoom);
				if (baseRoom.AddPlayerUnsafe(gamePlayer_0))
				{
					baseRoom.StartWithNpc = true;
					baseRoom.PickUpNpcId = RingStationMgr.CreateRingStationChallenge(userRingStationInfo_0, (int)baseRoom.RoomType, (int)baseRoom.GameType);
				}
				BattleServer battleServer = BattleMgr.AddRoom(baseRoom);
				if (battleServer != null)
				{
					baseRoom.BattleServer = battleServer;
					baseRoom.IsPlaying = true;
				}
				else if (gamePlayer_0.CurrentRoom != null)
				{
					gamePlayer_0.CurrentRoom.RemovePlayerUnsafe(gamePlayer_0);
				}
			}
		}
	}
}
