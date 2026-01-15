using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagicStone.Handle
{
	public interface IMagicStoneCommandHadler
	{
		bool CommandHandler(GamePlayer Player, GSPacketIn packet);
	}
}
