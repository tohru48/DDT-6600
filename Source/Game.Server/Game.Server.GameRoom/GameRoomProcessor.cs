using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.GameRoom
{
	public class GameRoomProcessor
	{
		private static object object_0;

		private GInterface3 ginterface3_0;

		public GameRoomProcessor(GInterface3 processor)
		{
			ginterface3_0 = processor;
		}

		public void ProcessData(GamePlayer player, GSPacketIn data)
		{
			lock (object_0)
			{
				ginterface3_0.OnGameData(player, data);
			}
		}

		static GameRoomProcessor()
		{
			object_0 = new object();
		}
	}
}
