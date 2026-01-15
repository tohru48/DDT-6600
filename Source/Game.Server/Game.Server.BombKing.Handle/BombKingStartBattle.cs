using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.BombKing.Handle
{
	[Attribute2(6)]
	public class BombKingStartBattle : IBombKingCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			return false;
		}
	}
}
