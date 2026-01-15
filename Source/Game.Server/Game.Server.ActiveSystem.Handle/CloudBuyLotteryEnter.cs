using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(118)]
	public class CloudBuyLotteryEnter : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			CloudBuyLotteryInfo cloudBuyLotteryInfo = CloudBuyLotteryMgr.GetCloudBuyLottery();
			bool isGame = true;
			if (cloudBuyLotteryInfo == null)
			{
				isGame = false;
				cloudBuyLotteryInfo = new CloudBuyLotteryInfo();
				cloudBuyLotteryInfo.templateId = 13314;
				cloudBuyLotteryInfo.templatedIdCount = 1;
				cloudBuyLotteryInfo.validDate = 0;
				cloudBuyLotteryInfo.property = "0,0,0,0,0";
				cloudBuyLotteryInfo.buyItemsArr = "11166|1";
				cloudBuyLotteryInfo.buyMoney = 50;
				cloudBuyLotteryInfo.maxNum = 500;
				cloudBuyLotteryInfo.currentNum = 500;
			}
			Player.Actives.SendCloudBuyLotteryEnter(cloudBuyLotteryInfo, isGame);
			return true;
		}
	}
}
