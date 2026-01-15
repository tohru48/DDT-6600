using Game.Base.Packets;

namespace Game.Server.RingStation.RoomGamePkg
{
	public class RoomGame
	{
		private IGameProcessor igameProcessor_0;

		private static object object_0;

		public RoomGame()
		{
			igameProcessor_0 = new RingStationRoomLogicProcessor();
		}

		protected void OnTick(object obj)
		{
			igameProcessor_0.OnTick(this);
		}

		public void ProcessData(RingStationGamePlayer player, GSPacketIn data)
		{
			lock (object_0)
			{
				igameProcessor_0.OnGameData(this, player, data);
			}
		}

		static RoomGame()
		{
			object_0 = new object();
		}
	}
}
