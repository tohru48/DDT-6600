using Game.Base.Packets;

namespace Game.Server.RingStation.RoomGamePkg.TankHandle
{
	[GameCommandAttbute(83)]
	public class Disconnect : IGameCommandHandler
	{
		public bool HandleCommand(RingStationRoomLogicProcessor process, RingStationGamePlayer player, GSPacketIn packet)
		{
			player.CurRoom.RemovePlayer(player);
			return true;
		}
	}
}
