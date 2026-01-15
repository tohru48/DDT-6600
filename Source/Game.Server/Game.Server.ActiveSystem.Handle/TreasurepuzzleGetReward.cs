using System.Collections.Generic;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(105)]
	public class TreasurepuzzleGetReward : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt() - 1;
			TreasurePuzzleDataInfo[] treasurepuzzle = Player.Actives.Treasurepuzzle;
			if (num >= 0 && num <= treasurepuzzle.Length)
			{
				TreasurePuzzleDataInfo treasurePuzzleDataInfo = treasurepuzzle[num];
				if (treasurePuzzleDataInfo != null)
				{
					if (!treasurePuzzleDataInfo.canGetReward())
					{
						Player.SendMessage(LanguageMgr.GetTranslation("TreasurePuzzleEnter.PiceNotEnought"));
						return false;
					}
					if (treasurePuzzleDataInfo.canGetReward() && treasurePuzzleDataInfo.IsGetAward)
					{
						Player.SendMessage(LanguageMgr.GetTranslation("TreasurePuzzleEnter.GetComplete"));
						return false;
					}
					List<TreasurePuzzleRewardInfo> list = ActiveSystermAwardMgr.FindTreasurePuzzleReward(treasurePuzzleDataInfo.PuzzleID);
					List<ItemInfo> list2 = new List<ItemInfo>();
					foreach (TreasurePuzzleRewardInfo item in list)
					{
						ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(item.TemplateID);
						if (ıtemTemplateInfo != null)
						{
							ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 105);
							ıtemInfo.Count = item.Count;
							ıtemInfo.IsBinds = item.IsBinds;
							ıtemInfo.StrengthenLevel = item.StrengthenLevel;
							ıtemInfo.AttackCompose = item.AttackCompose;
							ıtemInfo.DefendCompose = item.DefendCompose;
							ıtemInfo.AgilityCompose = item.AgilityCompose;
							ıtemInfo.LuckCompose = item.LuckCompose;
							list2.Add(ıtemInfo);
						}
					}
					if (list2.Count > 0)
					{
						Player.Actives.Treasurepuzzle[num].IsGetAward = true;
						Player.Actives.TreasurepuzzleGetAward(num);
						treasurepuzzle = Player.Actives.Treasurepuzzle;
						WorldEventMgr.SendItemsToMail(list2, Player.PlayerCharacter.ID, Player.PlayerCharacter.NickName, LanguageMgr.GetTranslation("TreasurePuzzleEnter.Title"));
						GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
						gSPacketIn.WriteByte(108);
						gSPacketIn.WriteInt(treasurepuzzle.Length);
						TreasurePuzzleDataInfo[] array = treasurepuzzle;
						foreach (TreasurePuzzleDataInfo treasurePuzzleDataInfo2 in array)
						{
							gSPacketIn.WriteInt(treasurePuzzleDataInfo2.PuzzleID);
							gSPacketIn.WriteInt(treasurePuzzleDataInfo2.Int32_0);
							gSPacketIn.WriteInt(treasurePuzzleDataInfo2.Int32_1);
							gSPacketIn.WriteInt(treasurePuzzleDataInfo2.Int32_2);
							gSPacketIn.WriteInt(treasurePuzzleDataInfo2.Int32_3);
							gSPacketIn.WriteInt(treasurePuzzleDataInfo2.Int32_4);
							gSPacketIn.WriteInt(treasurePuzzleDataInfo2.Int32_5);
							gSPacketIn.WriteInt(treasurePuzzleDataInfo2.Int32_6);
							gSPacketIn.WriteInt(treasurePuzzleDataInfo2.Int32_7);
							gSPacketIn.WriteInt(treasurePuzzleDataInfo2.Int32_8);
							gSPacketIn.WriteInt(treasurePuzzleDataInfo2.Int32_9);
							gSPacketIn.WriteInt(treasurePuzzleDataInfo2.Int32_10);
							gSPacketIn.WriteInt(treasurePuzzleDataInfo2.Int32_11);
							gSPacketIn.WriteBoolean(treasurePuzzleDataInfo2.IsGetAward);
						}
						Player.SendTCP(gSPacketIn);
						Player.SendMessage(LanguageMgr.GetTranslation("TreasurePuzzleEnter.GetAwardTrue"));
						Player.Actives.SaveTreasurepuzzleDatabase();
					}
					else
					{
						Player.SendMessage(LanguageMgr.GetTranslation("TreasurePuzzleEnter.GetAwardFail2"));
					}
				}
				else
				{
					Player.SendMessage(LanguageMgr.GetTranslation("TreasurePuzzleEnter.GetAwardFail"));
				}
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("TreasurePuzzleEnter.GetAwardFail"));
			}
			return true;
		}
	}
}
