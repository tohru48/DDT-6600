using Game.Server.GameObjects;

namespace Game.Server.Rooms
{
	public class ExitRoomAction : IAction
	{
		private BaseRoom baseRoom_0;

		private GamePlayer gamePlayer_0;

		public ExitRoomAction(BaseRoom room, GamePlayer player)
		{
			baseRoom_0 = room;
			gamePlayer_0 = player;
		}

		public void Execute()
		{
			baseRoom_0.RemovePlayerUnsafe(gamePlayer_0);
			if (baseRoom_0.IsEmpty)
			{
				baseRoom_0.Stop();
			}
			RoomMgr.WaitingRoom.SendUpdateCurrentRoom(baseRoom_0);
		}
	}
}
