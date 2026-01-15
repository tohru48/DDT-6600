using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagicHouse
{
	public class MagicHouseProcessor
	{
		private static object object_0;

		private GInterface6 ginterface6_0;

		public MagicHouseProcessor(GInterface6 processor)
		{
			ginterface6_0 = processor;
		}

		public void ProcessData(GamePlayer player, GSPacketIn data)
		{
			lock (object_0)
			{
				ginterface6_0.OnGameData(player, data);
			}
		}

		static MagicHouseProcessor()
		{
			object_0 = new object();
		}
	}
}
