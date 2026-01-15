using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Farm.Handle
{
	[Attribute5(16)]
	public class ExitFarm : IFarmCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			Player.Farm.ExitFarm();
			return true;
		}
	}
}
