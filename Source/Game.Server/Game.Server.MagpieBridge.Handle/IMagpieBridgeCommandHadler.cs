using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagpieBridge.Handle
{
	public interface IMagpieBridgeCommandHadler
	{
		bool CommandHandler(GamePlayer Player, GSPacketIn packet);
	}
}
