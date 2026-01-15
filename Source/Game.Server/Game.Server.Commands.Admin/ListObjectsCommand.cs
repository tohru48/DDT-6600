using System;
using System.Collections.Generic;
using Game.Base;
using Game.Logic;
using Game.Server.Battle;
using Game.Server.GameObjects;
using Game.Server.Games;
using Game.Server.Managers;
using Game.Server.Rooms;

namespace Game.Server.Commands.Admin
{
	public class ListObjectsCommand : AbstractCommandHandler, ICommandHandler
	{
		public bool OnCommand(BaseClient client, string[] args)
		{
			if (args.Length > 1)
			{
				switch (args[1])
				{
				case "-c":
				{
					Console.WriteLine("client list:");
					Console.WriteLine("-------------------------------");
					GameClient[] allClients = GameServer.Instance.GetAllClients();
					GameClient[] array = allClients;
					foreach (GameClient gameClient in array)
					{
						Console.WriteLine(gameClient.ToString());
					}
					Console.WriteLine("-------------------------------");
					Console.WriteLine($"total:{allClients.Length}");
					return true;
				}
				case "-p":
				{
					Console.WriteLine("player list:");
					Console.WriteLine("-------------------------------");
					GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
					GamePlayer[] array2 = allPlayers;
					foreach (GamePlayer gamePlayer in array2)
					{
						Console.WriteLine(gamePlayer.ToString());
					}
					Console.WriteLine("-------------------------------");
					Console.WriteLine($"total:{allPlayers.Length}");
					return true;
				}
				case "-r":
				{
					Console.WriteLine("room list:");
					Console.WriteLine("-------------------------------");
					List<BaseRoom> allUsingRoom = RoomMgr.GetAllUsingRoom();
					foreach (BaseRoom item in allUsingRoom)
					{
						Console.WriteLine(item.ToString());
					}
					Console.WriteLine("-------------------------------");
					Console.WriteLine($"total:{allUsingRoom.Count}");
					return true;
				}
				case "-g":
				{
					Console.WriteLine("game list:");
					Console.WriteLine("-------------------------------");
					List<BaseGame> allGame = GameMgr.GetAllGame();
					foreach (BaseGame item2 in allGame)
					{
						Console.WriteLine(item2.ToString());
					}
					Console.WriteLine("-------------------------------");
					Console.WriteLine($"total:{allGame.Count}");
					return true;
				}
				case "-b":
				{
					Console.WriteLine("battle list:");
					Console.WriteLine("-------------------------------");
					List<BattleServer> allBattles = BattleMgr.GetAllBattles();
					foreach (BattleServer item3 in allBattles)
					{
						Console.WriteLine(item3.ToString());
					}
					Console.WriteLine("-------------------------------");
					Console.WriteLine($"total:{allBattles.Count}");
					return true;
				}
				}
				DisplaySyntax(client);
			}
			else
			{
				DisplaySyntax(client);
			}
			return true;
		}
	}
}
