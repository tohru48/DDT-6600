using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.GypsyShop.Handle
{
	[Attribute8(3)]
	public class GypsyShopBuy : IGypsyShopCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int ıD = packet.ReadInt();
			packet.ReadBoolean();
			GypsyItemDataInfo mysteryShopByID = Player.Actives.GetMysteryShopByID(ıD);
			if (mysteryShopByID != null)
			{
				if (mysteryShopByID.CanBuy == 1)
				{
					bool flag = false;
					if (mysteryShopByID.Unit == 1 && Player.MoneyDirect(mysteryShopByID.Price))
					{
						flag = true;
					}
					else if (mysteryShopByID.Unit == 2 && Player.PlayerCharacter.myHonor >= mysteryShopByID.Price)
					{
						flag = true;
					}
					if (flag)
					{
						ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(mysteryShopByID.InfoID);
						if (ıtemTemplateInfo != null)
						{
							ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 105);
							ıtemInfo.IsBinds = true;
							ıtemInfo.ValidDate = mysteryShopByID.Num;
							Player.AddTemplate(ıtemInfo);
						}
						Player.SendMessage(LanguageMgr.GetTranslation("GypsyShopBuy.Success"));
						Player.Actives.UpdateMysteryShopByID(ıD);
						if (mysteryShopByID.Unit == 2)
						{
							Player.RemoveHonor(mysteryShopByID.Price);
						}
					}
					if (mysteryShopByID.Unit == 2 && !flag)
					{
						Player.SendMessage(LanguageMgr.GetTranslation("GypsyShopBuy.OutHornor"));
					}
					GSPacketIn gSPacketIn = new GSPacketIn(278, Player.PlayerCharacter.ID);
					gSPacketIn.WriteByte(3);
					gSPacketIn.WriteInt(mysteryShopByID.GypsyID);
					gSPacketIn.WriteBoolean(flag);
					if (flag)
					{
						gSPacketIn.WriteInt(mysteryShopByID.CanBuy);
					}
					Player.Out.SendTCP(gSPacketIn);
				}
				else
				{
					Player.SendMessage(LanguageMgr.GetTranslation("GypsyShopBuy.OutOfDate"));
				}
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("GypsyShopBuy.Fail"));
			}
			return false;
		}
	}
}
