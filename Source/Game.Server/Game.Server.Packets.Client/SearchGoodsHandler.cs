using System;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameUtils;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(98, "客户端日记")]
	public class SearchGoodsHandler : IPacketHandler
	{
		private static ThreadSafeRandom threadSafeRandom_0;

		private readonly int[] int_0;

		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			byte b = packet.ReadByte();
			client.Player.Extra.LoadBuriedQuests();
			PlayerExtra extra = client.Player.Extra;
			new GSPacketIn(98);
			if (client.Player.PlayerCharacter.Grade < 25)
			{
				return 0;
			}
			switch (b)
			{
			case 0:
			{
				threadSafeRandom_0.Shuffer(int_0);
				extra.GetSearchGoodItemsDb();
				int num = threadSafeRandom_0.Next(int_0.Length);
				extra.MapId = int_0[num];
				client.SendTCP(method_0(extra));
				break;
			}
			case 1:
			{
				bool isRemindRollBind = packet.ReadBoolean();
				extra.RollDiceCallBack(isRemindRollBind);
				break;
			}
			case 2:
			{
				if (extra.Info.starlevel < SearchGoodsMgr.MaxStar())
				{
					extra.Info.starlevel++;
				}
				SearchGoodsTempInfo searchGoodsTempInfo = SearchGoodsMgr.GetSearchGoodsTempInfo(extra.Info.starlevel);
				if (searchGoodsTempInfo != null && client.Player.MoneyDirect(searchGoodsTempInfo.NeedMoney))
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("SearchGoods.Msg1"));
					extra.CreateSearchGoodItems();
					client.SendTCP(method_0(extra));
				}
				else
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("SearchGoods.Msg2"));
				}
				break;
			}
			case 3:
			{
				bool useMoney = packet.ReadBoolean();
				extra.TakeCard(useMoney);
				break;
			}
			case 4:
				extra.Info.starlevel = 1;
				extra.Info.nowPosition = 0;
				extra.CreateSearchGoodItems();
				client.SendTCP(method_0(extra));
				break;
			case 5:
				extra.ConvertSearchGoodItems();
				break;
			default:
				Console.WriteLine("SearchGoodsPackageType." + (SearchGoodsPackageType)b);
				break;
			}
			return 0;
		}

		private GSPacketIn method_0(PlayerExtra playerExtra_0)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(98, playerExtra_0.Player.PlayerId);
			gSPacketIn.WriteByte(16);
			gSPacketIn.WriteInt(playerExtra_0.MapId);
			gSPacketIn.WriteInt(playerExtra_0.Info.starlevel);
			gSPacketIn.WriteInt(playerExtra_0.Info.nowPosition);
			gSPacketIn.WriteInt(playerExtra_0.Info.FreeCount);
			gSPacketIn.WriteInt(playerExtra_0.SearchGoodItems.Count);
			foreach (EventAwardInfo searchGoodItem in playerExtra_0.SearchGoodItems)
			{
				gSPacketIn.WriteInt(searchGoodItem.Position);
				gSPacketIn.WriteInt(searchGoodItem.TemplateID);
			}
			return gSPacketIn;
		}

		public SearchGoodsHandler()
		{
			int_0 = new int[3] { 1, 2, 3 };
		}

		static SearchGoodsHandler()
		{
			threadSafeRandom_0 = new ThreadSafeRandom();
		}
	}
}
