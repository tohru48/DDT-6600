using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.BombKing.Handle
{
	public interface IBombKingCommandHadler
	{
		bool CommandHandler(GamePlayer Player, GSPacketIn packet);
	}
}
