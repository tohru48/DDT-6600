using System;
using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(131, "场景用户离开")]
	public class LabyrinthHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			UserLabyrinthInfo userLabyrinthInfo = client.Player.Labyrinth;
			if (userLabyrinthInfo == null)
			{
				userLabyrinthInfo = client.Player.LoadLabyrinth();
			}
			int ıD = client.Player.PlayerCharacter.ID;
			switch (num)
			{
			case 1:
			{
				bool flag2 = packet.ReadBoolean();
				if (client.Player.PropBag.GetItemByTemplateID(0, 11916) == null)
				{
					return 0;
				}
				if (flag2 && !userLabyrinthInfo.isDoubleAward && client.Player.RemoveTemplate(11916, 1))
				{
					userLabyrinthInfo.isDoubleAward = flag2;
				}
				client.Player.Out.SendLabyrinthUpdataInfo(ıD, userLabyrinthInfo);
				return 0;
			}
			case 2:
				if (userLabyrinthInfo.isValidDate())
				{
					userLabyrinthInfo.completeChallenge = true;
					userLabyrinthInfo.accumulateExp = 0;
					userLabyrinthInfo.isInGame = false;
					userLabyrinthInfo.currentFloor = 1;
					userLabyrinthInfo.tryAgainComplete = true;
					userLabyrinthInfo.LastDate = DateTime.Now;
					userLabyrinthInfo.ProcessAward = client.Player.InitProcessAward();
				}
				client.Player.CalculatorClearnOutLabyrinth();
				client.Player.Out.SendLabyrinthUpdataInfo(ıD, userLabyrinthInfo);
				return 0;
			case 3:
			{
				int warriorFamRaidDDTPrice = GameProperties.WarriorFamRaidDDTPrice;
				if (client.Player.PlayerCharacter.DDTMoney < warriorFamRaidDDTPrice)
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("Labyrinth.Msg1"));
					client.Player.Actives.StopCleantOutLabyrinth();
					return 0;
				}
				userLabyrinthInfo.isCleanOut = true;
				client.Player.RemoveGiftToken(warriorFamRaidDDTPrice);
				client.Player.Actives.CleantOutLabyrinth();
				return 0;
			}
			case 4:
			{
				if (!userLabyrinthInfo.isCleanOut)
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("Labyrinth.Msg2"));
					return 0;
				}
				int num2 = Math.Abs(userLabyrinthInfo.currentRemainTime / 60);
				int num3 = GameProperties.WarriorFamRaidPricePerMin * num2;
				if (client.Player.Extra.UseKingBless(7))
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("Labyrinth.Msg3", num3));
					client.Player.Actives.SpeededUpCleantOutLabyrinth();
					return 0;
				}
				if (client.Player.MoneyDirect(num3))
				{
					client.Player.Actives.SpeededUpCleantOutLabyrinth();
					return 0;
				}
				return 0;
			}
			case 5:
				client.Player.Actives.StopCleantOutLabyrinth();
				return 0;
			case 6:
				if (userLabyrinthInfo.tryAgainComplete)
				{
					userLabyrinthInfo.currentFloor = 1;
					userLabyrinthInfo.accumulateExp = 0;
					userLabyrinthInfo.tryAgainComplete = false;
					userLabyrinthInfo.ProcessAward = client.Player.InitProcessAward();
					client.Player.SendMessage(LanguageMgr.GetTranslation("Labyrinth.Msg4"));
					client.Player.Out.SendLabyrinthUpdataInfo(ıD, userLabyrinthInfo);
					return 0;
				}
				client.Player.SendMessage(LanguageMgr.GetTranslation("Labyrinth.Msg5"));
				return 0;
			case 9:
			{
				bool flag = packet.ReadBoolean();
				packet.ReadBoolean();
				if (!flag)
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("Labyrinth.Msg4"));
					return 0;
				}
				int value = client.Player.LabyrinthTryAgainMoney();
				if (client.Player.MoneyDirect(value))
				{
					userLabyrinthInfo.completeChallenge = true;
					userLabyrinthInfo.isInGame = true;
					client.Player.SendMessage(LanguageMgr.GetTranslation("Labyrinth.Msg6"));
					return 0;
				}
				return 0;
			}
			default:
				Console.WriteLine("LabyrinthPackageType: " + (LabyrinthPackageType)num);
				return 0;
			}
		}
	}
}
