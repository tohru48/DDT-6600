using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(24)]
	public class ChristmasMakingSnowmanEnter : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			UserChristmasInfo christmas = Player.Actives.Christmas;
			gSPacketIn.WriteByte(24);
			gSPacketIn.WriteInt(christmas.count);
			gSPacketIn.WriteInt(christmas.exp);
			gSPacketIn.WriteInt(christmas.awardState);
			gSPacketIn.WriteInt(christmas.packsNumber);
			Player.Out.SendTCP(gSPacketIn);
			return true;
		}
	}
}
