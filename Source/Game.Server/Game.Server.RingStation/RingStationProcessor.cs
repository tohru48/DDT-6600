using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.RingStation
{
	public class RingStationProcessor
	{
		private static object object_0;

		private IRingStationProcessor iringStationProcessor_0;

		public RingStationProcessor(IRingStationProcessor processor)
		{
			iringStationProcessor_0 = processor;
		}

		public void ProcessData(GamePlayer player, GSPacketIn data)
		{
			lock (object_0)
			{
				iringStationProcessor_0.OnGameData(player, data);
			}
		}

		static RingStationProcessor()
		{
			object_0 = new object();
		}
	}
}
