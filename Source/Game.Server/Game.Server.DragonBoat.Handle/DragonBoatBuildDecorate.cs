using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.DragonBoat.Handle
{
	[Attribute4(2)]
	public class DragonBoatBuildDecorate : IDragonBoatCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.PlayerCharacter.HasBagPassword && Player.PlayerCharacter.IsLocked)
			{
				Player.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return false;
			}
			GSPacketIn gSPacketIn = new GSPacketIn(100);
			ActiveSystemInfo ınfo = Player.Actives.Info;
			byte b = packet.ReadByte();
			int num = packet.ReadInt();
			if (num <= 0)
			{
				return false;
			}
			CommunalActiveInfo communalActiveInfo = CommunalActiveMgr.FindCommunalActive(1);
			if (communalActiveInfo != null && communalActiveInfo.LimitGrade > Player.PlayerCharacter.Grade)
			{
				Player.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("DragonBoatHandler.Msg2", communalActiveInfo.LimitGrade));
				return false;
			}
			if (DragonBoatMgr.periodType() == 2)
			{
				Player.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("DragonBoatHandler.Msg3"));
				return false;
			}
			if (ınfo.useableScore >= int.MaxValue)
			{
				Player.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("DragonBoatHandler.Msg4"));
				return false;
			}
			int num2 = DragonBoatMgr.DayMaxScore();
			if (ınfo.dayScore < num2)
			{
				int num3 = DragonBoatMgr.DRAGONBOAT_CHIP;
				if (DragonBoatMgr.OpenType() == 4)
				{
					num3 = DragonBoatMgr.KINGSTATUE_CHIP;
				}
				ItemInfo ıtemByTemplateID = Player.GetItemByTemplateID(num3);
				string[] array = DragonBoatMgr.AddPropertyByMoney().Split(',');
				int num4 = int.Parse(array[1]);
				int num5 = int.Parse(array[0].Split(':')[0]);
				int num6 = num4 * num;
				bool flag = false;
				byte b2 = b;
				if (b2 == 1)
				{
					if (ıtemByTemplateID == null)
					{
						Player.SendMessage(LanguageMgr.GetTranslation("DragonBoatHandler.Msg5", ıtemByTemplateID.Template.Name));
					}
					else
					{
						if (ıtemByTemplateID.Count < num)
						{
							num = ıtemByTemplateID.Count;
						}
						array = DragonBoatMgr.AddPropertyByProp().Split(',');
						num4 = int.Parse(array[1]);
						num5 = int.Parse(array[0].Split(':')[0]);
						num6 = num4 * num;
						if (ınfo.dayScore + num6 > num2)
						{
							num = (num2 - ınfo.dayScore) / num4;
						}
						int count = num * num5;
						flag = Player.RemoveTemplate(num3, count);
					}
				}
				else
				{
					if (ınfo.dayScore + num6 > num2)
					{
						num = (num2 - ınfo.dayScore) / num4;
					}
					int value = num * num5;
					flag = Player.ActiveMoneyEnable(value);
				}
				if (flag)
				{
					num6 = num4 * num;
					ınfo.totalScore += num6;
					ınfo.useableScore += num6;
					ınfo.dayScore += num6;
					Player.SendMessage(LanguageMgr.GetTranslation("DragonBoatHandler.Msg6"));
					DragonBoatMgr.UpdateLocalBoatExp(ınfo);
				}
				gSPacketIn.WriteByte(2);
				gSPacketIn.WriteInt(ınfo.useableScore);
				gSPacketIn.WriteInt(ınfo.totalScore);
				Player.SendTCP(gSPacketIn);
				GSPacketIn gSPacketIn2 = new GSPacketIn(100);
				gSPacketIn2.WriteByte(3);
				gSPacketIn2.WriteInt(DragonBoatMgr.boatCompleteExp());
				Player.SendTCP(gSPacketIn2);
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("DragonBoatHandler.MaxDayScore"));
			}
			return true;
		}
	}
}
