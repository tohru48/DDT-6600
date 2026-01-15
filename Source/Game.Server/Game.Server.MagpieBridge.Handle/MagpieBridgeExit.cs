using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagpieBridge.Handle
{
	[Attribute12(5)]
	public class MagpieBridgeExit : IMagpieBridgeCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			Player.Extra.ConvertMagpieBridgeItems();
			return false;
		}
	}
}
