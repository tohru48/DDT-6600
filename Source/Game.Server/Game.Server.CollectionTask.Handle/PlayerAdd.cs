using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.CollectionTask.Handle
{
	[Attribute3(5)]
	public class PlayerAdd : ICollectionTaskCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			WorldMgr.CollectionTaskRooms.AddPlayer(Player);
			return true;
		}
	}
}
