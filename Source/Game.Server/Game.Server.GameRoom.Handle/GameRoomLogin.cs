using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Rooms;

namespace Game.Server.GameRoom.Handle
{
	[Attribute7(1)]
	public class GameRoomLogin : IGameRoomCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			packet.ReadBoolean();
			int type = packet.ReadInt();
			int num = packet.ReadInt();
			int roomId = -1;
			string pwd = null;
			if (num == -1)
			{
				roomId = packet.ReadInt();
				pwd = packet.ReadString();
			}
			RoomMgr.EnterRoom(Player, roomId, pwd, type);
			return true;
		}
	}
}
