using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.NewHall
{
	public interface INewHallProcessor
	{
		void OnGameData(GamePlayer player, GSPacketIn packet);
	}
}
