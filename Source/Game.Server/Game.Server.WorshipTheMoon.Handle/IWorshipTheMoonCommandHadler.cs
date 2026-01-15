using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.WorshipTheMoon.Handle
{
	public interface IWorshipTheMoonCommandHadler
	{
		bool CommandHandler(GamePlayer Player, GSPacketIn packet);
	}
}
