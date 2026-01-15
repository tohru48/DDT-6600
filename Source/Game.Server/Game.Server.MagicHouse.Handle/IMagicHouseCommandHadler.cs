using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagicHouse.Handle
{
	public interface IMagicHouseCommandHadler
	{
		bool CommandHandler(GamePlayer Player, GSPacketIn packet);
	}
}
