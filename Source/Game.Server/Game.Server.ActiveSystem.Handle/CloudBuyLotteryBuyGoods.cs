using System;
using System.Collections.Generic;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(120)]
	public class CloudBuyLotteryBuyGoods : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			if (num <= 0)
			{
				num = 1;
			}
			CloudBuyLotteryInfo cloudBuyLottery = CloudBuyLotteryMgr.GetCloudBuyLottery();
			if (cloudBuyLottery != null)
			{
				if (num > cloudBuyLottery.currentNum)
				{
					num = cloudBuyLottery.currentNum;
				}
				int num2 = cloudBuyLottery.buyMoney * num;
				if (Player.MoneyDirect(num2))
				{
					List<ItemInfo> list = new List<ItemInfo>();
					string[] array = cloudBuyLottery.buyItemsArr.Split(',');
					for (int i = 0; i < array.Length; i++)
					{
						string[] array2 = array[i].Split('|');
						ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(int.Parse(array2[0]));
						if (ıtemTemplateInfo != null)
						{
							ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 105);
							ıtemInfo.IsBinds = true;
							ıtemInfo.Count = int.Parse(array2[1]);
							list.Add(ıtemInfo);
						}
					}
					Player.AddTemplate(list);
					bool isGetAward = false;
					CloudBuyLotteryMgr.UpdateCloudBuyLottery(num, ref isGetAward);
					Player.Actives.Info.luckCount += num;
					int num3 = Math.Abs(num2 / GameProperties.CloudBuyLotteryExchangeScore);
					if (num3 > 0)
					{
						Player.Actives.Info.remainTimes += num3;
					}
					if (!isGetAward)
					{
						Player.Actives.SendCloudBuyLotteryUpdateInfos(cloudBuyLottery, isGame: true);
					}
					Player.SendMessage(LanguageMgr.GetTranslation("CloudBuyLotteryBuyGoods.Success", num3));
					Player.Actives.SaveActiveToDatabase();
				}
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("CloudBuyLotteryBuyGoods.Fail"));
			}
			return true;
		}
	}
}
