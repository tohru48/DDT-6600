using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.WorshipTheMoon
{
	public abstract class AbstractWorshipTheMoonProcessor : IWorshipTheMoonProcessor
	{
		public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
		{
		}
	}
}
