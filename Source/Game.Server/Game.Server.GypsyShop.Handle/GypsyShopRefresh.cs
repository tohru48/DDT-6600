using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.GypsyShop.Handle
{
	[Attribute8(5)]
	public class GypsyShopRefresh : IGypsyShopCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int curRefreshedTimes = Player.Actives.Info.CurRefreshedTimes;
			int num = curRefreshedTimes * curRefreshedTimes * 30 + 500;
			if (Player.PlayerCharacter.myHonor >= num)
			{
				Player.Actives.RefreshMysteryShop();
				Player.Actives.Info.CurRefreshedTimes++;
				Player.Actives.SendGypsyShopPlayerInfo();
				Player.RemoveHonor(num);
				Player.SendMessage(LanguageMgr.GetTranslation("GypsyShopRefresh.Success"));
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("GypsyShopRefresh.Fail"));
			}
			return false;
		}
	}
}
