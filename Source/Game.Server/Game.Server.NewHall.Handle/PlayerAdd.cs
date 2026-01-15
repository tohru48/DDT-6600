using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.NewHall.Handle
{
	[Attribute13(4)]
	public class PlayerAdd : INewHallCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int playerId = packet.ReadInt();
			WorldMgr.NewHallRooms.AddPlayerInfo(playerId);
			return true;
		}
	}
}
