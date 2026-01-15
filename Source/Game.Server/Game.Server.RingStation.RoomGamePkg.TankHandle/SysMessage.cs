using Game.Base.Packets;

namespace Game.Server.RingStation.RoomGamePkg.TankHandle
{
	[GameCommandAttbute(3)]
	public class SysMessage : IGameCommandHandler
	{
		public bool HandleCommand(RingStationRoomLogicProcessor process, RingStationGamePlayer player, GSPacketIn packet)
		{
			return true;
		}
	}
}
