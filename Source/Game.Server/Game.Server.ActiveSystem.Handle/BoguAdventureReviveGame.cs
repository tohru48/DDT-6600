using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(92)]
	public class BoguAdventureReviveGame : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			BoguAdventureDataInfo boguAdventure = Player.Actives.BoguAdventure;
			if (num == 1)
			{
				if (boguAdventure.hp <= 0 && Player.MoneyDirect(Player.Actives.revivePrice))
				{
					boguAdventure.hp = 2;
					Player.SendMessage(LanguageMgr.GetTranslation("BoguAdventureReviveGame.Revive"));
					Player.Actives.SaveBoguAdventureDatabase();
				}
				GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
				gSPacketIn.WriteByte(92);
				gSPacketIn.WriteInt(boguAdventure.hp);
				Player.SendTCP(gSPacketIn);
			}
			else if (boguAdventure.currentIndex > 0 && boguAdventure.resetCount > 0 && Player.MoneyDirect(Player.Actives.resetPrice))
			{
				boguAdventure.resetCount--;
				Player.Actives.ResetAllBoguAdventure();
				Player.Actives.SendBoguAdventureEnter();
				Player.SendMessage(LanguageMgr.GetTranslation("BoguAdventureReviveGame.Reset"));
			}
			return true;
		}
	}
}
