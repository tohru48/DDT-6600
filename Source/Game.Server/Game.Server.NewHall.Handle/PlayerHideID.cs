using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.NewHall.Handle
{
	[Attribute13(7)]
	public class PlayerHideID : INewHallCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			Player.HideAllFriend = packet.ReadBoolean();
			WorldMgr.NewHallRooms.HidePlayerInfo(Player);
			return true;
		}
	}
}
