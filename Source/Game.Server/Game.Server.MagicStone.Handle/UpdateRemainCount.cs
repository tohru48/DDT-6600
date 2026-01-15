using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagicStone.Handle
{
	[Attribute11(16)]
	public class UpdateRemainCount : IMagicStoneCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(258, Player.PlayerId);
			gSPacketIn.WriteByte(16);
			gSPacketIn.WriteInt(3333333);
			return true;
		}
	}
}
