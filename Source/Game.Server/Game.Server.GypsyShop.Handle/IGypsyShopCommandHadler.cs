using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.GypsyShop.Handle
{
	public interface IGypsyShopCommandHadler
	{
		bool CommandHandler(GamePlayer Player, GSPacketIn packet);
	}
}
