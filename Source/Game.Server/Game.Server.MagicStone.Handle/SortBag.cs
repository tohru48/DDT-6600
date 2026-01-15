using System;
using System.Collections.Generic;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.MagicStone.Handle
{
	[Attribute11(9)]
	public class SortBag : IMagicStoneCommandHadler
	{
		private static readonly ILog ilog_0;

		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			PlayerMagicStoneInventory magicStoneBag = Player.MagicStoneBag;
			List<ItemInfo> ıtems = magicStoneBag.GetItems(magicStoneBag.BeginSlot, magicStoneBag.Capalility);
			if (num != ıtems.Count)
			{
				return false;
			}
			magicStoneBag.BeginChanges();
			try
			{
				for (int i = 0; i < num; i++)
				{
					int slot = packet.ReadInt();
					int toSlot = packet.ReadInt();
					ItemInfo ıtemAt = magicStoneBag.GetItemAt(slot);
					if (ıtemAt != null)
					{
						magicStoneBag.MoveItem(ıtemAt.Place, toSlot, ıtemAt.Count);
					}
				}
			}
			catch (Exception ex)
			{
				ilog_0.ErrorFormat("Arrage magicstone bag errror,user id:{0}   msg:{1}", Player.PlayerId, ex.Message);
			}
			finally
			{
				ıtems = magicStoneBag.GetItems(magicStoneBag.BeginSlot, magicStoneBag.Capalility);
				if (magicStoneBag.FindFirstEmptySlot() != -1)
				{
					for (int j = 1; magicStoneBag.FindFirstEmptySlot() < ıtems[ıtems.Count - j].Place; j++)
					{
						magicStoneBag.MoveItem(ıtems[ıtems.Count - j].Place, magicStoneBag.FindFirstEmptySlot(), ıtems[ıtems.Count - j].Count);
					}
				}
				magicStoneBag.CommitChanges();
			}
			return true;
		}

		static SortBag()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
