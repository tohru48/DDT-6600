using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(26)]
	public class ChristmasPacks : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			UserChristmasInfo christmas = Player.Actives.Christmas;
			string title = "Event Noel";
			int num = packet.ReadInt();
			if (DateTime.Compare(Player.LastOpenChristmasPackage.AddSeconds(1.0), DateTime.Now) > 0)
			{
				return false;
			}
			if (christmas.packsNumber >= GameProperties.ChristmasGiftsMaxNum - 1)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("ActiveSystemHandler.Msg6"));
				return false;
			}
			string[] array = GameProperties.ChristmasGifts.Split('|');
			string text = "";
			int num2 = 0;
			string[] array2 = array;
			foreach (string text2 in array2)
			{
				if (!(text2.Split(',')[0] == num.ToString()))
				{
					num2++;
					continue;
				}
				text = text2;
				break;
			}
			if (!(text != ""))
			{
				Player.SendMessage(LanguageMgr.GetTranslation("ActiveSystemHandler.Msg8"));
				return false;
			}
			int num3 = int.Parse(text.Split(',')[1]);
			if (((christmas.awardState >> num2) & 1) != 0)
			{
				return false;
			}
			if (num2 >= array.Length - 1)
			{
				string text3 = array[num2 - 1];
				num3 += int.Parse(text3.Split(',')[1]);
			}
			if (num3 <= christmas.count)
			{
				christmas.packsNumber++;
				christmas.awardState |= 1 << num2;
				Player.SendMessage(LanguageMgr.GetTranslation("ActiveSystemHandler.Msg4"));
				Player.SendItemToMail(num, "", title);
				gSPacketIn.WriteByte(26);
				gSPacketIn.WriteInt(christmas.awardState);
				gSPacketIn.WriteInt(christmas.packsNumber);
				gSPacketIn.WriteInt(num);
				Player.Out.SendTCP(gSPacketIn);
				Player.LastOpenChristmasPackage = DateTime.Now;
				return true;
			}
			Player.SendMessage(LanguageMgr.GetTranslation("ActiveSystemHandler.Msg7"));
			return false;
		}
	}
}
