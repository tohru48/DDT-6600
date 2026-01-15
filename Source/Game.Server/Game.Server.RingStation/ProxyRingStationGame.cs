using Game.Base;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.RingStation.Battle;

namespace Game.Server.RingStation
{
	public class ProxyRingStationGame : AbstractGame
	{
		private RingStationFightConnector ringStationFightConnector_0;

		public ProxyRingStationGame(int id, RingStationFightConnector fightServer, eRoomType roomType, eGameType gameType, int timeType)
			: base(id, roomType, gameType, timeType)
		{
			ringStationFightConnector_0 = fightServer;
			ringStationFightConnector_0.Disconnected += method_0;
		}

		private void method_0(BaseClient baseClient_0)
		{
			Stop();
		}

		public override void ProcessData(GSPacketIn pkg)
		{
			ringStationFightConnector_0.SendToGame(base.Id, pkg);
		}
	}
}
