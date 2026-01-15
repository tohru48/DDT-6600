using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.FlowerGiving
{
	public interface IFlowerGivingProcessor
	{
		void OnGameData(GamePlayer player, GSPacketIn packet);
	}
}
