using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameObjects;
using Game.Server.Rooms;

namespace Game.Server.GameRoom.Handle
{
	[Attribute7(5)]
	public class GameRoomRemovePlayer : IGameRoomCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.CurrentRoom != null)
			{
				if (Player.CurrentRoom.RoomType == eRoomType.ActivityDungeon)
				{
					Player.Actives.method_6();
				}
				RoomMgr.ExitRoom(Player.CurrentRoom, Player);
			}
			return true;
		}
	}
}
