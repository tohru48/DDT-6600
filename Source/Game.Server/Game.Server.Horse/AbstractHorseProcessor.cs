using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Horse
{
	public abstract class AbstractHorseProcessor : IHorseProcessor
	{
		public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
		{
		}
	}
}
