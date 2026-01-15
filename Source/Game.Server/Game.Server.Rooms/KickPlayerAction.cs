namespace Game.Server.Rooms
{
	public class KickPlayerAction : IAction
	{
		private BaseRoom baseRoom_0;

		private int int_0;

		public KickPlayerAction(BaseRoom room, int place)
		{
			baseRoom_0 = room;
			int_0 = place;
		}

		public void Execute()
		{
			baseRoom_0.RemovePlayerAtUnsafe(int_0);
		}
	}
}
