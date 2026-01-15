namespace Game.Server.Rooms
{
	public class StopProxyGameAction : IAction
	{
		private BaseRoom lrZfmnAsjq;

		public StopProxyGameAction(BaseRoom room)
		{
			lrZfmnAsjq = room;
		}

		public void Execute()
		{
			if (lrZfmnAsjq.Game != null)
			{
				lrZfmnAsjq.Game.Stop();
			}
			RoomMgr.WaitingRoom.SendUpdateCurrentRoom(lrZfmnAsjq);
		}
	}
}
