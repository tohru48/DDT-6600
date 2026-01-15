using Game.Logic;
using Game.Server.GameObjects;

namespace Game.Server.Rooms
{
	public class CreateRoomAction : IAction
	{
		private GamePlayer gamePlayer_0;

		private string string_0;

		private string string_1;

		private eRoomType eRoomType_0;

		private byte byte_0;

		public CreateRoomAction(GamePlayer player, string name, string password, eRoomType roomType, byte timeType)
		{
			gamePlayer_0 = player;
			string_0 = name;
			string_1 = password;
			eRoomType_0 = roomType;
			byte_0 = timeType;
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
				if (eRoomType_0 == eRoomType.Dungeon)
				{
					baseRoom.HardLevel = eHardLevel.Normal;
					baseRoom.LevelLimits = (int)baseRoom.GetLevelLimit(gamePlayer_0);
					baseRoom.isOpenBoss = false;
					baseRoom.currentFloor = 0;
				}
				if (eRoomType_0 == eRoomType.Entertainment || eRoomType_0 == eRoomType.EntertainmentPK)
				{
					baseRoom.isCrosszone = true;
				}
				baseRoom.UpdateRoom(string_0, string_1, eRoomType_0, byte_0, 0);
				gamePlayer_0.Out.SendRoomCreate(baseRoom);
				baseRoom.AddPlayerUnsafe(gamePlayer_0);
				RoomMgr.WaitingRoom.SendUpdateCurrentRoom(baseRoom);
			}
		}
	}
}
