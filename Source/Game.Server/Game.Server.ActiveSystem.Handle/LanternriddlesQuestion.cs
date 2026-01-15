using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(38)]
	public class LanternriddlesQuestion : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			LanternriddlesInfo lanternriddlesInfo = ActiveSystemMgr.EnterLanternriddles(Player.PlayerCharacter.ID);
			Player.Actives.SendLightriddleQuestion(lanternriddlesInfo);
			if (!Player.Actives.LightriddleStart && lanternriddlesInfo.CanNextQuest)
			{
				Player.Actives.BeginLightriddleTimer();
			}
			return true;
		}
	}
}
