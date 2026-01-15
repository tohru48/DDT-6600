using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.GypsyShop.Handle
{
	[Attribute8(2)]
	public class GypsyShopPlayerInfo : IGypsyShopCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.Actives.LoadGypsyItemDataFromDatabase())
			{
				Player.Actives.SendGypsyShopPlayerInfo();
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("GypsyShopPlayerInfo.LoadDataFail"));
			}
			return false;
		}
	}
}
