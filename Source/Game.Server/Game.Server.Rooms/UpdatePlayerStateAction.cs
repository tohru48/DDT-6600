using Game.Server.GameObjects;

namespace Game.Server.Rooms
{
	public class UpdatePlayerStateAction : IAction
	{
		private GamePlayer gamePlayer_0;

		private BaseRoom baseRoom_0;

		private byte byte_0;

		public UpdatePlayerStateAction(GamePlayer player, BaseRoom room, byte state)
		{
			gamePlayer_0 = player;
			byte_0 = state;
			baseRoom_0 = room;
		}

		public void Execute()
		{
			if (gamePlayer_0.CurrentRoom != null && baseRoom_0 != null && gamePlayer_0.CurrentRoom.RoomId == baseRoom_0.RoomId)
			{
				baseRoom_0.UpdatePlayerState(gamePlayer_0, byte_0, sendToClient: true);
			}
		}
	}
}
