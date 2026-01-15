using System;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(139)]
	public class CatchInsectGetPrize : IActiveSystemCommandHadler
	{
		public int calculateStatusValue(int[] awardButtons)
		{
			int num = 0;
			for (int i = 0; i < awardButtons.Length; i++)
			{
				num += (int)Math.Pow(2.0, awardButtons[i] - 1);
			}
			return num;
		}

		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			string[] array = GameProperties.SummerAcitveGifts.Split('|');
			int num2 = 0;
			int num3 = 0;
			int num4 = 0;
			string[] array2 = array;
			foreach (string text in array2)
			{
				num2 = int.Parse(text.Split(',')[0]);
				num3 = int.Parse(text.Split(',')[1]);
				num4++;
				if (num2 == num)
				{
					if (num4 - 1 < Player.Extra.PrizeStatus.Length && Player.Extra.PrizeStatus[num4 - 1] == 0)
					{
						Player.Extra.PrizeStatus[num4 - 1] = num4;
					}
					break;
				}
			}
			if (num3 > 0 && num3 <= Player.Extra.Info.Score)
			{
				GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
				gSPacketIn.WriteByte(135);
				gSPacketIn.WriteInt(Player.Extra.Info.Score);
				gSPacketIn.WriteInt(Player.Extra.Info.SummerScore);
				gSPacketIn.WriteInt(Player.Extra.Info.PrizeStatus);
				Player.Out.SendTCP(gSPacketIn);
				ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(num2);
				if (ıtemTemplateInfo != null)
				{
					ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 105);
					ıtemInfo.IsBinds = true;
					Player.AddTemplate(ıtemInfo);
				}
				Player.SendMessage(LanguageMgr.GetTranslation("CatchInsectGetPrize.Success"));
				Player.Extra.Info.PrizeStatus = calculateStatusValue(Player.Extra.PrizeStatus);
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("CatchInsectGetPrize.NotEnoughtSummerScore"));
			}
			return true;
		}
	}
}
