using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.GypsyShop
{
	public abstract class AbstractGypsyShopProcessor : GInterface4
	{
		public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
		{
		}
	}
}
