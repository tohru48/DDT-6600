using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Rooms;
using SqlDataProvider.Data;

namespace Game.Server.RingStation.Handle
{
	[Attribute15(5)]
	public class RingStationChallenge : IRingStationCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int playerId = packet.ReadInt();
			int rank = packet.ReadInt();
			UserRingStationInfo singleRingStationInfos = RingStationMgr.GetSingleRingStationInfos(Player.PlayerId);
			if (singleRingStationInfos.CanChallenge())
			{
				if (singleRingStationInfos.ChallengeNum > 0)
				{
					bool isAutoBot = false;
					UserRingStationInfo ringStationChallenge = RingStationMgr.GetRingStationChallenge(playerId, rank, ref isAutoBot);
					if (!ringStationChallenge.OnFight)
					{
						Player.DareFlag = new RingstationBattleFieldInfo();
						Player.DareFlag.DareFlag = true;
						Player.DareFlag.UserID = Player.PlayerCharacter.ID;
						Player.DareFlag.UserName = ringStationChallenge.Info.NickName;
						Player.DareFlag.BattleTime = DateTime.Now;
						Player.DareFlag.Level = singleRingStationInfos.Rank;
						if (!isAutoBot)
						{
							Player.SuccessFlag = new RingstationBattleFieldInfo();
							Player.SuccessFlag.DareFlag = false;
							Player.SuccessFlag.UserID = ringStationChallenge.Info.ID;
							Player.SuccessFlag.UserName = Player.PlayerCharacter.NickName;
							Player.SuccessFlag.BattleTime = DateTime.Now;
							Player.SuccessFlag.Level = ringStationChallenge.Rank;
						}
						RoomMgr.CreateRingStationRoom(Player, ringStationChallenge);
						ringStationChallenge.OnFight = true;
						RingStationMgr.UpdateRingStationFight(ringStationChallenge);
					}
					else
					{
						Player.SendMessage(LanguageMgr.GetTranslation("RingStationChallenge.OnFight", ringStationChallenge.Info.NickName));
					}
				}
				else
				{
					Player.SendMessage(LanguageMgr.GetTranslation("RingStationChallenge.Fail"));
				}
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("RingStationFightFlag.CdFail"));
			}
			return true;
		}
	}
}
