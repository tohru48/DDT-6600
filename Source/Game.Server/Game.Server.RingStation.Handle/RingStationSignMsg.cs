using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.RingStation.Handle
{
	[Attribute15(7)]
	public class RingStationSignMsg : IRingStationCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			string signMsg = packet.ReadString();
			UserRingStationInfo singleRingStationInfos = RingStationMgr.GetSingleRingStationInfos(Player.PlayerId);
			singleRingStationInfos.signMsg = signMsg;
			RingStationMgr.UpdateRingStationInfo(singleRingStationInfos);
			return true;
		}
	}
}
