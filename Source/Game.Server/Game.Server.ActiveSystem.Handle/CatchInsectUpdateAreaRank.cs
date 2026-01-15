using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(137)]
	public class CatchInsectUpdateAreaRank : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(137);
			gSPacketIn.WriteInt(0);
			Player.Out.SendTCP(gSPacketIn);
			return true;
		}
	}
}
