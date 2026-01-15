using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.FlowerGiving.Handle
{
	public interface IFlowerGivingCommandHadler
	{
		bool CommandHandler(GamePlayer Player, GSPacketIn packet);
	}
}
