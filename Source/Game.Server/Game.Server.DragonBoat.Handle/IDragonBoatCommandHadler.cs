using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.DragonBoat.Handle
{
	public interface IDragonBoatCommandHadler
	{
		bool CommandHandler(GamePlayer Player, GSPacketIn packet);
	}
}
