using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Horse.Handle
{
	public interface IHorseCommandHadler
	{
		bool CommandHandler(GamePlayer Player, GSPacketIn packet);
	}
}
