namespace Game.Server.Rooms
{
	public class StartGameMissionAction : IAction
	{
		private BaseRoom baseRoom_0;

		public StartGameMissionAction(BaseRoom room)
		{
			baseRoom_0 = room;
		}

		public void Execute()
		{
			baseRoom_0.Game.MissionStart(baseRoom_0.Host);
		}
	}
}
