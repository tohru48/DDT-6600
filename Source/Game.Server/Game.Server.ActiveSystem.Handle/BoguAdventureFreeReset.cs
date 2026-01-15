using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(99)]
	public class BoguAdventureFreeReset : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.Actives.BoguAdventure.isFreeReset)
			{
				Player.Actives.BoguAdventure.isFreeReset = false;
				Player.Actives.ResetAllBoguAdventure();
				Player.Actives.SendBoguAdventureEnter();
				Player.SendMessage(LanguageMgr.GetTranslation("BoguAdventureReviveGame.FreeReset"));
			}
			return true;
		}
	}
}
