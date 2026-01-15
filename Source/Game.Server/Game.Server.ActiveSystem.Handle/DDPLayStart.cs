using System.Linq;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using Game.Server.Packets;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(76)]
	public class DDPLayStart : IActiveSystemCommandHadler
	{
		public static ThreadSafeRandom random;

		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(76);
			int num = 0;
			if (Player.PropBag.GetItemCount(201310) <= 0)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("DDPLayStart.NotEnoughtCoin"));
			}
			else
			{
				Player.PropBag.RemoveTemplate(201310, 1);
				Player.Actives.Info.Int32_0 += 10;
				num = random.Next(50);
				int[] source = new int[4] { 2, 3, 5, 10 };
				if (source.Contains(num))
				{
					int money = GameProperties.int_0 * num;
					using (PlayerBussiness pb = new PlayerBussiness())
					{
						Player.SendMoneyMailToUser(pb, LanguageMgr.GetTranslation("DDPLayStart.XCoin", num), LanguageMgr.GetTranslation("DDPLayStart.Title", num), money, eMailType.BuyItem);
					}
					string translation = LanguageMgr.GetTranslation("DDPLayStart.Notice", Player.PlayerCharacter.NickName, num);
					GSPacketIn packet2 = WorldMgr.SendCrossSysNotice(translation, Player.ZoneId);
					GameServer.Instance.LoginServer.SendPacket(packet2);
				}
				else
				{
					num = 0;
				}
			}
			gSPacketIn.WriteInt(num);
			gSPacketIn.WriteInt(Player.Actives.Info.Int32_0);
			Player.Out.SendTCP(gSPacketIn);
			return true;
		}

		static DDPLayStart()
		{
			random = new ThreadSafeRandom();
		}
	}
}
