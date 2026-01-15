using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(116)]
	public class HalloweenEnter : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			Player.Actives.SendHalloweenEnter();
			return true;
		}
	}
}
