using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.GameRoom
{
	public interface GInterface3
	{
		void OnGameData(GamePlayer player, GSPacketIn packet);
	}
}
