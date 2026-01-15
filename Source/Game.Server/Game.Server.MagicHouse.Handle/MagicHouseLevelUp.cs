using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.MagicHouse.Handle
{
	[Attribute10(2)]
	public class MagicHouseLevelUp : IMagicHouseCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			ItemInfo ıtemByTemplateID = Player.PropBag.GetItemByTemplateID(201489);
			if (ıtemByTemplateID != null)
			{
				if (num2 > ıtemByTemplateID.Count || num2 < 1)
				{
					num2 = ıtemByTemplateID.Count;
				}
				int[] array = Player.MagicHouse.LevelUpExp();
				string translation = LanguageMgr.GetTranslation("MagicHouseLevelUp.LevelUpFail");
				int num3 = ıtemByTemplateID.Template.Property1 * num2;
				switch (num)
				{
				case 1:
				{
					int magicJuniorLv = Player.MagicHouse.Info.magicJuniorLv;
					if (magicJuniorLv < array.Length)
					{
						Player.MagicHouse.Info.magicJuniorExp += num3;
						if (Player.MagicHouse.Info.magicJuniorExp >= array[magicJuniorLv])
						{
							Player.MagicHouse.Info.magicJuniorLv++;
							int magicJuniorExp = Player.MagicHouse.Info.magicJuniorExp - array[magicJuniorLv];
							Player.MagicHouse.Info.magicJuniorExp = magicJuniorExp;
							translation = LanguageMgr.GetTranslation("MagicHouseLevelUp.LevelUp");
							Player.EquipBag.UpdatePlayerProperties();
						}
						else
						{
							translation = LanguageMgr.GetTranslation("MagicHouseLevelUp.AddExp", num3);
						}
					}
					else
					{
						translation = LanguageMgr.GetTranslation("MagicHouseLevelUp.MaxLevel");
					}
					break;
				}
				case 2:
				{
					int magicMidLv = Player.MagicHouse.Info.magicMidLv;
					if (magicMidLv < array.Length)
					{
						Player.MagicHouse.Info.magicMidExp += num3;
						if (Player.MagicHouse.Info.magicMidExp >= array[magicMidLv])
						{
							Player.MagicHouse.Info.magicMidLv++;
							int magicMidExp = Player.MagicHouse.Info.magicMidExp - array[magicMidLv];
							Player.MagicHouse.Info.magicMidExp = magicMidExp;
							translation = LanguageMgr.GetTranslation("MagicHouseLevelUp.LevelUp");
						}
						else
						{
							translation = LanguageMgr.GetTranslation("MagicHouseLevelUp.AddExp", num3);
						}
					}
					else
					{
						translation = LanguageMgr.GetTranslation("MagicHouseLevelUp.MaxLevel");
					}
					break;
				}
				case 3:
				{
					int magicSeniorLv = Player.MagicHouse.Info.magicSeniorLv;
					if (magicSeniorLv < array.Length)
					{
						Player.MagicHouse.Info.magicSeniorExp += num3;
						if (Player.MagicHouse.Info.magicSeniorExp >= array[magicSeniorLv])
						{
							Player.MagicHouse.Info.magicSeniorLv++;
							int magicSeniorExp = Player.MagicHouse.Info.magicSeniorExp - array[magicSeniorLv];
							Player.MagicHouse.Info.magicSeniorExp = magicSeniorExp;
							translation = LanguageMgr.GetTranslation("MagicHouseLevelUp.LevelUp");
						}
						else
						{
							translation = LanguageMgr.GetTranslation("MagicHouseLevelUp.AddExp", num3);
						}
					}
					else
					{
						translation = LanguageMgr.GetTranslation("MagicHouseLevelUp.MaxLevel");
					}
					break;
				}
				}
				Player.MagicHouse.UpdateMessage();
				Player.SendMessage(translation);
				Player.PropBag.RemoveTemplate(201489, num2);
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("MagicHouseLevelUp.ItemNotFound"));
			}
			return false;
		}
	}
}
