namespace Game.Server.Rooms
{
	public class UpdateRoomPosAction : IAction
	{
		private BaseRoom baseRoom_0;

		private int int_0;

		private int int_1;

		private int int_2;

		private bool bool_0;

		public UpdateRoomPosAction(BaseRoom room, int pos, bool isOpened, int place, int placeView)
		{
			baseRoom_0 = room;
			int_0 = pos;
			bool_0 = isOpened;
			int_1 = place;
			int_2 = placeView;
		}

		public void Execute()
		{
			if (baseRoom_0.PlayerCount > 0 && baseRoom_0.UpdatePosUnsafe(int_0, bool_0, int_1, int_2))
			{
				RoomMgr.WaitingRoom.SendUpdateCurrentRoom(baseRoom_0);
			}
		}
	}
}
