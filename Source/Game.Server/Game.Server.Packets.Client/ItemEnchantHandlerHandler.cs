using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(280, "场景用户离开")]
	public class ItemEnchantHandlerHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			bool flag = packet.ReadBoolean();
			ItemInfo ıtemAt = client.Player.StoreBag.GetItemAt(0);
			ItemInfo ıtemAt2 = client.Player.StoreBag.GetItemAt(1);
			if (ıtemAt != null && ıtemAt.TemplateID == 11166)
			{
				if (ıtemAt2 != null && ıtemAt2.IsEnchant())
				{
					int magicLevel = ıtemAt2.MagicLevel;
					int magicExp = ıtemAt2.MagicExp;
					bool flag2 = false;
					int num = 1;
					MagicItemTemplateInfo magicItemTemplateInfo = MagicItemTemplateMgr.FindMagicItemTemplate(magicLevel + 1);
					if (magicItemTemplateInfo != null)
					{
						int property = ıtemAt.Template.Property2;
						if (flag)
						{
							int num2 = ((magicItemTemplateInfo.Exp - magicExp < ıtemAt.Template.Property2) ? ıtemAt.Template.Property2 : (magicItemTemplateInfo.Exp - magicExp));
							num = ((num2 / ıtemAt.Template.Property2 <= 0) ? 1 : (num2 / ıtemAt.Template.Property2));
						}
						if (num > ıtemAt.Count)
						{
							num = ıtemAt.Count;
						}
						ıtemAt2.MagicExp += property * num;
						if (ıtemAt2.MagicExp >= magicItemTemplateInfo.Exp)
						{
							ıtemAt2.MagicLevel++;
							flag2 = true;
						}
						if (flag2)
						{
							GSPacketIn gSPacketIn = packet.Clone();
							gSPacketIn.ClearContext();
							gSPacketIn.WriteInt(ıtemAt2.MagicExp);
							gSPacketIn.WriteBoolean(flag2);
							client.Player.SendTCP(gSPacketIn);
							client.Player.EquipBag.UpdatePlayerProperties();
						}
						else
						{
							client.Player.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemEnchant.AddExpSuccess", property * num));
						}
						client.Player.StoreBag.UpdateItem(ıtemAt2);
						client.Player.StoreBag.RemoveCountFromStack(ıtemAt, num);
					}
					else
					{
						client.Player.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemEnchant.DataError"));
					}
				}
				else
				{
					client.Player.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemEnchant.NoHaveItem"));
				}
			}
			else
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemEnchant.NoHaveSoulstone"));
			}
			return 0;
		}
	}
}
