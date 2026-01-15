using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Rooms;

namespace Game.Server.GameRoom.Handle
{
	[Attribute7(3)]
	public class GameRoomKick : IGameRoomCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.CurrentRoom != null && Player == Player.CurrentRoom.Host)
			{
				RoomMgr.KickPlayer(Player.CurrentRoom, packet.ReadByte());
			}
			return true;
		}
	}
}
