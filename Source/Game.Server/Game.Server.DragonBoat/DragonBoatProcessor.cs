using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.DragonBoat
{
	public class DragonBoatProcessor
	{
		private static object object_0;

		private GInterface1 ginterface1_0;

		public DragonBoatProcessor(GInterface1 processor)
		{
			ginterface1_0 = processor;
		}

		public void ProcessData(GamePlayer player, GSPacketIn data)
		{
			lock (object_0)
			{
				ginterface1_0.OnGameData(player, data);
			}
		}

		static DragonBoatProcessor()
		{
			object_0 = new object();
		}
	}
}
