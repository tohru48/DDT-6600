using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.BombKing
{
	public abstract class AbstractBombKingProcessor : GInterface0
	{
		public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
		{
		}
	}
}
