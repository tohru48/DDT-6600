using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagicStone.Handle
{
	[Attribute11(4)]
	public class StoneScore : IMagicStoneCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(258, Player.PlayerId);
			gSPacketIn.WriteByte(4);
			gSPacketIn.WriteInt(Player.Extra.Info.ScoreMagicstone);
			Player.SendTCP(gSPacketIn);
			return true;
		}
	}
}
