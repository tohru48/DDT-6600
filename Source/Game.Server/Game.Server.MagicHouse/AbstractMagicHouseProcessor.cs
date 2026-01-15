using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagicHouse
{
	public abstract class AbstractMagicHouseProcessor : GInterface6
	{
		public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
		{
		}
	}
}
