using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.WorshipTheMoon.Handle
{
	[Attribute16(2)]
	public class WorshipTheMoonFreeCounts : IWorshipTheMoonCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.Actives.Info.lastEnterWorshiped.Date < DateTime.Now.Date)
			{
				Player.Actives.Info.updateFreeCounts = int.Parse(GameProperties.WorshipMoonPriceInfo.Split('|')[0]);
				Player.Actives.Info.lastEnterWorshiped = DateTime.Now;
			}
			Player.Actives.SendUpdateFreeCount();
			return false;
		}
	}
}
