using Game.Server.Battle;

namespace Game.Server.Rooms
{
	public class CancelPickupAction : IAction
	{
		private BattleServer battleServer_0;

		private BaseRoom baseRoom_0;

		public CancelPickupAction(BattleServer server, BaseRoom room)
		{
			baseRoom_0 = room;
			battleServer_0 = server;
		}

		public void Execute()
		{
			if (baseRoom_0.Game == null && battleServer_0 != null)
			{
				baseRoom_0.BattleServer = null;
				baseRoom_0.IsPlaying = false;
				baseRoom_0.SendCancelPickUp();
				RoomMgr.WaitingRoom.SendUpdateCurrentRoom(baseRoom_0);
			}
		}
	}
}
