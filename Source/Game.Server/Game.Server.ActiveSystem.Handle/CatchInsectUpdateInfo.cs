using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(135)]
	public class CatchInsectUpdateInfo : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(135);
			gSPacketIn.WriteInt(Player.Extra.Info.Score);
			gSPacketIn.WriteInt(Player.Extra.Info.SummerScore);
			gSPacketIn.WriteInt(Player.Extra.Info.PrizeStatus);
			Player.Out.SendTCP(gSPacketIn);
			return true;
		}
	}
}
