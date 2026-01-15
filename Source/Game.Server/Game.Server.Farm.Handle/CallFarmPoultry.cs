using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Farm.Handle
{
	[Attribute5(23)]
	public class CallFarmPoultry : IFarmCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			packet.ReadInt();
			Player.Farm.CurrentFarm.PoultryState = 1;
			Player.Farm.SendUpdateFarmPoultry();
			Player.SendMessage(LanguageMgr.GetTranslation("CallFarmPoultry.Msg1"));
			return true;
		}
	}
}
