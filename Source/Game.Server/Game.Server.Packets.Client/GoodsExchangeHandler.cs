using System.Collections.Generic;
using System.Text;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(31, "场景用户离开")]
	public class GoodsExchangeHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int id = packet.ReadInt();
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			int i = 0;
			ActiveMgr.GetSingleActive(id);
			List<ItemInfo> list = new List<ItemInfo>();
			StringBuilder stringBuilder = new StringBuilder();
			for (; i < num2; i++)
			{
				int num3 = packet.ReadInt();
				int place = packet.ReadInt();
				int bagType = packet.ReadInt();
				ItemInfo ıtemAt = client.Player.GetItemAt((eBageType)bagType, place);
				if (ıtemAt != null && ıtemAt.TemplateID == num3)
				{
					list.Add(ıtemAt);
					continue;
				}
				ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(num3);
				stringBuilder.Append(ıtemTemplateInfo.Name + ", ");
			}
			int index = packet.ReadInt();
			if (list.Count == num2)
			{
				StringBuilder stringBuilder2 = new StringBuilder();
				bool flag = false;
				foreach (ItemInfo item in list)
				{
					ActiveConvertItemInfo activeConvertItem = ActiveMgr.GetActiveConvertItem(id, item.TemplateID, index);
					int num4 = activeConvertItem.ItemCount * num;
					if (num4 > 0)
					{
						if (activeConvertItem != null && item.Count >= num4 && item.TemplateID == activeConvertItem.TemplateID)
						{
							flag = client.Player.RemoveTemplate(item.TemplateID, num4);
						}
						if (!flag)
						{
							stringBuilder.Append(item.Template.Name + ", ");
						}
					}
				}
				if (flag)
				{
					List<ActiveConvertItemInfo> activeConvertItemAward = ActiveMgr.GetActiveConvertItemAward(id, index);
					foreach (ActiveConvertItemInfo item2 in activeConvertItemAward)
					{
						ItemTemplateInfo ıtemTemplateInfo2 = ItemMgr.FindItemTemplate(item2.TemplateID);
						if (ıtemTemplateInfo2 != null)
						{
							ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo2, 1, 102);
							ıtemInfo.IsBinds = item2.IsBind;
							ıtemInfo.Count = item2.ItemCount;
							if (item2.LimitValue > 0)
							{
								ıtemInfo.StrengthenLevel = item2.LimitValue;
							}
							client.Player.AddTemplate(ıtemInfo, ıtemInfo.Template.BagType, item2.ItemCount * num, eGameView.RouletteTypeGet);
							stringBuilder2.Append(ıtemTemplateInfo2.Name + " x" + item2.ItemCount + ". ");
						}
					}
					if (stringBuilder2.Length > 0)
					{
						client.Out.SendMessage(eMessageType.Normal, stringBuilder2.ToString());
					}
					else
					{
						stringBuilder.Append(LanguageMgr.GetTranslation("GoodsExchangeHandler.Msg2"));
					}
				}
			}
			else
			{
				string text = stringBuilder.ToString();
				text = text.Substring(0, text.LastIndexOf(","));
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("GoodsExchangeHandler.Msg1", text));
			}
			return 0;
		}
	}
}
