using System;
using System.Text;
using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(58, "物品合成")]
	public class ItemComposeHandler : IPacketHandler
	{
		public static ThreadSafeRandom random;

		private static readonly double[] double_0;

		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(58, client.Player.PlayerCharacter.ID);
			StringBuilder stringBuilder = new StringBuilder();
			int pRICE_COMPOSE_GOLD = GameProperties.PRICE_COMPOSE_GOLD;
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return 0;
			}
			if (client.Player.PlayerCharacter.Gold < pRICE_COMPOSE_GOLD)
			{
				client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("ItemComposeHandler.NoMoney"));
				return 0;
			}
			int num = -1;
			int num2 = -1;
			bool flag = false;
			bool flag2 = packet.ReadBoolean();
			ItemInfo ıtemAt = client.Player.StoreBag.GetItemAt(1);
			ItemInfo ıtemAt2 = client.Player.StoreBag.GetItemAt(2);
			ItemInfo ıtemInfo = null;
			ItemInfo ıtemInfo2 = null;
			if (ıtemAt2 != null && ıtemAt != null && ıtemAt2.Count > 0)
			{
				string Property = null;
				string text = null;
				using (ItemRecordBussiness ıtemRecordBussiness = new ItemRecordBussiness())
				{
					ıtemRecordBussiness.PropertyString(ıtemAt, ref Property);
				}
				if (ıtemAt != null && ıtemAt2 != null && ıtemAt.Template.CanCompose && (ıtemAt.Template.CategoryID < 10 || (ıtemAt2.Template.CategoryID == 11 && ıtemAt2.Template.Property1 == 1)))
				{
					flag = (flag = flag || ıtemAt.IsBinds) || ıtemAt2.IsBinds;
					stringBuilder.Append(ıtemAt.ItemID + ":" + ıtemAt.TemplateID + "," + ıtemAt2.ItemID + ":" + ıtemAt2.TemplateID + ",");
					bool flag3 = false;
					byte b = 1;
					double num3 = double_0[ıtemAt2.Template.Quality - 1] * 100.0;
					if (client.Player.StoreBag.GetItemAt(0) != null)
					{
						ıtemInfo = client.Player.StoreBag.GetItemAt(0);
						if (ıtemInfo != null && ıtemInfo.Template.CategoryID == 11 && ıtemInfo.Template.Property1 == 3)
						{
							flag = flag || ıtemInfo.IsBinds;
							object obj = text;
							text = string.Concat(obj, "|", ıtemInfo.ItemID, ":", ıtemInfo.Template.Name, "|", ıtemAt2.ItemID, ":", ıtemAt2.Template.Name);
							stringBuilder.Append(ıtemInfo.ItemID + ":" + ıtemInfo.TemplateID + ",");
							num3 += num3 * (double)ıtemInfo.Template.Property2 / 100.0;
						}
					}
					else
					{
						num3 += num3 * 1.0 / 100.0;
					}
					if (num2 != -1)
					{
						ıtemInfo2 = client.Player.PropBag.GetItemAt(num2);
						if (ıtemInfo2 != null && ıtemInfo2.Template.CategoryID == 11 && ıtemInfo2.Template.Property1 == 7)
						{
							flag = flag || ıtemInfo2.IsBinds;
							stringBuilder.Append(ıtemInfo2.ItemID + ":" + ıtemInfo2.TemplateID + ",");
							object obj2 = text;
							text = string.Concat(obj2, ",", ıtemInfo2.ItemID, ":", ıtemInfo2.Template.Name);
						}
						else
						{
							ıtemInfo2 = null;
						}
					}
					if (flag2)
					{
						ConsortiaInfo consortiaInfo = ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
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
							num3 *= 1.0 + 0.1 * (double)consortiaInfo.SmithLevel;
						}
					}
					num3 = Math.Floor(num3 * 10.0) / 10.0;
					int num4 = random.Next(100);
					switch (ıtemAt2.Template.Property3)
					{
					case 1:
						if (ıtemAt2.Template.Property4 > ıtemAt.AttackCompose)
						{
							flag3 = true;
							if (num3 > (double)num4)
							{
								b = 0;
								ıtemAt.AttackCompose = ıtemAt2.Template.Property4;
							}
						}
						break;
					case 2:
						if (ıtemAt2.Template.Property4 > ıtemAt.DefendCompose)
						{
							flag3 = true;
							if (num3 > (double)num4)
							{
								b = 0;
								ıtemAt.DefendCompose = ıtemAt2.Template.Property4;
							}
						}
						break;
					case 3:
						if (ıtemAt2.Template.Property4 > ıtemAt.AgilityCompose)
						{
							flag3 = true;
							if (num3 > (double)num4)
							{
								b = 0;
								ıtemAt.AgilityCompose = ıtemAt2.Template.Property4;
							}
						}
						break;
					case 4:
						if (ıtemAt2.Template.Property4 > ıtemAt.LuckCompose)
						{
							flag3 = true;
							if (num3 > (double)num4)
							{
								b = 0;
								ıtemAt.LuckCompose = ıtemAt2.Template.Property4;
							}
						}
						break;
					}
					if (flag3)
					{
						ıtemAt.IsBinds = flag;
						if (b != 0)
						{
							stringBuilder.Append("false!");
						}
						else
						{
							stringBuilder.Append("true!");
							client.Player.OnItemCompose(ıtemAt2.TemplateID);
						}
						client.Player.StoreBag.RemoveTemplate(ıtemAt2.TemplateID, 1);
						if (ıtemInfo != null)
						{
							client.Player.StoreBag.RemoveTemplate(ıtemInfo.TemplateID, 1);
						}
						if (ıtemInfo2 != null)
						{
							client.Player.RemoveItem(ıtemInfo2);
						}
						client.Player.RemoveGold(pRICE_COMPOSE_GOLD);
						client.Player.StoreBag.UpdateItem(ıtemAt);
						gSPacketIn.WriteByte(b);
						client.Out.SendTCP(gSPacketIn);
						if (num < 31)
						{
							client.Player.EquipBag.UpdatePlayerProperties();
						}
					}
					else
					{
						client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemComposeHandler.NoLevel"));
					}
				}
				else
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemComposeHandler.Fail"));
				}
				return 0;
			}
			client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("ItemComposeHandler.Msg"));
			return 0;
		}

		static ItemComposeHandler()
		{
			random = new ThreadSafeRandom();
			double_0 = new double[5] { 0.8, 0.5, 0.3, 0.1, 0.05 };
		}
	}
}
