using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;

namespace Game.Server.MagicHouse.Handle
{
	[Attribute10(5)]
	public class MagicHouseOpenDepot : IMagicHouseCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.PlayerCharacter.HasBagPassword && Player.PlayerCharacter.IsLocked)
			{
				Player.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return false;
			}
			int num = packet.ReadInt();
			int num2 = 0;
			int[] array = Player.MagicHouse.OpenNeedMoney();
			int depotCount = Player.MagicHouse.Info.depotCount;
			if (num + 1 > depotCount && num < Player.MagicHouse.BaseDepotCount * 10)
			{
				for (int i = depotCount; i < num + 1; i++)
				{
					num2 += array[0] + (i + 1 - Player.MagicHouse.BaseDepotCount - 1) * array[1];
				}
				if (Player.MoneyDirect(num2))
				{
					Player.MagicHouse.Info.depotCount += num + 1 - depotCount;
					Player.SendMessage(LanguageMgr.GetTranslation("MagicHouseOpenDepot.OpenSuccess"));
				}
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("MagicHouseOpenDepot.Error"));
			}
			Player.MagicHouse.UpdateMessage();
			return false;
		}
	}
}
