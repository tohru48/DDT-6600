using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Horse.Handle
{
	[Attribute9(2)]
	public class ChangeHorse : IHorseCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			Player.PlayerCharacter.MountsType = num;
			Player.Horse.Info.curUseHorse = num;
			if (num == 0)
			{
				Player.EquipBag.UpdatePlayerProperties();
				Player.Horse.UpdateProperties = false;
				Player.SendMessage(LanguageMgr.GetTranslation("ChangeHorse.Msg1"));
			}
			else if (!Player.Horse.UpdateProperties)
			{
				Player.EquipBag.UpdatePlayerProperties();
				Player.Horse.UpdateProperties = true;
				Player.SendMessage(LanguageMgr.GetTranslation("ChangeHorse.Msg2"));
			}
			Player.Horse.ActiveHorsePicCherish(num);
			Player.Out.SendchangeHorse(num);
			return true;
		}
	}
}
