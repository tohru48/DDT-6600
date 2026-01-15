using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.MagicStone.Handle
{
	[Attribute11(3)]
	public class MovePlace : IMagicStoneCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			if (Player.PlayerCharacter.HasBagPassword && Player.PlayerCharacter.IsLocked)
			{
				Player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return false;
			}
			PlayerMagicStoneInventory magicStoneBag = Player.MagicStoneBag;
			ItemInfo ıtemAt = magicStoneBag.GetItemAt(num);
			ItemInfo ıtemAt2 = magicStoneBag.GetItemAt(num2);
			if (ıtemAt == null)
			{
				return false;
			}
			if (num2 == -1)
			{
				num2 = magicStoneBag.FindFirstEmptySlot();
			}
			if ((!magicStoneBag.CanEquip(num) && num2 < magicStoneBag.BeginSlot - 1) || (ıtemAt2 != null && !magicStoneBag.CanEquip(num2) && num < magicStoneBag.BeginSlot - 1))
			{
				Player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("MovePlace.Msg1"));
				return false;
			}
			ıtemAt.IsBinds = true;
			bool flag;
			if (ıtemAt != null && num2 > magicStoneBag.BeginSlot)
			{
				num2 = magicStoneBag.FindFirstEmptySlot();
				flag = magicStoneBag.MoveItem(num, num2, 1);
			}
			else
			{
				flag = magicStoneBag.MoveItem(num, num2, 1);
			}
			if (!flag)
			{
				Player.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"));
				return false;
			}
			Player.EquipBag.UpdatePlayerProperties();
			return true;
		}
	}
}
