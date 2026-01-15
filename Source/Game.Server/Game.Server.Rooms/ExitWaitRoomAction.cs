using Game.Server.GameObjects;

namespace Game.Server.Rooms
{
	public class ExitWaitRoomAction : IAction
	{
		private GamePlayer gamePlayer_0;

		public ExitWaitRoomAction(GamePlayer player)
		{
			gamePlayer_0 = player;
		}

		public void Execute()
		{
			BaseWaitingRoom waitingRoom = RoomMgr.WaitingRoom;
			waitingRoom.RemovePlayer(gamePlayer_0);
		}
	}
}
