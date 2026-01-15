using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagicStone
{
	public class MagicStoneProcessor
	{
		private static object object_0;

		private GInterface7 ginterface7_0;

		public MagicStoneProcessor(GInterface7 processor)
		{
			ginterface7_0 = processor;
		}

		public void ProcessData(GamePlayer player, GSPacketIn data)
		{
			lock (object_0)
			{
				ginterface7_0.OnGameData(player, data);
			}
		}

		static MagicStoneProcessor()
		{
			object_0 = new object();
		}
	}
}
