using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.NewHall.Handle
{
	[Attribute13(2)]
	public class PlayerExit : INewHallCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int ıd = packet.ReadInt();
			WorldMgr.NewHallRooms.RemovePlayer(ıd);
			return true;
		}
	}
}
