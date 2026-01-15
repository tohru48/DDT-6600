using System.Collections.Generic;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.BombKing.Handle
{
	[Attribute2(1)]
	public class BombKingUpdateItemEquip : IBombKingCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int zoneId = packet.ReadInt();
			int num2 = packet.ReadInt();
			AreaConfigInfo areaConfigInfo = WorldMgr.FindAreaConfig(zoneId);
			if (areaConfigInfo != null)
			{
				using AreaPlayerBussiness areaPlayerBussiness = new AreaPlayerBussiness(areaConfigInfo);
				switch (num2)
				{
				case 0:
				case 1:
				{
					PlayerInfo userSingleByUserID = areaPlayerBussiness.GetUserSingleByUserID(num);
					if (userSingleByUserID != null)
					{
						userSingleByUserID.ZoneID = Player.ZoneId;
						userSingleByUserID.ZoneName = Player.ZoneName;
						if (num2 == 0)
						{
							List<UsersCardInfo> userCardEuqip = areaPlayerBussiness.GetUserCardEuqip(num);
							Player.Out.SendPlayerCardSlot(userSingleByUserID, userCardEuqip);
							Player.Out.SendPlayerCardEquip(userSingleByUserID, userCardEuqip);
							break;
						}
						List<ItemInfo> userEuqip = areaPlayerBussiness.GetUserEuqip(num);
						List<ItemInfo> userBeadEuqip = areaPlayerBussiness.GetUserBeadEuqip(num);
						userSingleByUserID.Texp = areaPlayerBussiness.GetUserTexpInfoSingle(num);
						List<UserGemStone> singleGemstones = areaPlayerBussiness.GetSingleGemstones(num);
						List<ItemInfo> userMagicstoneEuqip = areaPlayerBussiness.GetUserMagicstoneEuqip(num);
						Player.Out.SendUserEquip(userSingleByUserID, userEuqip, singleGemstones, userBeadEuqip, userMagicstoneEuqip);
					}
					break;
				}
				case 2:
				{
					UsersPetinfo[] userPetSingles = areaPlayerBussiness.GetUserPetSingles(num);
					if (userPetSingles.Length > 0)
					{
						ItemInfo[] userBagByType = areaPlayerBussiness.GetUserBagByType(num, 5012);
						for (int i = 0; i < userPetSingles.Length; i++)
						{
							userPetSingles[i].PetEquip = method_0(userPetSingles[i].ID, userBagByType);
						}
						Player.Out.SendPetInfo(num, zoneId, userPetSingles);
					}
					break;
				}
				}
			}
			return false;
		}

		private List<ItemInfo> method_0(int int_0, ItemInfo[] itemInfo_0)
		{
			List<ItemInfo> list = new List<ItemInfo>();
			foreach (ItemInfo ıtemInfo in itemInfo_0)
			{
				if (int_0 == ıtemInfo.Bless)
				{
					list.Add(ıtemInfo);
				}
			}
			return list;
		}
	}
}
