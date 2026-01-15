using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;

namespace Game.Server.Farm.Handle
{
	[Attribute5(9)]
	public class HelperSwitchField : IFarmCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			string msg = LanguageMgr.GetTranslation("EnterFarmHandler.Msg6");
			bool flag = packet.ReadBoolean();
			int num = packet.ReadInt();
			int seedTime = packet.ReadInt();
			int num2 = packet.ReadInt();
			int getCount = packet.ReadInt();
			int num3 = packet.ReadInt();
			int num4 = packet.ReadInt();
			bool flag2 = false;
			if (flag)
			{
				if (Player.MoneyDirect(num4) && num3 == -1)
				{
					flag2 = true;
				}
				else if (Player.PlayerCharacter.DDTMoney < num4 || num3 != -2)
				{
					msg = ((num3 != -1) ? LanguageMgr.GetTranslation("EnterFarmHandler.Msg8") : LanguageMgr.GetTranslation("EnterFarmHandler.Msg7"));
				}
				else
				{
					Player.RemoveGiftToken(num4);
					flag2 = true;
				}
			}
			else
			{
				msg = LanguageMgr.GetTranslation("EnterFarmHandler.Msg9");
				Player.Farm.CropHelperSwitchField(isStopFarmHelper: true);
			}
			if (flag2)
			{
				msg = LanguageMgr.GetTranslation("EnterFarmHandler.Msg10");
				Player.Farm.HelperSwitchField(flag, num, seedTime, num2, getCount);
				Player.FarmBag.RemoveTemplate(num, num2);
			}
			Player.SendMessage(eMessageType.Normal, msg);
			return true;
		}
	}
}
