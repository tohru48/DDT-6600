using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagicStone
{
	public interface GInterface7
	{
		void OnGameData(GamePlayer player, GSPacketIn packet);
	}
}
