using System.Text;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameUtils;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(61, "物品转移")]
	public class ItemTransferHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(61, client.Player.PlayerCharacter.ID);
			new StringBuilder();
			int mustTransferGold = GameProperties.MustTransferGold;
			bool tranHole = packet.ReadBoolean();
			bool tranHoleFivSix = packet.ReadBoolean();
			eBageType bageType = (eBageType)packet.ReadInt();
			int num = packet.ReadInt();
			eBageType bageType2 = (eBageType)packet.ReadInt();
			int num2 = packet.ReadInt();
			PlayerInventory ınventory = client.Player.GetInventory(bageType);
			PlayerInventory ınventory2 = client.Player.GetInventory(bageType2);
			ItemInfo itemZero = ınventory.GetItemAt(num);
			ItemInfo itemOne = ınventory2.GetItemAt(num2);
			if (itemZero != null && itemOne != null && itemZero.Template.CategoryID == itemOne.Template.CategoryID && itemOne.Count == 1 && itemZero.Count == 1)
			{
				if (client.Player.PlayerCharacter.Gold < mustTransferGold)
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("itemtransferhandler.nogold"));
					return 1;
				}
				if (itemZero.MagicExp > 0 || itemOne.MagicExp > 0)
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("itemtransferhandler.IsMagic"));
					return 1;
				}
				client.Player.RemoveGold(mustTransferGold);
				StrengthenMgr.InheritTransferProperty(ref itemZero, ref itemOne, tranHole, tranHoleFivSix);
				int num3 = method_0(itemZero);
				int num4 = method_0(itemOne);
				ItemTemplateInfo ıtemTemplateInfo = null;
				ItemTemplateInfo ıtemTemplateInfo2 = null;
				if (num3 > 0)
				{
					ıtemTemplateInfo = ItemMgr.FindItemTemplate(method_1(itemZero));
				}
				if (num4 > 0)
				{
					ıtemTemplateInfo2 = ItemMgr.FindItemTemplate(method_1(itemOne));
				}
				if (TransferCondition(itemOne, itemZero) && ıtemTemplateInfo != null && ıtemTemplateInfo2 != null)
				{
					ItemInfo ıtemInfo = ItemInfo.CloneFromTemplate(ıtemTemplateInfo, itemZero);
					if (ıtemInfo.IsGold)
					{
						GoldEquipTemplateInfo goldEquipTemplateInfo = GoldEquipMgr.FindGoldEquipByTemplate(ıtemTemplateInfo.TemplateID);
						if (goldEquipTemplateInfo != null)
						{
							ItemTemplateInfo ıtemTemplateInfo3 = ItemMgr.FindItemTemplate(goldEquipTemplateInfo.NewTemplateId);
							if (ıtemTemplateInfo3 != null)
							{
								ıtemInfo.GoldEquip = ıtemTemplateInfo3;
							}
						}
					}
					ınventory.RemoveItemAt(num);
					ınventory.AddItemTo(ıtemInfo, 0);
					ItemInfo ıtemInfo2 = ItemInfo.CloneFromTemplate(ıtemTemplateInfo2, itemOne);
					if (ıtemInfo2.IsGold)
					{
						GoldEquipTemplateInfo goldEquipTemplateInfo2 = GoldEquipMgr.FindGoldEquipByTemplate(ıtemTemplateInfo2.TemplateID);
						if (goldEquipTemplateInfo2 != null)
						{
							ItemTemplateInfo ıtemTemplateInfo4 = ItemMgr.FindItemTemplate(goldEquipTemplateInfo2.NewTemplateId);
							if (ıtemTemplateInfo4 != null)
							{
								ıtemInfo2.GoldEquip = ıtemTemplateInfo4;
							}
						}
					}
					ınventory2.RemoveItemAt(num2);
					ınventory2.AddItemTo(ıtemInfo2, 1);
				}
				else
				{
					ınventory.UpdateItem(itemZero);
					ınventory2.UpdateItem(itemOne);
				}
				gSPacketIn.WriteByte(0);
				client.Out.SendTCP(gSPacketIn);
			}
			else
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("itemtransferhandler.nocondition"));
			}
			return 0;
		}

		public bool TransferCondition(ItemInfo itemAtZero, ItemInfo itemAtOne)
		{
			return (itemAtZero.Template.CategoryID == 7 || itemAtOne.Template.CategoryID == 7) && (itemAtZero.StrengthenLevel >= 10 || itemAtOne.StrengthenLevel >= 10);
		}

		private int method_0(ItemInfo itemInfo_0)
		{
			StrengthenGoodsInfo strengthenGoodsInfo = StrengthenMgr.FindTransferInfo(itemInfo_0.TemplateID);
			if (strengthenGoodsInfo == null)
			{
				GoldEquipTemplateInfo goldEquipTemplateInfo = GoldEquipMgr.FindGoldEquipOldTemplate(itemInfo_0.TemplateID);
				if (goldEquipTemplateInfo == null)
				{
					return 0;
				}
				strengthenGoodsInfo = StrengthenMgr.FindTransferInfo(goldEquipTemplateInfo.OldTemplateId);
			}
			return strengthenGoodsInfo.OriginalEquip;
		}

		private int method_1(ItemInfo itemInfo_0)
		{
			return itemInfo_0.StrengthenLevel switch
			{
				10 => StrengthenMgr.FindTransferInfo(10, itemInfo_0.TemplateID)?.GainEquip ?? (-1), 
				11 => StrengthenMgr.FindTransferInfo(11, itemInfo_0.TemplateID)?.GainEquip ?? (-1), 
				12 => StrengthenMgr.FindTransferInfo(12, itemInfo_0.TemplateID)?.GainEquip ?? (-1), 
				13 => StrengthenMgr.FindTransferInfo(13, itemInfo_0.TemplateID)?.GainEquip ?? (-1), 
				14 => StrengthenMgr.FindTransferInfo(14, itemInfo_0.TemplateID)?.GainEquip ?? (-1), 
				15 => StrengthenMgr.FindTransferInfo(15, itemInfo_0.TemplateID)?.GainEquip ?? (-1), 
				_ => StrengthenMgr.FindTransferInfo(itemInfo_0.TemplateID)?.OriginalEquip ?? (-1), 
			};
		}
	}
}
