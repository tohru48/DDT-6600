using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.CollectionTask.Handle
{
	[Attribute3(4)]
	public class PlayerExit : ICollectionTaskCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int ıd = packet.ReadInt();
			WorldMgr.CollectionTaskRooms.RemovePlayer(ıd);
			return true;
		}
	}
}
