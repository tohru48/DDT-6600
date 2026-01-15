using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.NewHall.Handle
{
	[Attribute13(8)]
	public class PlayerShow : INewHallCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			Player.HideAllFriend = false;
			WorldMgr.NewHallRooms.HidePlayerInfo(Player);
			return true;
		}
	}
}
