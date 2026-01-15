using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.NewHall.Handle
{
	public interface INewHallCommandHadler
	{
		bool CommandHandler(GamePlayer Player, GSPacketIn packet);
	}
}
