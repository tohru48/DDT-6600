using System.Collections.Generic;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.GypsyShop.Handle
{
	[Attribute8(4)]
	public class GypsyShopRateItemInfo : IGypsyShopCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			List<MysteryShopInfo> rateMysteryShop = GypsyShopMgr.GetRateMysteryShop();
			GSPacketIn gSPacketIn = new GSPacketIn(278, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(4);
			gSPacketIn.WriteInt(rateMysteryShop.Count);
			foreach (MysteryShopInfo item in rateMysteryShop)
			{
				gSPacketIn.WriteInt(item.InfoID);
			}
			Player.Out.SendTCP(gSPacketIn);
			return false;
		}
	}
}
