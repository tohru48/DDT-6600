using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(169)]
	public class VipMerryDiscountInfo : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(169, Player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteBoolean(val: false);
			Player.SendTCP(gSPacketIn);
			return true;
		}
	}
}
