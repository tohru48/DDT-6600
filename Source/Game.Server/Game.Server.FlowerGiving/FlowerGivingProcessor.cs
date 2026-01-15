using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.FlowerGiving
{
	public class FlowerGivingProcessor
	{
		private static object object_0;

		private IFlowerGivingProcessor iflowerGivingProcessor_0;

		public FlowerGivingProcessor(IFlowerGivingProcessor processor)
		{
			iflowerGivingProcessor_0 = processor;
		}

		public void ProcessData(GamePlayer player, GSPacketIn data)
		{
			lock (object_0)
			{
				iflowerGivingProcessor_0.OnGameData(player, data);
			}
		}

		static FlowerGivingProcessor()
		{
			object_0 = new object();
		}
	}
}
