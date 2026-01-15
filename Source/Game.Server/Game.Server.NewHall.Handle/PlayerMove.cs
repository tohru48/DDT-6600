using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.NewHall.Handle
{
	[Attribute13(3)]
	public class PlayerMove : INewHallCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int x = packet.ReadInt();
			int y = packet.ReadInt();
			WorldMgr.NewHallRooms.PlayerMove(Player.PlayerId, x, y);
			return true;
		}
	}
}
