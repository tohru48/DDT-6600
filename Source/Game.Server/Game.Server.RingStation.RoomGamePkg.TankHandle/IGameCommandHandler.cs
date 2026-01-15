using Game.Base.Packets;

namespace Game.Server.RingStation.RoomGamePkg.TankHandle
{
	public interface IGameCommandHandler
	{
		bool HandleCommand(RingStationRoomLogicProcessor process, RingStationGamePlayer player, GSPacketIn packet);
	}
}
