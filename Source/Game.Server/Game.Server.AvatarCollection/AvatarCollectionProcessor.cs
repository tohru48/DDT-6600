using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.AvatarCollection
{
	public class AvatarCollectionProcessor
	{
		private static object object_0;

		private IAvatarCollectionProcessor iavatarCollectionProcessor_0;

		public AvatarCollectionProcessor(IAvatarCollectionProcessor processor)
		{
			iavatarCollectionProcessor_0 = processor;
		}

		public void ProcessData(GamePlayer player, GSPacketIn data)
		{
			lock (object_0)
			{
				iavatarCollectionProcessor_0.OnGameData(player, data);
			}
		}

		static AvatarCollectionProcessor()
		{
			object_0 = new object();
		}
	}
}
