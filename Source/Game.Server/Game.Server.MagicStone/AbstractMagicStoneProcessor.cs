using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagicStone
{
	public abstract class AbstractMagicStoneProcessor : GInterface7
	{
		public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
		{
		}
	}
}
