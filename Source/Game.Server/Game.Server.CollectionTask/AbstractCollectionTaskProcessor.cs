using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.CollectionTask
{
	public abstract class AbstractCollectionTaskProcessor : ICollectionTaskProcessor
	{
		public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
		{
		}
	}
}
