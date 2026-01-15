using System.Collections.Generic;
using System.Text;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameUtils;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(78, "熔化")]
	public class ItemFusionHandler : IPacketHandler
	{
		public static ThreadSafeRandom random;

		public static readonly ILog log;

		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return 0;
			}
			int fusionId = packet.ReadInt();
			int num = packet.ReadInt();
			packet.ReadBoolean();
			bool ısBinds = true;
			StringBuilder stringBuilder = new StringBuilder();
			int validDate = 30;
			FusionInfo fusionInfo = FusionMgr.FindItemFusion(fusionId);
			if (fusionInfo == null)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemFusionHandler.NoCondition"));
				return 1;
			}
			ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(fusionInfo.Reward);
			if (ıtemTemplateInfo == null)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemFusionHandler.NoCondition"));
				return 1;
			}
			PlayerEquipInventory equipBag = client.Player.EquipBag;
			if (ıtemTemplateInfo.BagType == eBageType.PropBag)
			{
				PlayerInventory propBag = client.Player.PropBag;
				validDate = 0;
			}
			int num2 = client.Player.EquipBag.FindFirstEmptySlot();
			int num3 = client.Player.PropBag.FindFirstEmptySlot();
			if ((num2 == -1 && ıtemTemplateInfo.BagType == eBageType.EquipBag) || (num3 == -1 && ıtemTemplateInfo.BagType == eBageType.PropBag))
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"));
				return 0;
			}
			int ıtemCount = client.Player.GetItemCount(fusionInfo.Item1);
			int num4 = ıtemCount / fusionInfo.Count1;
			if (num > num4)
			{
				num = num4;
			}
			int num5 = fusionInfo.Count1 * num;
			bool flag = true;
			if (num > 1)
			{
				if (ıtemCount < num5)
				{
					flag = false;
				}
			}
			else if (ıtemCount < fusionInfo.Count1)
			{
				flag = false;
			}
			if (!flag)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemFusionHandler.NoCondition"));
				return 0;
			}
			int num6 = GameProperties.PRICE_FUSION_GOLD * fusionInfo.Count1 * num;
			if (client.Player.PlayerCharacter.Gold < num6)
			{
				client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("ItemFusionHandler.NoMoney"));
				return 0;
			}
			List<ItemInfo> list = new List<ItemInfo>();
			client.Player.RemoveGold(num6);
			client.Player.RemoveTemplate(fusionInfo.Item1, num5);
			stringBuilder.Append(ıtemTemplateInfo.TemplateID + ",");
			ItemInfo ıtemInfo = null;
			for (int i = 0; i < num; i++)
			{
				if (random.Next(100000) <= fusionInfo.FusionRate)
				{
					ItemInfo ıtemInfo2 = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 105);
					ıtemInfo2.IsBinds = ısBinds;
					ıtemInfo2.ValidDate = validDate;
					if (ıtemTemplateInfo.MaxCount == 1)
					{
						list.Add(ıtemInfo2);
					}
					else if (ıtemInfo == null)
					{
						ıtemInfo = ıtemInfo2;
					}
				}
			}
			if (ıtemInfo != null)
			{
				ıtemInfo.Count = num;
				list.Add(ıtemInfo);
			}
			if (list.Count > 0)
			{
				client.Out.SendFusionResult(client.Player, result: true);
				client.Player.OnItemFusion(fusionInfo.FusionType);
				foreach (ItemInfo item in list)
				{
					client.Player.AddTemplate(item);
				}
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemFusionHandler.Succeed1", ıtemTemplateInfo.Name + " x" + num));
			}
			else
			{
				client.Out.SendFusionResult(client.Player, result: false);
				stringBuilder.Append("false");
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemFusionHandler.Failed"));
			}
			return 0;
		}

		static ItemFusionHandler()
		{
			random = new ThreadSafeRandom();
			log = LogManager.GetLogger("FlashErrorLogger");
		}
	}
}
