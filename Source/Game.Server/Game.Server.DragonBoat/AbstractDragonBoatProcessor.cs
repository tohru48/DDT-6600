using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.DragonBoat
{
	public abstract class AbstractDragonBoatProcessor : GInterface1
	{
		public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
		{
		}
	}
}
