using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.CollectionTask.Handle
{
	[Attribute3(2)]
	public class PlayerMove : ICollectionTaskCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int x = packet.ReadInt();
			int y = packet.ReadInt();
			WorldMgr.CollectionTaskRooms.PlayerMove(Player.PlayerId, x, y);
			return true;
		}
	}
}
