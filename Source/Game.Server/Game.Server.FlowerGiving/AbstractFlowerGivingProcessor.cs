using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.FlowerGiving
{
	public abstract class AbstractFlowerGivingProcessor : IFlowerGivingProcessor
	{
		public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
		{
		}
	}
}
