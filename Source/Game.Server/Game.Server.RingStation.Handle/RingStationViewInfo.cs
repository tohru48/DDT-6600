using System;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.RingStation.Handle
{
	[Attribute15(1)]
	public class RingStationViewInfo : IRingStationCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			RingStationMgr.LoadRingStationInfo(Player.PlayerCharacter, (int)Player.BaseAttack, (int)Player.BaseDefence);
			GSPacketIn gSPacketIn = new GSPacketIn(404, Player.PlayerId);
			UserRingStationInfo singleRingStationInfos = RingStationMgr.GetSingleRingStationInfos(Player.PlayerId);
			if (singleRingStationInfos.LastDate.Date < DateTime.Now.Date)
			{
				singleRingStationInfos.LastDate = DateTime.Now;
				singleRingStationInfos.ChallengeNum = RingStationMgr.ConfigInfo.ChallengeNum;
				singleRingStationInfos.buyCount = RingStationMgr.ConfigInfo.buyCount;
				RingStationMgr.UpdateRingStationInfo(singleRingStationInfos);
			}
			RingstationConfigInfo configInfo = RingStationMgr.ConfigInfo;
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(singleRingStationInfos.Rank);
			gSPacketIn.WriteInt(singleRingStationInfos.ChallengeNum);
			gSPacketIn.WriteInt(singleRingStationInfos.buyCount);
			gSPacketIn.WriteInt(configInfo.buyPrice);
			gSPacketIn.WriteDateTime(singleRingStationInfos.ChallengeTime);
			gSPacketIn.WriteInt(configInfo.cdPrice);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteString(singleRingStationInfos.signMsg);
			gSPacketIn.WriteInt(configInfo.AwardNumByRank(singleRingStationInfos.Rank));
			gSPacketIn.WriteDateTime(configInfo.AwardTime);
			gSPacketIn.WriteString(configInfo.ChampionText);
			UserRingStationInfo[] ringStationInfos = RingStationMgr.GetRingStationInfos(singleRingStationInfos.UserID, singleRingStationInfos.Rank);
			gSPacketIn.WriteInt(ringStationInfos.Length);
			UserRingStationInfo[] array = ringStationInfos;
			foreach (UserRingStationInfo userRingStationInfo in array)
			{
				PlayerInfo ınfo = userRingStationInfo.Info;
				gSPacketIn.WriteInt(ınfo.ID);
				gSPacketIn.WriteString(ınfo.UserName);
				gSPacketIn.WriteString(ınfo.NickName);
				gSPacketIn.WriteByte(ınfo.typeVIP);
				gSPacketIn.WriteInt(ınfo.VIPLevel);
				gSPacketIn.WriteInt(ınfo.Grade);
				gSPacketIn.WriteBoolean(ınfo.Sex);
				gSPacketIn.WriteString(ınfo.Style);
				gSPacketIn.WriteString(ınfo.Colors);
				gSPacketIn.WriteString(ınfo.Skin);
				gSPacketIn.WriteString(ınfo.ConsortiaName);
				gSPacketIn.WriteInt(ınfo.Hide);
				gSPacketIn.WriteInt(ınfo.Offer);
				gSPacketIn.WriteInt(ınfo.Win);
				gSPacketIn.WriteInt(ınfo.Total);
				gSPacketIn.WriteInt(ınfo.Escape);
				gSPacketIn.WriteInt(ınfo.Repute);
				gSPacketIn.WriteInt(ınfo.Nimbus);
				gSPacketIn.WriteInt(ınfo.GP);
				gSPacketIn.WriteInt(ınfo.FightPower);
				gSPacketIn.WriteInt(ınfo.AchievementPoint);
				gSPacketIn.WriteInt(userRingStationInfo.Rank);
				gSPacketIn.WriteInt(userRingStationInfo.WeaponID);
				gSPacketIn.WriteString(userRingStationInfo.signMsg);
			}
			Player.SendTCP(gSPacketIn);
			return true;
		}
	}
}
