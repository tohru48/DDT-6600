using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(90)]
	public class BoguAdventureEnter : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.Actives.LoadBoguAdventureFromDatabase())
			{
				Player.Actives.SendBoguAdventureEnter();
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("BoguAdventureEnter.LoadDataFail"));
			}
			return true;
		}
	}
}
