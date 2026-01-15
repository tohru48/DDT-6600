using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.MagicStone.Handle
{
	[Attribute11(6)]
	public class Clock : IMagicStoneCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int slot = packet.ReadInt();
			if (Player.PlayerCharacter.HasBagPassword && Player.PlayerCharacter.IsLocked)
			{
				Player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return false;
			}
			PlayerMagicStoneInventory magicStoneBag = Player.MagicStoneBag;
			ItemInfo ıtemAt = magicStoneBag.GetItemAt(slot);
			if (ıtemAt.goodsLock)
			{
				ıtemAt.goodsLock = false;
			}
			else
			{
				ıtemAt.goodsLock = true;
			}
			magicStoneBag.UpdateItem(ıtemAt);
			return true;
		}
	}
}
