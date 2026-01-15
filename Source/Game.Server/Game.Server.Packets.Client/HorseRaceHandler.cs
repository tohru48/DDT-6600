using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.BuffHorseRace;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(282, "场景用户离开")]
	public class HorseRaceHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			packet.ReadInt();
			switch (packet.ReadInt())
			{
			case 1:
			{
				int num = packet.ReadInt();
				int num2 = packet.ReadInt();
				int num3 = packet.ReadInt();
				packet.ReadInt();
				if (client.Player.PlayerCharacter.ID != num2 || client.Player.CurrentHorseRaceInfo == null || client.Player.CurrentHorseRaceRoom == null)
				{
					break;
				}
				GamePlayer gamePlayer = null;
				string buffName = LanguageMgr.GetTranslation("GameServer.HorseGame.Msg.All");
				if (num3 != 0)
				{
					gamePlayer = client.Player.CurrentHorseRaceRoom.GetPlayerByID(num3);
				}
				switch (num)
				{
				case 1:
					if (num3 != 0 && num3 != num2)
					{
						if (gamePlayer == null)
						{
							client.Player.SendMessage(LanguageMgr.GetTranslation("GameServer.HorseGame.NoHavePlayer"));
							return 0;
						}
						BuffHorseRaceInfo info = new BuffHorseRaceInfo(1, 3);
						AbstractHorseRaceBuffer abstractHorseRaceBuffer = gamePlayer.CurrentHorseRaceInfo.BuffList.CreateBuffer(info, 0);
						if (abstractHorseRaceBuffer != null && client.Player.CurrentHorseRaceInfo.RemoveBuff(num))
						{
							abstractHorseRaceBuffer.Start(gamePlayer.CurrentHorseRaceInfo, client.Player.CurrentHorseRaceInfo);
							buffName = gamePlayer.PlayerCharacter.NickName;
						}
						break;
					}
					client.Player.SendMessage(LanguageMgr.GetTranslation("GameServer.HorseGame.NoSelectPlayer"));
					return 0;
				case 2:
					if (num3 != 0 && num3 != num2)
					{
						if (gamePlayer == null)
						{
							client.Player.SendMessage(LanguageMgr.GetTranslation("GameServer.HorseGame.NoHavePlayer"));
							return 0;
						}
						BuffHorseRaceInfo info = new BuffHorseRaceInfo(2, 5);
						AbstractHorseRaceBuffer abstractHorseRaceBuffer = client.Player.CurrentHorseRaceInfo.BuffList.CreateBuffer(info, 0);
						if (abstractHorseRaceBuffer != null && client.Player.CurrentHorseRaceInfo.RemoveBuff(num))
						{
							abstractHorseRaceBuffer.Start(gamePlayer.CurrentHorseRaceInfo, client.Player.CurrentHorseRaceInfo);
							buffName = gamePlayer.PlayerCharacter.NickName;
						}
						break;
					}
					client.Player.SendMessage(LanguageMgr.GetTranslation("GameServer.HorseGame.NoSelectPlayer"));
					return 0;
				case 3:
					if (num3 != 0 && num3 != num2)
					{
						if (gamePlayer == null)
						{
							client.Player.SendMessage(LanguageMgr.GetTranslation("GameServer.HorseGame.NoHavePlayer"));
							return 0;
						}
						BuffHorseRaceInfo info = new BuffHorseRaceInfo(3, 5);
						AbstractHorseRaceBuffer abstractHorseRaceBuffer = client.Player.CurrentHorseRaceInfo.BuffList.CreateBuffer(info, 0);
						if (abstractHorseRaceBuffer != null && client.Player.CurrentHorseRaceInfo.RemoveBuff(num))
						{
							abstractHorseRaceBuffer.Start(client.Player.CurrentHorseRaceInfo, client.Player.CurrentHorseRaceInfo);
							abstractHorseRaceBuffer = client.Player.CurrentHorseRaceInfo.BuffList.CreateBuffer(info, 0);
							abstractHorseRaceBuffer.Start(gamePlayer.CurrentHorseRaceInfo, client.Player.CurrentHorseRaceInfo);
							buffName = gamePlayer.PlayerCharacter.NickName;
						}
						break;
					}
					client.Player.SendMessage(LanguageMgr.GetTranslation("GameServer.HorseGame.NoSelectPlayer"));
					return 0;
				case 5:
					if (num3 != 0 && num3 != num2)
					{
						if (gamePlayer == null)
						{
							client.Player.SendMessage(LanguageMgr.GetTranslation("GameServer.HorseGame.NoHavePlayer"));
							return 0;
						}
						BuffHorseRaceInfo info = new BuffHorseRaceInfo(5, 10);
						AbstractHorseRaceBuffer abstractHorseRaceBuffer = gamePlayer.CurrentHorseRaceInfo.BuffList.CreateBuffer(info, gamePlayer.CurrentHorseRaceInfo.Speed);
						if (abstractHorseRaceBuffer != null && client.Player.CurrentHorseRaceInfo.RemoveBuff(num))
						{
							abstractHorseRaceBuffer.Start(client.Player.CurrentHorseRaceInfo, client.Player.CurrentHorseRaceInfo);
							buffName = gamePlayer.PlayerCharacter.NickName;
						}
						break;
					}
					client.Player.SendMessage(LanguageMgr.GetTranslation("GameServer.HorseGame.NoSelectPlayer"));
					return 0;
				case 6:
				{
					BuffHorseRaceInfo info = new BuffHorseRaceInfo(6, 5);
					AbstractHorseRaceBuffer abstractHorseRaceBuffer = client.Player.CurrentHorseRaceInfo.BuffList.CreateBuffer(info, 0);
					if (abstractHorseRaceBuffer != null && client.Player.CurrentHorseRaceInfo.RemoveBuff(num))
					{
						abstractHorseRaceBuffer.Start(client.Player.CurrentHorseRaceInfo, client.Player.CurrentHorseRaceInfo);
						buffName = client.Player.PlayerCharacter.NickName;
					}
					break;
				}
				case 7:
				{
					BuffHorseRaceInfo info = new BuffHorseRaceInfo(7, 2);
					AbstractHorseRaceBuffer abstractHorseRaceBuffer = client.Player.CurrentHorseRaceInfo.BuffList.CreateBuffer(info, 0);
					if (abstractHorseRaceBuffer == null || !client.Player.CurrentHorseRaceInfo.RemoveBuff(num))
					{
						break;
					}
					GamePlayer[] playersUnSafe = client.Player.CurrentHorseRaceRoom.GetPlayersUnSafe();
					GamePlayer[] array = playersUnSafe;
					foreach (GamePlayer gamePlayer2 in array)
					{
						if (gamePlayer2 != client.Player)
						{
							abstractHorseRaceBuffer = client.Player.CurrentHorseRaceInfo.BuffList.CreateBuffer(info, 0);
							abstractHorseRaceBuffer.Start(gamePlayer2.CurrentHorseRaceInfo, client.Player.CurrentHorseRaceInfo);
						}
					}
					break;
				}
				}
				client.Player.CurrentHorseRaceRoom.SendShowMsg(client.Player.PlayerCharacter.NickName, buffName, LanguageMgr.GetTranslation(method_0(num)));
				client.Player.CurrentHorseRaceRoom.SendUpdateBuffItem(client.Player, successpingzhang: false);
				break;
			}
			case 2:
			{
				if (client.Player.CurrentHorseRaceInfo == null)
				{
					return 0;
				}
				int horseGameUsePapawMoney = GameProperties.HorseGameUsePapawMoney;
				if (client.Player.MoneyDirect(horseGameUsePapawMoney))
				{
					client.Player.CurrentHorseRaceInfo.BuffList.StopAll();
					client.Player.CurrentHorseRaceRoom.SendUpdateBuffItem(client.Player, successpingzhang: true);
				}
				break;
			}
			case 3:
				if (client.Player.CurrentHorseRaceInfo != null)
				{
					client.Player.CurrentHorseRaceInfo.FinishTime = DateTime.Now;
				}
				break;
			case 4:
			{
				int horseGameCostMoneyCount = GameProperties.HorseGameCostMoneyCount;
				if (client.Player.MoneyDirect(horseGameCostMoneyCount))
				{
					client.Player.AddHorseRaceTimes(1);
					client.Player.SendMessage(LanguageMgr.GetTranslation("GameServer.HorseGame.BuyTimesSucess"));
				}
				break;
			}
			}
			return 0;
		}

		private string method_0(int int_0)
		{
			return int_0 switch
			{
				1 => "GameServer.HorseGame.Msg.BuffName1", 
				2 => "GameServer.HorseGame.Msg.BuffName2", 
				3 => "GameServer.HorseGame.Msg.BuffName3", 
				5 => "GameServer.HorseGame.Msg.BuffName5", 
				6 => "GameServer.HorseGame.Msg.BuffName6", 
				7 => "GameServer.HorseGame.Msg.BuffName7", 
				8 => "GameServer.HorseGame.Msg.BuffName8", 
				_ => "Unknown", 
			};
		}
	}
}
