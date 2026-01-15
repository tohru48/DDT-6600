using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.BombKing
{
	public class BombKingProcessor
	{
		private static object object_0;

		private GInterface0 ginterface0_0;

		public BombKingProcessor(GInterface0 processor)
		{
			ginterface0_0 = processor;
		}

		public void ProcessData(GamePlayer player, GSPacketIn data)
		{
			lock (object_0)
			{
				ginterface0_0.OnGameData(player, data);
			}
		}

		static BombKingProcessor()
		{
			object_0 = new object();
		}
	}
}
