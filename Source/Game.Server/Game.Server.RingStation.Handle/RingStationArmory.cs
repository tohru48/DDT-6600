using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.RingStation.Handle
{
	[Attribute15(3)]
	public class RingStationArmory : IRingStationCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			UserRingStationInfo[] ringStationRanks = RingStationMgr.GetRingStationRanks();
			GSPacketIn gSPacketIn = new GSPacketIn(404, Player.PlayerId);
			gSPacketIn.WriteByte(3);
			gSPacketIn.WriteInt(ringStationRanks.Length);
			UserRingStationInfo[] array = ringStationRanks;
			foreach (UserRingStationInfo userRingStationInfo in array)
			{
				gSPacketIn.WriteInt(userRingStationInfo.Rank);
				gSPacketIn.WriteInt(userRingStationInfo.Info.Grade);
				gSPacketIn.WriteString(userRingStationInfo.Info.NickName);
				gSPacketIn.WriteInt(userRingStationInfo.Info.FightPower);
				gSPacketIn.WriteInt(userRingStationInfo.Info.Total);
			}
			Player.SendTCP(gSPacketIn);
			return true;
		}
	}
}
