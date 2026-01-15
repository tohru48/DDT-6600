using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(122)]
	public class CloudBuyLotteryUpdateInfo : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			CloudBuyLotteryInfo cloudBuyLottery = CloudBuyLotteryMgr.GetCloudBuyLottery();
			if (cloudBuyLottery != null)
			{
				Player.Actives.SendCloudBuyLotteryUpdateInfos(cloudBuyLottery, isGame: true);
			}
			return true;
		}
	}
}
