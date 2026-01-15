using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.CollectionTask.Handle
{
	[Attribute3(3)]
	public class CollectionComplete : ICollectionTaskCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int type = packet.ReadInt();
			Player.OnCollectionTaskEvent(type);
			return true;
		}
	}
}
