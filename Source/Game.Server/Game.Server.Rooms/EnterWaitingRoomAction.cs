using System.Collections.Generic;
using Game.Server.GameObjects;

namespace Game.Server.Rooms
{
	public class EnterWaitingRoomAction : IAction
	{
		private GamePlayer gamePlayer_0;

		public EnterWaitingRoomAction(GamePlayer player)
		{
			gamePlayer_0 = player;
		}

		public void Execute()
		{
			if (gamePlayer_0 == null)
			{
				return;
			}
			if (gamePlayer_0.CurrentRoom != null)
			{
				gamePlayer_0.CurrentRoom.RemovePlayerUnsafe(gamePlayer_0);
			}
			BaseWaitingRoom waitingRoom = RoomMgr.WaitingRoom;
			if (!waitingRoom.AddPlayer(gamePlayer_0))
			{
				return;
			}
			List<BaseRoom> allRooms = RoomMgr.GetAllRooms();
			gamePlayer_0.Out.SendUpdateRoomList(allRooms);
			GamePlayer[] playersSafe = waitingRoom.GetPlayersSafe();
			GamePlayer[] array = playersSafe;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer != gamePlayer_0)
				{
					gamePlayer_0.Out.SendSceneAddPlayer(gamePlayer);
				}
			}
		}
	}
}
