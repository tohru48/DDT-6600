using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(134, "场景用户离开")]
	public class DiceHandler : IPacketHandler
	{
		private ThreadSafeRandom threadSafeRandom_0;

		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			byte b = packet.ReadByte();
			int ıD = client.Player.PlayerCharacter.ID;
			switch (b)
			{
			case 10:
				client.Player.Dice.ReceiveData();
				client.Player.Out.SendDiceReceiveData(client.Player.Dice);
				break;
			case 11:
			{
				if (client.Player.Dice.Data.LuckIntegral >= client.Player.Dice.IntegralPoint[client.Player.Dice.MAX_LEVEL - 1])
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("DiceHandler.Msg1"));
					return 0;
				}
				int num = packet.ReadInt();
				packet.ReadInt();
				int int_;
				int value;
				switch (num)
				{
				case 1:
					int_ = threadSafeRandom_0.Next(2, 13);
					value = client.Player.Dice.doubleDicePrice;
					break;
				case 2:
					int_ = threadSafeRandom_0.Next(4, 7);
					value = client.Player.Dice.bigDicePrice;
					break;
				case 3:
					int_ = threadSafeRandom_0.Next(1, 4);
					value = client.Player.Dice.smallDicePrice;
					break;
				default:
					int_ = threadSafeRandom_0.Next(1, 7);
					value = client.Player.Dice.commonDicePrice;
					break;
				}
				if (client.Player.Dice.Data.FreeCount > 0)
				{
					client.Player.Dice.Data.FreeCount--;
					method_0(client.Player, int_);
				}
				else if (client.Player.MoneyDirect(value))
				{
					method_0(client.Player, int_);
				}
				break;
			}
			case 12:
			{
				int refreshPrice = client.Player.Dice.refreshPrice;
				if (client.Player.MoneyDirect(refreshPrice))
				{
					client.Player.Dice.CreateDiceAward();
					client.Player.Out.SendDiceReceiveData(client.Player.Dice);
				}
				break;
			}
			}
			return 0;
		}

		private void method_0(GamePlayer gamePlayer_0, int int_0)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(134);
			gSPacketIn.WriteByte(4);
			gSPacketIn.WriteInt(gamePlayer_0.Dice.Data.CurrentPosition);
			gSPacketIn.WriteInt(int_0);
			gamePlayer_0.Dice.Data.CurrentPosition += int_0;
			if (gamePlayer_0.Dice.Data.CurrentPosition > 18)
			{
				gamePlayer_0.Dice.Data.CurrentPosition -= 19;
			}
			EventAwardInfo eventAwardInfo = gamePlayer_0.Dice.RewardItem[gamePlayer_0.Dice.Data.CurrentPosition];
			ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(eventAwardInfo.TemplateID), eventAwardInfo.Count, 103);
			ıtemInfo.IsBinds = eventAwardInfo.IsBinds;
			if (!gamePlayer_0.AddTemplate(ıtemInfo, LanguageMgr.GetTranslation("DiceHandler.Msg2")))
			{
				gamePlayer_0.SendItemToMail(ıtemInfo, ıtemInfo.Template.Name.ToString(), LanguageMgr.GetTranslation("DiceHandler.Msg3"), eMailType.OpenUpArk);
			}
			gamePlayer_0.Dice.RewardName = ıtemInfo.Template.Name;
			int num = threadSafeRandom_0.Next(2, 13);
			gamePlayer_0.Dice.Data.LuckIntegral += num;
			int luckIntegralLevel = gamePlayer_0.Dice.Data.LuckIntegralLevel;
			if (gamePlayer_0.Dice.Data.LuckIntegral >= gamePlayer_0.Dice.IntegralPoint[luckIntegralLevel + 1])
			{
				gamePlayer_0.Dice.Data.LuckIntegralLevel++;
				gamePlayer_0.PlayerCharacter.luckyNum++;
				gamePlayer_0.Dice.GetLevelAward();
			}
			if (gamePlayer_0.Dice.Data.LuckIntegralLevel > 3)
			{
				gamePlayer_0.Dice.Data.LuckIntegralLevel = 3;
				gamePlayer_0.Dice.Data.LuckIntegral = gamePlayer_0.Dice.IntegralPoint[gamePlayer_0.Dice.MAX_LEVEL - 1];
			}
			gSPacketIn.WriteInt(gamePlayer_0.Dice.Data.LuckIntegral);
			gSPacketIn.WriteInt(gamePlayer_0.Dice.Data.LuckIntegralLevel);
			gSPacketIn.WriteInt(gamePlayer_0.Dice.Data.FreeCount);
			gSPacketIn.WriteString(gamePlayer_0.Dice.RewardName);
			gamePlayer_0.Out.SendTCP(gSPacketIn);
		}

		public DiceHandler()
		{
			threadSafeRandom_0 = new ThreadSafeRandom();
		}
	}
}
