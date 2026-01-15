using System.Collections.Generic;
using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(176, "添加任务")]
	public class QuestAddHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			for (int i = 0; i < num; i++)
			{
				int num2 = packet.ReadInt();
				QuestInfo singleQuest = QuestMgr.GetSingleQuest(num2);
				if (singleQuest != null && singleQuest.QuestID != 10)
				{
					client.Player.QuestInventory.AddQuest(singleQuest, out var _);
				}
				int num3 = num2;
				if (num3 <= 125)
				{
					switch (num3)
					{
					default:
						continue;
					case 4:
					case 5:
					case 64:
					case 65:
					case 66:
					case 125:
						break;
					}
				}
				else
				{
					switch (num3)
					{
					default:
						if (num3 == 355)
						{
							break;
						}
						continue;
					case 210:
					case 211:
					case 212:
					case 213:
					case 343:
						break;
					}
				}
				List<ItemInfo> strengthenItems = client.Player.GetStrengthenItems();
				foreach (ItemInfo item in strengthenItems)
				{
					if (item != null)
					{
						client.Player.OnItemStrengthen(item.Template.CategoryID, item.StrengthenLevel);
					}
				}
			}
			return 0;
		}
	}
}
