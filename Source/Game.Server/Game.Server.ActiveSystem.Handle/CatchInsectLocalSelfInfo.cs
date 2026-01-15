using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(138)]
	public class CatchInsectLocalSelfInfo : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(138);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(1000);
			Player.Out.SendTCP(gSPacketIn);
			return true;
		}
	}
}
