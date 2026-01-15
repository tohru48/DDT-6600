using System;
using System.Collections.Generic;
using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Farm.Handle
{
	[Attribute5(1)]
	public class EnterFarm : IFarmCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.PlayerCharacter.Grade < 25)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("EnterFarmHandler.Msg1"));
				return false;
			}
			int num = packet.ReadInt();
			if (num == Player.PlayerCharacter.ID)
			{
				Player.Farm.EnterFarm(isEnter: true);
				if (Player.PlayerCharacter.IsFistGetPet)
				{
					Player.PetBag.ClearAdoptPets();
					List<UsersPetinfo> list = PetMgr.CreateFirstAdoptList(num, Player.Level);
					foreach (UsersPetinfo item in list)
					{
						Player.PetBag.AddAdoptPetTo(item, item.Place);
					}
					Player.RemoveFistGetPet();
				}
				else if (Player.PlayerCharacter.LastRefreshPet.Date < DateTime.Now.Date)
				{
					Player.PetBag.ClearAdoptPets();
					List<UsersPetinfo> list2 = PetMgr.CreateAdoptList(num, Player.Level);
					foreach (UsersPetinfo item2 in list2)
					{
						Player.PetBag.AddAdoptPetTo(item2, item2.Place);
					}
					Player.RemoveLastRefreshPet();
				}
			}
			else
			{
				Player.Farm.EnterFriendFarm(num);
			}
			return true;
		}
	}
}
