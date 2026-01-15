using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.DragonBoat.Handle
{
	[Attribute4(3)]
	public class DragonBoatRefreshBoatStatus : IDragonBoatCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(100);
			gSPacketIn.WriteByte(3);
			gSPacketIn.WriteInt(DragonBoatMgr.boatCompleteExp());
			Player.SendTCP(gSPacketIn);
			GSPacketIn gSPacketIn2 = new GSPacketIn(100);
			gSPacketIn2.WriteByte(2);
			gSPacketIn2.WriteInt(Player.Actives.Info.useableScore);
			gSPacketIn2.WriteInt(Player.Actives.Info.totalScore);
			Player.SendTCP(gSPacketIn2);
			return true;
		}
	}
}
