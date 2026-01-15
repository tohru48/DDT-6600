using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.NewHall.Handle
{
	[Attribute13(9)]
	public class UpdatePets : INewHallCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			packet.ReadBoolean();
			int playerId = packet.ReadInt();
			int petsId = packet.ReadInt();
			WorldMgr.NewHallRooms.UpdatePets(playerId, petsId);
			return true;
		}
	}
}
