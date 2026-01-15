using System;
using System.Text;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(59, "物品强化")]
	public class ItemStrengthenHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			StringBuilder stringBuilder = new StringBuilder();
			bool flag = false;
			bool flag2 = packet.ReadBoolean();
			bool flag3 = packet.ReadBoolean();
			GSPacketIn gSPacketIn = new GSPacketIn(59, client.Player.PlayerCharacter.ID);
			ItemInfo ıtemAt = client.Player.StoreBag.GetItemAt(0);
			ItemInfo ıtemInfo = client.Player.StoreBag.GetItemAt(1);
			if (ıtemAt != null && ıtemInfo != null)
			{
				int num = 1;
				string Property = null;
				string text = "";
				using (ItemRecordBussiness ıtemRecordBussiness = new ItemRecordBussiness())
				{
					ıtemRecordBussiness.PropertyString(ıtemInfo, ref Property);
				}
				if (ıtemInfo != null && ıtemInfo.Template.CanStrengthen && ıtemInfo.Template.CategoryID < 18 && ıtemInfo.Count == 1)
				{
					flag = flag || ıtemInfo.IsBinds;
					stringBuilder.Append(ıtemInfo.ItemID + ":" + ıtemInfo.TemplateID + ",");
					double num2 = 0.0;
					double num3 = 0.0;
					double num4 = 0.0;
					int strengthenExp = ıtemInfo.StrengthenExp;
					int strengthenLevel = ıtemInfo.StrengthenLevel;
					if (strengthenLevel >= 12)
					{
						client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("ItemStrengthenHandler.Max"));
						return 0;
					}
					bool flag4 = false;
					ConsortiaInfo consortiaInfo = ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
					if (flag2)
					{
						ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
						ConsortiaEquipControlInfo consortiaEuqipRiches = consortiaBussiness.GetConsortiaEuqipRiches(client.Player.PlayerCharacter.ConsortiaID, 0, 2);
						if (consortiaInfo == null)
						{
							client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemStrengthenHandler.Fail"));
						}
						else
						{
							if (client.Player.PlayerCharacter.Riches < consortiaEuqipRiches.Riches)
							{
								client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("ItemStrengthenHandler.FailbyPermission"));
								return 1;
							}
							flag4 = true;
						}
					}
					if (ıtemAt != null && ıtemAt.Template.CategoryID == 11 && (ıtemAt.Template.Property1 == 2 || ıtemAt.Template.Property1 == 35))
					{
						flag = flag || ıtemAt.IsBinds;
						string text2 = text;
						text = text2 + "," + ıtemAt.ItemID + ":" + ıtemAt.Template.Name;
						int num5 = ((ıtemAt.Template.Property2 < 10) ? 10 : ıtemAt.Template.Property2);
						if (flag4)
						{
							int smithLevel = consortiaInfo.SmithLevel;
							double num6 = GameProperties.ConsortiaStrengExp(smithLevel - 1);
							num3 = num6 * (double)num5 / 100.0;
						}
						if (client.Player.PlayerCharacter.VIPExpireDay.Date >= DateTime.Now.Date)
						{
							int vIPLevel = client.Player.PlayerCharacter.VIPLevel;
							double num7 = GameProperties.VIPStrengthenExp(vIPLevel - 1);
							num4 = num7 * (double)num5 / 100.0;
						}
						num5 += (int)num3 + (int)num4;
						if (flag3)
						{
							int needExp = StrengthenMgr.getNeedExp(strengthenExp, strengthenLevel);
							num = vhteNogDaO(needExp, num5);
							if (num > ıtemAt.Count)
							{
								num = ıtemAt.Count;
							}
							num2 += (double)(num5 * num);
						}
						else
						{
							num2 += (double)num5;
						}
					}
					stringBuilder.Append("true");
					bool flag5 = false;
					int num8 = (int)num2 + strengthenExp;
					if (StrengthenMgr.canUpLv(num8, strengthenLevel))
					{
						ıtemInfo.IsBinds = flag;
						ıtemInfo.StrengthenLevel++;
						ıtemInfo.StrengthenExp = num8 - StrengthenMgr.FindStrengthenExpInfo(strengthenLevel + 1).Exp;
						gSPacketIn.WriteByte(1);
						flag5 = true;
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
						ıtemInfo.StrengthenExp = num8;
					}
					client.Player.StoreBag.RemoveCountFromStack(ıtemAt, num);
					client.Player.StoreBag.UpdateItem(ıtemInfo);
					client.Player.OnItemStrengthen(ıtemInfo.Template.CategoryID, ıtemInfo.StrengthenLevel);
					gSPacketIn.WriteBoolean(val: false);
					client.Out.SendTCP(gSPacketIn);
					if (flag5 && ıtemInfo.StrengthenLevel > 9 && ıtemInfo.ItemID > 0)
					{
						string translation = LanguageMgr.GetTranslation("ItemStrengthenHandler.congratulation", client.Player.PlayerCharacter.NickName, "@", ıtemInfo.StrengthenLevel);
						WorldMgr.SendSysNotice(eMessageType.ChatNormal, translation, ıtemInfo.ItemID, ıtemInfo.TemplateID, "", client.Player.ZoneId);
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
			client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("ItemAdvanceHandler.Msg1"));
			return 0;
		}

		private int vhteNogDaO(int int_0, int int_1)
		{
			int num = 1;
			for (int i = int_1; i < int_0; i += int_1)
			{
				num++;
			}
			return num;
		}
	}
}
