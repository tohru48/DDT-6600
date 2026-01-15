using System;
using System.Text;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(62, "续费")]
	public class UserItemContineueHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return 0;
			}
			new StringBuilder();
			int num = packet.ReadInt();
			string translateId = "UserItemContineueHandler.Success";
			for (int i = 0; i < num; i++)
			{
				eBageType eBageType = (eBageType)packet.ReadByte();
				int num2 = packet.ReadInt();
				int ıD = packet.ReadInt();
				int num3 = packet.ReadByte();
				bool flag = packet.ReadBoolean();
				packet.ReadInt();
				ShopItemInfo shopItemInfoById = ShopMgr.GetShopItemInfoById(ıD);
				ItemInfo ıtemAt = client.Player.GetItemAt(eBageType, num2);
				if (eBageType != eBageType.EquipBag || ıtemAt == null || shopItemInfoById == null || shopItemInfoById.TemplateID != ıtemAt.TemplateID)
				{
					continue;
				}
				if (ıtemAt.ValidDate != 0)
				{
					SpecialItemBoxInfo specialValue = new SpecialItemBoxInfo();
					int validDate = ıtemAt.ValidDate;
					DateTime beginDate = ıtemAt.BeginDate;
					int count = ıtemAt.Count;
					bool flag2 = ıtemAt.IsValidItem();
					if (!ShopMgr.SetItemType(shopItemInfoById, num3, ref specialValue))
					{
						client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("UserItemContineueHandler.CanNotContineu"));
						return 0;
					}
					if (specialValue.Gold <= client.Player.PlayerCharacter.Gold && specialValue.Money <= client.Player.PlayerCharacter.Money && specialValue.Offer <= client.Player.PlayerCharacter.Offer && specialValue.DDTMoney <= client.Player.PlayerCharacter.DDTMoney)
					{
						if (!flag2)
						{
							if (1 == num3)
							{
								ıtemAt.ValidDate = shopItemInfoById.AUnit;
							}
							if (2 == num3)
							{
								ıtemAt.ValidDate = shopItemInfoById.BUnit;
							}
							if (3 == num3)
							{
								ıtemAt.ValidDate = shopItemInfoById.CUnit;
							}
							ıtemAt.BeginDate = DateTime.Now;
							ıtemAt.IsUsed = true;
							client.Player.DirectRemoveValue(specialValue);
						}
						else
						{
							translateId = "UserItemContineueHandler.StillValidate";
						}
					}
					else
					{
						ıtemAt.ValidDate = validDate;
						ıtemAt.Count = count;
						translateId = "UserItemContineueHandler.NoMoney";
					}
				}
				if (flag)
				{
					int num4 = client.Player.EquipBag.FindItemEpuipSlot(ıtemAt.Template);
					if (client.Player.GetItemAt(eBageType, num4) == null && num2 > client.Player.EquipBag.BeginSlot)
					{
						client.Player.EquipBag.MoveItem(num2, num4, 1);
					}
				}
				else
				{
					client.Player.EquipBag.UpdateItem(ıtemAt);
				}
			}
			client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation(translateId));
			return 0;
		}
	}
}
