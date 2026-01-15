using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameObjects;
using Game.Server.Rooms;

namespace Game.Server.GameRoom.Handle
{
	[Attribute7(6)]
	public class GameChangeTeam : IGameRoomCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.CurrentRoom != null && Player.CurrentRoom.RoomType != eRoomType.Match)
			{
				RoomMgr.smethod_2(Player);
				return true;
			}
			return false;
		}
	}
}
