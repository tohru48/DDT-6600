using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.GypsyShop
{
	public class GypsyShopProcessor
	{
		private static object tyTmxpvrbF;

		private GInterface4 ginterface4_0;

		public GypsyShopProcessor(GInterface4 processor)
		{
			ginterface4_0 = processor;
		}

		public void ProcessData(GamePlayer player, GSPacketIn data)
		{
			lock (tyTmxpvrbF)
			{
				ginterface4_0.OnGameData(player, data);
			}
		}

		static GypsyShopProcessor()
		{
			tyTmxpvrbF = new object();
		}
	}
}
