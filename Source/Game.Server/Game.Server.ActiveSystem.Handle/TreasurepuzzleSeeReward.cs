using System.Collections.Generic;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(104)]
	public class TreasurepuzzleSeeReward : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(104);
			TreasurePuzzleDataInfo[] treasurepuzzle = Player.Actives.Treasurepuzzle;
			gSPacketIn.WriteInt(treasurepuzzle.Length);
			TreasurePuzzleDataInfo[] array = treasurepuzzle;
			foreach (TreasurePuzzleDataInfo treasurePuzzleDataInfo in array)
			{
				gSPacketIn.WriteInt(treasurePuzzleDataInfo.PuzzleID);
				List<TreasurePuzzleRewardInfo> list = ActiveSystermAwardMgr.FindTreasurePuzzleReward(treasurePuzzleDataInfo.PuzzleID);
				if (list != null && list.Count > 0)
				{
					gSPacketIn.WriteBoolean(val: false);
					gSPacketIn.WriteInt(list.Count);
					foreach (TreasurePuzzleRewardInfo item in list)
					{
						gSPacketIn.WriteInt(item.TemplateID);
						gSPacketIn.WriteInt(item.Count);
					}
				}
				else
				{
					gSPacketIn.WriteBoolean(val: true);
				}
			}
			Player.SendTCP(gSPacketIn);
			return true;
		}
	}
}
