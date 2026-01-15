using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.GameRoom.Handle
{
	[Attribute7(20)]
	public class GameEnergyNotEnough : IGameRoomCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.MissionEnergyEmpty(30))
			{
				Player.Out.SendNotEnoughEnergyBuy(MustBuy: false);
			}
			else
			{
				Player.Out.SendNotEnoughEnergyBuy(MustBuy: true);
			}
			return true;
		}
	}
}
