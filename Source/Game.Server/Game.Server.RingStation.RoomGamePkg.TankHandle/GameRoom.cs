using System;
using Game.Base.Packets;

namespace Game.Server.RingStation.RoomGamePkg.TankHandle
{
	[GameCommandAttbute(94)]
	public class GameRoom : IGameCommandHandler
	{
		public bool HandleCommand(RingStationRoomLogicProcessor process, RingStationGamePlayer player, GSPacketIn packet)
		{
			byte b = packet.ReadByte();
			byte b2 = b;
			if (b2 == 5)
			{
				RingStationMgr.RemovePlayer(player.ID);
			}
			else
			{
				Console.WriteLine("RingStation.RoomGamePkg.TankHandle.GameRoom: {0}", b);
			}
			return true;
		}
	}
}
