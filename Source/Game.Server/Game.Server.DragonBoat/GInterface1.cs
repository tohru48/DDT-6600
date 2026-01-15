using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.DragonBoat
{
	public interface GInterface1
	{
		void OnGameData(GamePlayer player, GSPacketIn packet);
	}
}
