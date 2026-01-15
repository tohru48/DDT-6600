using System.Collections.Generic;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Rooms;

namespace Game.Server.GameRoom.Handle
{
	[Attribute7(9)]
	public class RoomListUpdate : IGameRoomCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			if (num2 == -2)
			{
				packet.ReadInt();
				packet.ReadInt();
			}
			List<BaseRoom> room = null;
			switch (num)
			{
			case 1:
				room = RoomMgr.GetAllMatchRooms();
				break;
			case 2:
				room = RoomMgr.GetAllPveRooms();
				break;
			}
			if (Player.CurrentRoom == null)
			{
				Player.Out.SendUpdateRoomList(room);
			}
			return true;
		}
	}
}
