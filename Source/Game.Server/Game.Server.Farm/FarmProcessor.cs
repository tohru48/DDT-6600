using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Farm
{
	public class FarmProcessor
	{
		private static object object_0;

		private IFarmProcessor ifarmProcessor_0;

		public FarmProcessor(IFarmProcessor processor)
		{
			ifarmProcessor_0 = processor;
		}

		public void ProcessData(GamePlayer player, GSPacketIn data)
		{
			lock (object_0)
			{
				ifarmProcessor_0.OnGameData(player, data);
			}
		}

		static FarmProcessor()
		{
			object_0 = new object();
		}
	}
}
