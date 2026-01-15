using Game.Server.GameObjects;

namespace Game.Server.Rooms
{
	public class SwitchTeamAction : IAction
	{
		private GamePlayer gamePlayer_0;

		public SwitchTeamAction(GamePlayer player)
		{
			gamePlayer_0 = player;
		}

		public void Execute()
		{
			gamePlayer_0.CurrentRoom?.SwitchTeamUnsafe(gamePlayer_0);
		}
	}
}
