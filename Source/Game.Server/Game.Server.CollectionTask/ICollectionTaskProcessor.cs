using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.CollectionTask
{
	public interface ICollectionTaskProcessor
	{
		void OnGameData(GamePlayer player, GSPacketIn packet);
	}
}
