using System;
using System.Collections.Generic;
using System.Text;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameUtils;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(26, "打开物品")]
	public class LotteryOpenBoxHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			new ProduceBussiness();
			if (client.Lottery != -1)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("LotteryOpenBoxHandler.Msg1"));
				return 1;
			}
			int num = packet.ReadByte();
			int num2 = packet.ReadInt();
			int num3 = packet.ReadInt();
			List<ItemInfo> list = new List<ItemInfo>();
			PlayerInventory ınventory = client.Player.GetInventory((eBageType)num);
			string string_ = client.Player.PlayerCharacter.NickName;
			if (ınventory.FindFirstEmptySlot() == -1)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("LotteryOpenBoxHandler.Msg2"));
				return 1;
			}
			int templateId = 11456;
			ItemInfo ıtemByTemplateID = client.Player.GetItemByTemplateID(11456);
			ItemInfo ıtemByTemplateID2 = client.Player.GetItemByTemplateID(num3);
			if (ıtemByTemplateID2 == null || ıtemByTemplateID2.Count < 1)
			{
				Console.WriteLine("eBageType.{0} slot {1} templateID {2}", (eBageType)num, num2, num3);
				return 1;
			}
			if (ıtemByTemplateID2 == null)
			{
				list = client.Player.CaddyBag.GetItems();
				client.Out.SendTCP(method_0(list, string_, client.Player.ZoneId));
				return 0;
			}
			if (ıtemByTemplateID2.Count < 1)
			{
				list = client.Player.CaddyBag.GetItems();
				client.Out.SendTCP(method_0(list, string_, client.Player.ZoneId));
				return 0;
			}
			List<ItemInfo> list2 = new List<ItemInfo>();
			StringBuilder stringBuilder = new StringBuilder();
			SpecialItemBoxInfo specialValue = new SpecialItemBoxInfo();
			if (!ItemBoxMgr.CreateItemBox(ıtemByTemplateID2.TemplateID, list2, ref specialValue))
			{
				client.Player.SendMessage(LanguageMgr.GetTranslation("LotteryOpenBoxHandler.Msg3"));
				return 0;
			}
			client.Player.DirectAddValue(specialValue);
			if (list2.Count > 0)
			{
				ItemInfo ıtemInfo = list2[0];
				switch (num3)
				{
				default:
					string_ = ıtemInfo.Template.Name;
					break;
				case 112047:
				case 112100:
				case 112101:
					if (ıtemByTemplateID.Count < 4)
					{
						client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("LotteryOpenBoxHandler.Msg4", ıtemByTemplateID.Template.Name));
						client.Out.SendTCP(method_0(list, string_, client.Player.ZoneId));
						return 0;
					}
					client.Player.RemoveTemplate(templateId, 4);
					break;
				}
				ınventory.AddItem(ıtemInfo);
				stringBuilder.Append(ıtemInfo.Template.Name);
				client.Player.RemoveTemplate(num3, 1);
			}
			list = client.Player.CaddyBag.GetItems();
			client.Out.SendTCP(method_0(list, string_, client.Player.ZoneId));
			client.Lottery = -1;
			if (stringBuilder != null)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("LotteryOpenBoxHandler.Msg5", stringBuilder.ToString()));
			}
			return 1;
		}

		private GSPacketIn method_0(List<ItemInfo> list, string string_0, int int_0)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(245);
			gSPacketIn.WriteBoolean(val: true);
			gSPacketIn.WriteInt(list.Count);
			foreach (ItemInfo item in list)
			{
				gSPacketIn.WriteString(string_0);
				gSPacketIn.WriteInt(item.TemplateID);
				gSPacketIn.WriteInt(item.Count);
				gSPacketIn.WriteInt(int_0);
				gSPacketIn.WriteBoolean(val: false);
			}
			return gSPacketIn;
		}
	}
}
