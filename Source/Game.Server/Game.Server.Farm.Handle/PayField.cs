using System.Collections.Generic;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using Game.Server.Packets;

namespace Game.Server.Farm.Handle
{
	[Attribute5(6)]
	public class PayField : IFarmCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			string translation = LanguageMgr.GetTranslation("EnterFarmHandler.Msg11");
			List<int> list = new List<int>();
			int num = packet.ReadInt();
			for (int i = 0; i < num; i++)
			{
				int item = packet.ReadInt();
				list.Add(item);
			}
			int num2 = packet.ReadInt();
			PlayerFarm farm = Player.Farm;
			int value = ((farm.payFieldTimeToMonth() != num2) ? (num * farm.payFieldMoneyToWeek()) : (num * farm.payFieldMoneyToMonth()));
			if (Player.MoneyDirect(value))
			{
				farm.PayField(list, num2);
				Player.SendMessage(eMessageType.Normal, translation);
			}
			return true;
		}
	}
}
