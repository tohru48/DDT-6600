using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.NewHall
{
	public abstract class AbstractNewHallProcessor : INewHallProcessor
	{
		public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
		{
		}
	}
}
