using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(136)]
	public class CatchInsectUpdateLocalRank : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(136);
			gSPacketIn.WriteInt(0);
			Player.Out.SendTCP(gSPacketIn);
			return true;
		}
	}
}
