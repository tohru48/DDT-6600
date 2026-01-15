using Game.Server.Battle;

namespace Game.Server.Rooms
{
	public class StartProxyGameAction : IAction
	{
		private BaseRoom baseRoom_0;

		private ProxyGame proxyGame_0;

		public StartProxyGameAction(BaseRoom room, ProxyGame game)
		{
			baseRoom_0 = room;
			proxyGame_0 = game;
		}

		public void Execute()
		{
			baseRoom_0.StartGame(proxyGame_0);
		}
	}
}
