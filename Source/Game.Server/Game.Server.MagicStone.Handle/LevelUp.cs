using System.Collections.Generic;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.MagicStone.Handle
{
	[Attribute11(2)]
	public class LevelUp : IMagicStoneCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.PlayerCharacter.HasBagPassword && Player.PlayerCharacter.IsLocked)
			{
				Player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return false;
			}
			PlayerMagicStoneInventory magicStoneBag = Player.MagicStoneBag;
			ItemInfo ıtemAt = magicStoneBag.GetItemAt(31);
			if (ıtemAt == null)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("MagicStone.LevelUp"));
				return false;
			}
			List<int> list = new List<int>();
			int num = 0;
			int num2 = packet.ReadInt();
			MagicStoneInfo magicStoneInfo = MagicStoneMgr.FindMagicStoneByLevel(ıtemAt.TemplateID, 10);
			if (magicStoneInfo == null)
			{
				Player.SendMessage("Database Error.");
				return false;
			}
			for (int i = 0; i < num2; i++)
			{
				int num3 = packet.ReadInt();
				ItemInfo ıtemAt2 = magicStoneBag.GetItemAt(num3);
				if (ıtemAt2 != null && !ıtemAt2.goodsLock)
				{
					list.Add(num3);
					num += ıtemAt2.StrengthenExp;
				}
				if (ıtemAt.StrengthenExp + num >= magicStoneInfo.Exp)
				{
					break;
				}
			}
			ıtemAt.StrengthenExp += num;
			List<MagicStoneInfo> list2 = MagicStoneMgr.FindMagicStone(ıtemAt.TemplateID);
			foreach (MagicStoneInfo item in list2)
			{
				if (ıtemAt.StrengthenExp >= item.Exp)
				{
					ıtemAt.StrengthenLevel = item.Level;
					if (ıtemAt.AttackCompose > 0 && item.Attack > ıtemAt.AttackCompose)
					{
						ıtemAt.AttackCompose = item.Attack;
					}
					if (ıtemAt.DefendCompose > 0 && item.Defence > ıtemAt.DefendCompose)
					{
						ıtemAt.DefendCompose = item.Defence;
					}
					if (ıtemAt.AgilityCompose > 0 && item.Agility > ıtemAt.AgilityCompose)
					{
						ıtemAt.AgilityCompose = item.Agility;
					}
					if (ıtemAt.LuckCompose > 0 && item.Luck > ıtemAt.LuckCompose)
					{
						ıtemAt.LuckCompose = item.Luck;
					}
					if (ıtemAt.MagicAttack > 0 && item.MagicAttack > ıtemAt.MagicAttack)
					{
						ıtemAt.MagicAttack = item.MagicAttack;
					}
					if (ıtemAt.MagicDefence > 0 && item.MagicDefence > ıtemAt.MagicDefence)
					{
						ıtemAt.MagicDefence = item.MagicDefence;
					}
				}
			}
			magicStoneBag.UpdateItem(ıtemAt);
			magicStoneBag.RemoveAllItem(list);
			return true;
		}
	}
}
