using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.CollectionTask.Handle
{
	public interface ICollectionTaskCommandHadler
	{
		bool CommandHandler(GamePlayer Player, GSPacketIn packet);
	}
}
