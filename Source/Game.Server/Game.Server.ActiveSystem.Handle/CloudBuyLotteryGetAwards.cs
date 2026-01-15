using System.Collections.Generic;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(119)]
	public class CloudBuyLotteryGetAwards : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(119);
			if (Player.Actives.Info.remainTimes > 0)
			{
				List<ItemInfo> eventAwardByType = EventAwardMgr.GetEventAwardByType(eEventType.CLOUD_BUY_LOTTERY);
				if (eventAwardByType.Count > 0)
				{
					ItemInfo ıtemInfo = eventAwardByType[0];
					Player.Actives.Info.remainTimes--;
					gSPacketIn.WriteBoolean(val: true);
					gSPacketIn.WriteInt(Player.Actives.Info.remainTimes);
					gSPacketIn.WriteInt(ıtemInfo.TemplateID);
					Player.AddTemplate(ıtemInfo);
				}
				else
				{
					gSPacketIn.WriteBoolean(val: false);
				}
			}
			else
			{
				gSPacketIn.WriteBoolean(val: false);
				Player.SendMessage(LanguageMgr.GetTranslation("CloudBuyLotteryGetAwards.Fail"));
			}
			Player.Out.SendTCP(gSPacketIn);
			return true;
		}
	}
}
