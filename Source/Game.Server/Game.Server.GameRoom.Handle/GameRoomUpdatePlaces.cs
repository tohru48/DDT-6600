using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Rooms;

namespace Game.Server.GameRoom.Handle
{
	[Attribute7(10)]
	public class GameRoomUpdatePlaces : IGameRoomCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.CurrentRoom != null && Player == Player.CurrentRoom.Host)
			{
				byte pos = packet.ReadByte();
				int place = packet.ReadInt();
				bool isOpened = packet.ReadBoolean();
				int placeView = packet.ReadInt();
				RoomMgr.UpdateRoomPos(Player.CurrentRoom, pos, isOpened, place, placeView);
			}
			return true;
		}
	}
}
