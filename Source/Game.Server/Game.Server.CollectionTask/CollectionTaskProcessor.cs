using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.CollectionTask
{
	public class CollectionTaskProcessor
	{
		private static object object_0;

		private ICollectionTaskProcessor icollectionTaskProcessor_0;

		public CollectionTaskProcessor(ICollectionTaskProcessor processor)
		{
			icollectionTaskProcessor_0 = processor;
		}

		public void ProcessData(GamePlayer player, GSPacketIn data)
		{
			lock (object_0)
			{
				icollectionTaskProcessor_0.OnGameData(player, data);
			}
		}

		static CollectionTaskProcessor()
		{
			object_0 = new object();
		}
	}
}
