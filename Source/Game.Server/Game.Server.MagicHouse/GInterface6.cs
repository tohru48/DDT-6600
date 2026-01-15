using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagicHouse
{
	public interface GInterface6
	{
		void OnGameData(GamePlayer player, GSPacketIn packet);
	}
}
