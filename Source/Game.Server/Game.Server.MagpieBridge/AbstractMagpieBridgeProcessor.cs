using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagpieBridge
{
	public abstract class AbstractMagpieBridgeProcessor : IMagpieBridgeProcessor
	{
		public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
		{
		}
	}
}
