using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(103)]
	public class TreasurePuzzleEnter : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.Actives.LoadTreasurePuzzleFromDatabase())
			{
				TreasurePuzzleDataInfo[] treasurepuzzle = Player.Actives.Treasurepuzzle;
				GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
				gSPacketIn.WriteByte(103);
				gSPacketIn.WriteInt(treasurepuzzle.Length);
				TreasurePuzzleDataInfo[] array = treasurepuzzle;
				foreach (TreasurePuzzleDataInfo treasurePuzzleDataInfo in array)
				{
					gSPacketIn.WriteInt(treasurePuzzleDataInfo.PuzzleID);
					gSPacketIn.WriteInt(treasurePuzzleDataInfo.Int32_0);
					gSPacketIn.WriteInt(treasurePuzzleDataInfo.Int32_1);
					gSPacketIn.WriteInt(treasurePuzzleDataInfo.Int32_2);
					gSPacketIn.WriteInt(treasurePuzzleDataInfo.Int32_3);
					gSPacketIn.WriteInt(treasurePuzzleDataInfo.Int32_4);
					gSPacketIn.WriteInt(treasurePuzzleDataInfo.Int32_5);
					gSPacketIn.WriteInt(treasurePuzzleDataInfo.Int32_6);
					gSPacketIn.WriteInt(treasurePuzzleDataInfo.Int32_7);
					gSPacketIn.WriteInt(treasurePuzzleDataInfo.Int32_8);
					gSPacketIn.WriteInt(treasurePuzzleDataInfo.Int32_9);
					gSPacketIn.WriteInt(treasurePuzzleDataInfo.Int32_10);
					gSPacketIn.WriteInt(treasurePuzzleDataInfo.Int32_11);
					gSPacketIn.WriteBoolean(treasurePuzzleDataInfo.IsGetAward);
				}
				Player.SendTCP(gSPacketIn);
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("TreasurePuzzleEnter.LoadDataFail"));
			}
			return true;
		}
	}
}
