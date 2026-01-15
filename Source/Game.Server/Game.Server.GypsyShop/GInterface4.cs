using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.GypsyShop
{
	public interface GInterface4
	{
		void OnGameData(GamePlayer player, GSPacketIn packet);
	}
}
