using System.Linq;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(54, "购买道具")]
	public class PropBuyHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			SpecialItemBoxInfo specialValue = new SpecialItemBoxInfo();
			int ıD = packet.ReadInt();
			int num = 1;
			ShopItemInfo shopItemInfoById = ShopMgr.GetShopItemInfoById(ıD);
			if (shopItemInfoById == null)
			{
				return 0;
			}
			int[] source = new int[8] { 10009, 10010, 10011, 10012, 10015, 10016, 10017, 10018 };
			if (!source.Contains(shopItemInfoById.TemplateID))
			{
				client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("PropBuyHandler.SystemNotSell"));
				client.Player.ClearFightBag();
				return 0;
			}
			ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(shopItemInfoById.TemplateID);
			ShopMgr.SetItemType(shopItemInfoById, num, ref specialValue);
			if (ıtemTemplateInfo.CategoryID == 10)
			{
				PlayerInfo playerCharacter = client.Player.PlayerCharacter;
				if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked && (specialValue.Money > 0 || specialValue.Offer > 0 || specialValue.DDTMoney > 0 || specialValue.Medal > 0))
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
					return 0;
				}
				if (specialValue.Gold <= playerCharacter.Gold && specialValue.Money <= ((playerCharacter.Money >= 0) ? playerCharacter.Money : 0) && specialValue.Offer <= playerCharacter.Offer && specialValue.DDTMoney <= playerCharacter.DDTMoney && specialValue.Medal <= playerCharacter.medal)
				{
					ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 102);
					if (shopItemInfoById.BuyType == 0)
					{
						if (1 == num)
						{
							ıtemInfo.ValidDate = shopItemInfoById.AUnit;
						}
						if (2 == num)
						{
							ıtemInfo.ValidDate = shopItemInfoById.BUnit;
						}
						if (3 == num)
						{
							ıtemInfo.ValidDate = shopItemInfoById.CUnit;
						}
					}
					else
					{
						if (1 == num)
						{
							ıtemInfo.Count = shopItemInfoById.AUnit;
						}
						if (2 == num)
						{
							ıtemInfo.Count = shopItemInfoById.BUnit;
						}
						if (3 == num)
						{
							ıtemInfo.Count = shopItemInfoById.CUnit;
						}
					}
					if (client.Player.FightBag.AddItem(ıtemInfo, 0))
					{
						client.Player.DirectRemoveValue(specialValue);
					}
				}
				else
				{
					client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("PropBuyHandler.NoMoney"));
				}
			}
			return 0;
		}
	}
}
