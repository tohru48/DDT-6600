using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(72)]
	public class EntertainmentBuyIcon : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			packet.ReadBoolean();
			int num = Player.FightBag.FindFirstEmptySlot();
			if (num == -1)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("EntertainmentBuyIcon.FightBagFull"));
			}
			else
			{
				int num2;
				if (Player.PlayerCharacter.DDTMoney < 50)
				{
					num2 = ((!Player.MoneyDirect(50)) ? 3 : 2);
				}
				else
				{
					Player.RemoveGiftToken(50);
					num2 = 1;
				}
				if (num2 > 0)
				{
					ItemInfo randomPropItem = WorldMgr.GetRandomPropItem(Player.FightBag.GetItems());
					if (randomPropItem != null)
					{
						randomPropItem.Count = 1;
						Player.FightBag.AddItemTo(randomPropItem, num);
					}
				}
				if (num2 == 3)
				{
					Player.SendMessage(LanguageMgr.GetTranslation("EntertainmentBuyIcon.DDTMoneyNotEnought"));
				}
			}
			return true;
		}
	}
}
