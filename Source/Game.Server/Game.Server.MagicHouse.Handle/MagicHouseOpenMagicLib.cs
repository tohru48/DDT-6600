using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.MagicHouse.Handle
{
	[Attribute10(1)]
	public class MagicHouseOpenMagicLib : IMagicHouseCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			int num3 = 0;
			switch (num)
			{
			case 1:
			{
				int[] array3 = Player.MagicHouse.JuniorWeaponList(num2);
				for (int k = 0; k < array3.Length; k++)
				{
					ItemInfo[] array4 = Player.EquipBag.FindItemsByTempleteID(array3[k]);
					for (int l = 0; l < array4.Length; l++)
					{
						if (array4[l].IsValidItem() || array4[l].ValidDate == 0)
						{
							num3 = array3[0];
							break;
						}
					}
					if (num3 != 0)
					{
						break;
					}
				}
				break;
			}
			case 2:
			{
				int[] array5 = Player.MagicHouse.MidWeaponList(num2);
				for (int m = 0; m < array5.Length; m++)
				{
					ItemInfo[] array6 = Player.EquipBag.FindItemsByTempleteID(array5[m]);
					for (int n = 0; n < array6.Length; n++)
					{
						if (array6[n].IsValidItem() || array6[n].ValidDate == 0)
						{
							num3 = array5[0];
							break;
						}
					}
					if (num3 != 0)
					{
						break;
					}
				}
				break;
			}
			case 3:
			{
				int[] array = Player.MagicHouse.SeniorWeaponList(num2);
				for (int i = 0; i < array.Length; i++)
				{
					ItemInfo[] array2 = Player.EquipBag.FindItemsByTempleteID(array[i]);
					for (int j = 0; j < array2.Length; j++)
					{
						if (array2[j].IsValidItem() || array2[j].ValidDate == 0)
						{
							num3 = array[0];
							break;
						}
					}
					if (num3 != 0)
					{
						break;
					}
				}
				break;
			}
			}
			if (num3 != 0)
			{
				if ((num == 3 || num == 2) && !Player.MagicHouse.EquipActive(1))
				{
					Player.SendMessage(LanguageMgr.GetTranslation("MagicHouseUpdateMessage.Junior"));
				}
				else if (num == 3 && (!Player.MagicHouse.EquipActive(2) || !Player.MagicHouse.EquipActive(1)))
				{
					Player.SendMessage(LanguageMgr.GetTranslation("MagicHouseUpdateMessage.Mid"));
				}
				else
				{
					Player.MagicHouse.OpenMagicLib(num3, num, num2);
					Player.SendMessage(LanguageMgr.GetTranslation("MagicHouseUpdateMessage.Success"));
				}
			}
			else
			{
				string translation = LanguageMgr.GetTranslation("MagicHouseUpdateMessage.Fail");
				Player.SendMessage(translation + " code: " + num3 + "-" + num + "-" + num2);
			}
			Player.MagicHouse.UpdateMessage();
			return false;
		}
	}
}
