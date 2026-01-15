using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Horse
{
	public interface IHorseProcessor
	{
		void OnGameData(GamePlayer player, GSPacketIn packet);
	}
}
