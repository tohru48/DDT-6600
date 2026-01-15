using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(132)]
	public class CatchInsectAreaSelfInfo : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(132);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(5000);
			Player.Out.SendTCP(gSPacketIn);
			return true;
		}
	}
}
