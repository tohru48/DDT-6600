using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.RingStation.Handle
{
	[Attribute15(2)]
	public class RingStationBuyBattleCountOrTime : IRingStationCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			bool flag = packet.ReadBoolean();
			packet.ReadBoolean();
			GSPacketIn gSPacketIn = new GSPacketIn(404, Player.PlayerId);
			gSPacketIn.WriteByte(2);
			UserRingStationInfo singleRingStationInfos = RingStationMgr.GetSingleRingStationInfos(Player.PlayerId);
			gSPacketIn.WriteBoolean(flag);
			if (flag)
			{
				if (Player.MoneyDirect(RingStationMgr.ConfigInfo.buyPrice))
				{
					gSPacketIn.WriteBoolean(val: true);
					singleRingStationInfos.ChallengeTime = DateTime.Now;
					singleRingStationInfos.ChallengeTime = DateTime.Now.AddMinutes(-1.0);
					RingStationMgr.UpdateRingStationInfo(singleRingStationInfos);
					Player.SendMessage(LanguageMgr.GetTranslation("RingStationBuyBattleCountOrTime.ClearTime"));
				}
				else
				{
					gSPacketIn.WriteBoolean(val: false);
				}
				Player.SendTCP(gSPacketIn);
			}
			else if (Player.MoneyDirect(RingStationMgr.ConfigInfo.buyPrice))
			{
				if (singleRingStationInfos.buyCount > 0)
				{
					singleRingStationInfos.buyCount--;
					singleRingStationInfos.ChallengeNum++;
					RingStationMgr.UpdateRingStationInfo(singleRingStationInfos);
					Player.SendMessage(LanguageMgr.GetTranslation("RingStationBuyBattleCountOrTime.BuyChallenge"));
				}
				else
				{
					Player.SendMessage(LanguageMgr.GetTranslation("RingStationBuyBattleCountOrTime.Limit"));
				}
				gSPacketIn.WriteInt(singleRingStationInfos.buyCount);
				gSPacketIn.WriteInt(singleRingStationInfos.ChallengeNum);
				Player.SendTCP(gSPacketIn);
			}
			return true;
		}
	}
}
