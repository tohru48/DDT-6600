using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.WorshipTheMoon
{
	public interface IWorshipTheMoonProcessor
	{
		void OnGameData(GamePlayer player, GSPacketIn packet);
	}
}
