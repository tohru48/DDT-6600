using System;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(106, "场景用户离开")]
	public class WishBeadEquipHandler : IPacketHandler
	{
		public static ThreadSafeRandom random;

		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int place = packet.ReadInt();
			int bagType = packet.ReadInt();
			int templateId = packet.ReadInt();
			int place2 = packet.ReadInt();
			int bagType2 = packet.ReadInt();
			int num = packet.ReadInt();
			GSPacketIn gSPacketIn = new GSPacketIn(106, client.Player.PlayerCharacter.ID);
			ItemInfo ıtemAt = client.Player.GetItemAt((eBageType)bagType, place);
			ItemInfo ıtemAt2 = client.Player.GetItemAt((eBageType)bagType2, place2);
			if (ıtemAt2 != null && ıtemAt != null)
			{
				if (ıtemAt2.Count >= 1 && ıtemAt2.TemplateID == num)
				{
					if (!method_0(ıtemAt2.TemplateID, ıtemAt.Template.CategoryID))
					{
						gSPacketIn.WriteInt(5);
						client.Out.SendTCP(gSPacketIn);
						return 0;
					}
					double num2 = 5.0;
					GoldEquipTemplateInfo goldEquipTemplateInfo = GoldEquipMgr.FindGoldEquipByTemplate(templateId);
					ıtemAt.IsBinds = true;
					if (goldEquipTemplateInfo == null && ıtemAt.Template.CategoryID == 7)
					{
						gSPacketIn.WriteInt(5);
					}
					else if (ıtemAt.StrengthenLevel > GameProperties.WishBeadLimitLv && GameProperties.IsWishBeadLimit)
					{
						gSPacketIn.WriteInt(5);
					}
					else if (!ıtemAt.IsGold)
					{
						if (num2 > (double)random.Next(100))
						{
							ıtemAt.goldBeginTime = DateTime.Now;
							ıtemAt.goldValidDate = 30;
							if (ıtemAt.Template.CategoryID == 7)
							{
								ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(goldEquipTemplateInfo.NewTemplateId);
								if (ıtemTemplateInfo != null)
								{
									ıtemAt.GoldEquip = ıtemTemplateInfo;
								}
							}
							client.Player.UpdateItem(ıtemAt);
							gSPacketIn.WriteInt(0);
						}
						else
						{
							gSPacketIn.WriteInt(1);
						}
						client.Player.RemoveTemplate(num, 1);
					}
					else
					{
						gSPacketIn.WriteInt(6);
					}
					client.Out.SendTCP(gSPacketIn);
					return 0;
				}
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("WishBeadEquipHandler.Msg2"));
				gSPacketIn.WriteInt(5);
				client.Out.SendTCP(gSPacketIn);
				return 0;
			}
			client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("WishBeadEquipHandler.Msg1"));
			gSPacketIn.WriteInt(5);
			client.Out.SendTCP(gSPacketIn);
			return 0;
		}

		private bool method_0(int int_0, int int_1)
		{
			return (int_0 == 11560 && int_1 == 7) || (int_0 == 11561 && int_1 == 5) || (int_0 == 11562 && int_1 == 1);
		}

		static WishBeadEquipHandler()
		{
			random = new ThreadSafeRandom();
		}
	}
}
