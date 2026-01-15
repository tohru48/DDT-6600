using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagpieBridge
{
	public interface IMagpieBridgeProcessor
	{
		void OnGameData(GamePlayer player, GSPacketIn packet);
	}
}
