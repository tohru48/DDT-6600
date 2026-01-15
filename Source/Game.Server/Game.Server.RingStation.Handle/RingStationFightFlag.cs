using System;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.RingStation.Handle
{
	[Attribute15(6)]
	public class RingStationFightFlag : IRingStationCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(404, Player.PlayerId);
			gSPacketIn.WriteByte(6);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteDateTime(DateTime.Now);
			Player.SendTCP(gSPacketIn);
			return true;
		}
	}
}
