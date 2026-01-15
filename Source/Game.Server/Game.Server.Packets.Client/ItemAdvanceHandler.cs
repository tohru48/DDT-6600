using System.Text;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(138, "物品强化")]
	public class ItemAdvanceHandler : IPacketHandler
	{
		public static ThreadSafeRandom random;

		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			StringBuilder stringBuilder = new StringBuilder();
			bool flag = false;
			packet.ReadBoolean();
			packet.ReadBoolean();
			GSPacketIn gSPacketIn = new GSPacketIn(138, client.Player.PlayerCharacter.ID);
			ItemInfo ıtemAt = client.Player.StoreBag.GetItemAt(0);
			ItemInfo ıtemInfo = client.Player.StoreBag.GetItemAt(1);
			int strengthenLevel = ıtemInfo.StrengthenLevel;
			if (ıtemAt == null || ıtemInfo == null || ıtemAt.Count <= 0)
			{
				client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("ItemAdvanceHandler.Msg1"));
				return 0;
			}
			if (strengthenLevel >= 15)
			{
				client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("ItemAdvanceHandler.Msg2"));
				return 0;
			}
			int count = 1;
			string text = "";
			if (ıtemInfo != null && ıtemInfo.Template.CanStrengthen && ıtemInfo.Template.CategoryID < 18 && ıtemInfo.Count == 1)
			{
				flag = flag || ıtemInfo.IsBinds;
				stringBuilder.Append(ıtemInfo.ItemID + ":" + ıtemInfo.TemplateID + ",");
				if (ıtemAt.TemplateID != 11150)
				{
					client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("ItemAdvanceHandler.Msg3"));
					return 0;
				}
				flag = flag || ıtemAt.IsBinds;
				string text2 = text;
				text = text2 + "," + ıtemAt.ItemID + ":" + ıtemAt.Template.Name;
				int num = ((ıtemAt.Template.Property2 < 10) ? 10 : ıtemAt.Template.Property2);
				stringBuilder.Append("true");
				bool flag2 = false;
				int num2 = random.Next(20000);
				double num3 = ıtemInfo.StrengthenExp / strengthenLevel;
				if (num3 > (double)num2)
				{
					ıtemInfo.IsBinds = flag;
					ıtemInfo.StrengthenLevel++;
					ıtemInfo.StrengthenExp = 0;
					gSPacketIn.WriteByte(0);
					gSPacketIn.WriteInt(num);
					flag2 = true;
					StrengthenGoodsInfo strengthenGoodsInfo = StrengthenMgr.FindStrengthenGoodsInfo(ıtemInfo.StrengthenLevel, ıtemInfo.TemplateID);
					if (strengthenGoodsInfo != null && ıtemInfo.Template.CategoryID == 7 && strengthenGoodsInfo.GainEquip > ıtemInfo.TemplateID)
					{
						ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(strengthenGoodsInfo.GainEquip);
						if (ıtemTemplateInfo != null)
						{
							ItemInfo ıtemInfo2 = ItemInfo.CloneFromTemplate(ıtemTemplateInfo, ıtemInfo);
							client.Player.StoreBag.RemoveItemAt(1);
							client.Player.StoreBag.AddItemTo(ıtemInfo2, 1);
							ıtemInfo = ıtemInfo2;
						}
					}
				}
				else
				{
					ıtemInfo.StrengthenExp += num;
					gSPacketIn.WriteByte(1);
					gSPacketIn.WriteInt(num);
				}
				client.Player.StoreBag.RemoveCountFromStack(ıtemAt, count);
				client.Player.StoreBag.UpdateItem(ıtemInfo);
				client.Out.SendTCP(gSPacketIn);
				if (flag2 && ıtemInfo.ItemID > 0)
				{
					string translation = LanguageMgr.GetTranslation("ItemStrengthenHandler.congratulation2", client.Player.PlayerCharacter.NickName, "@", ıtemInfo.StrengthenLevel - 12);
					GSPacketIn packet2 = WorldMgr.SendSysNotice(eMessageType.ChatNormal, translation, ıtemInfo.ItemID, ıtemInfo.TemplateID, "", client.Player.ZoneId);
					GameServer.Instance.LoginServer.SendPacket(packet2);
				}
				stringBuilder.Append(ıtemInfo.StrengthenLevel);
			}
			else
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemStrengthenHandler.Content1") + ıtemAt.Template.Name + LanguageMgr.GetTranslation("ItemStrengthenHandler.Content2"));
			}
			if (ıtemInfo.Place < 31)
			{
				client.Player.EquipBag.UpdatePlayerProperties();
			}
			return 0;
		}

		static ItemAdvanceHandler()
		{
			random = new ThreadSafeRandom();
		}
	}
}
