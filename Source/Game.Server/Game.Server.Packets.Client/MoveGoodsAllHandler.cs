using System.Collections.Generic;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.GameUtils;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(124, "物品比较")]
	public class MoveGoodsAllHandler : IPacketHandler
	{
		private static readonly ILog ilog_0;

		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			bool flag = packet.ReadBoolean();
			int num = packet.ReadInt();
			int bageType = packet.ReadInt();
			PlayerInventory ınventory = client.Player.GetInventory((eBageType)bageType);
			List<ItemInfo> ıtems = ınventory.GetItems();
			if (num == ıtems.Count)
			{
				try
				{
					if (flag)
					{
						List<int> list = new List<int>();
						for (int i = 0; i < ıtems.Count; i++)
						{
							if (list.Contains(i))
							{
								continue;
							}
							for (int num2 = ıtems.Count - 1; num2 > i; num2--)
							{
								if (!list.Contains(num2) && ıtems[i].TemplateID == ıtems[num2].TemplateID && ıtems[i].CanStackedTo(ıtems[num2]))
								{
									ınventory.MoveItem(ıtems[num2].Place, ıtems[i].Place, ıtems[num2].Count);
									list.Add(num2);
								}
							}
						}
					}
					ıtems = ınventory.GetItems();
					if (ınventory.FindFirstEmptySlot() != -1)
					{
						for (int j = 1; j <= ıtems.Count && ınventory.FindFirstEmptySlot() < ıtems[ıtems.Count - j].Place; j++)
						{
							ınventory.MoveItem(ıtems[ıtems.Count - j].Place, ınventory.FindFirstEmptySlot(), ıtems[ıtems.Count - j].Count);
						}
					}
				}
				finally
				{
					if (ınventory.BagType == 21)
					{
						ınventory.UpdateChangedPlaces();
					}
				}
			}
			return 0;
		}

		static MoveGoodsAllHandler()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
