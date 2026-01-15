using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagpieBridge.Handle
{
	[Attribute12(4)]
	public class MagpieBridgeRefreshView : IMagpieBridgeCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			Player.Extra.CreateMagpieBridgeItems(Refresh: true);
			Player.Extra.SendMagpieBridgeEnter();
			return false;
		}
	}
}
