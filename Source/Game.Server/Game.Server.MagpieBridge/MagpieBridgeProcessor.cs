using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagpieBridge
{
	public class MagpieBridgeProcessor
	{
		private static object object_0;

		private IMagpieBridgeProcessor imagpieBridgeProcessor_0;

		public MagpieBridgeProcessor(IMagpieBridgeProcessor processor)
		{
			imagpieBridgeProcessor_0 = processor;
		}

		public void ProcessData(GamePlayer player, GSPacketIn data)
		{
			lock (object_0)
			{
				imagpieBridgeProcessor_0.OnGameData(player, data);
			}
		}

		static MagpieBridgeProcessor()
		{
			object_0 = new object();
		}
	}
}
