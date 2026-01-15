using System;
using System.Collections.Generic;
using System.Linq;
namespace Center.Server
{
	public class LoginMgr
	{
		private static System.Collections.Generic.Dictionary<int, Player> dictionary_0;
		private static object object_0;
		public static void CreatePlayer(Player player)
		{
			Player player2 = null;
			lock (LoginMgr.object_0)
			{
				player.LastTime = System.DateTime.Now.Ticks;
				if (LoginMgr.dictionary_0.ContainsKey(player.Id))
				{
					player2 = LoginMgr.dictionary_0[player.Id];
					player.State = player2.State;
					player.CurrentServer = player2.CurrentServer;
					LoginMgr.dictionary_0[player.Id] = player;
				}
				else
				{
					player2 = LoginMgr.GetPlayerByName(player.Name);
					if (player2 != null && LoginMgr.dictionary_0.ContainsKey(player2.Id))
					{
						LoginMgr.dictionary_0.Remove(player2.Id);
					}
					player.State = ePlayerState.NotLogin;
					LoginMgr.dictionary_0.Add(player.Id, player);
				}
			}
			if (player2 != null && player2.CurrentServer != null)
			{
				player2.CurrentServer.SendKitoffUser(player2.Id);
			}
		}
		public static bool TryLoginPlayer(int id, ServerClient server)
		{
			bool result;
			lock (LoginMgr.object_0)
			{
				if (LoginMgr.dictionary_0.ContainsKey(id))
				{
					Player player = LoginMgr.dictionary_0[id];
					if (player.CurrentServer == null)
					{
						player.CurrentServer = server;
						player.State = ePlayerState.Logining;
						result = true;
					}
					else
					{
						if (player.State == ePlayerState.Play)
						{
							player.CurrentServer.SendKitoffUser(id);
						}
						result = false;
					}
				}
				else
				{
					result = false;
				}
			}
			return result;
		}
		public static void PlayerLogined(int id, ServerClient server)
		{
			lock (LoginMgr.object_0)
			{
				if (LoginMgr.dictionary_0.ContainsKey(id))
				{
					Player player = LoginMgr.dictionary_0[id];
					if (player != null)
					{
						player.CurrentServer = server;
						player.State = ePlayerState.Play;
					}
				}
			}
		}
		public static void PlayerLoginOut(int id, ServerClient server)
		{
			lock (LoginMgr.object_0)
			{
				if (LoginMgr.dictionary_0.ContainsKey(id))
				{
					Player player = LoginMgr.dictionary_0[id];
					if (player != null && player.CurrentServer == server)
					{
						player.CurrentServer = null;
						player.State = ePlayerState.NotLogin;
					}
				}
			}
		}
		public static Player GetPlayerByName(string name)
		{
			Player[] allPlayer = LoginMgr.GetAllPlayer();
			if (allPlayer != null)
			{
				Player[] array = allPlayer;
				for (int i = 0; i < array.Length; i++)
				{
					Player player = array[i];
					if (player.Name == name)
					{
						return player;
					}
				}
			}
			return null;
		}
		public static Player[] GetAllPlayer()
		{
			Player[] result;
			lock (LoginMgr.object_0)
			{
				result = LoginMgr.dictionary_0.Values.ToArray<Player>();
			}
			return result;
		}
		public static void RemovePlayer(int playerId)
		{
			lock (LoginMgr.object_0)
			{
				if (LoginMgr.dictionary_0.ContainsKey(playerId))
				{
					LoginMgr.dictionary_0.Remove(playerId);
				}
			}
		}
		public static void RemovePlayer(System.Collections.Generic.List<Player> players)
		{
			lock (LoginMgr.object_0)
			{
				foreach (Player current in players)
				{
					LoginMgr.dictionary_0.Remove(current.Id);
				}
			}
		}
		public static Player GetPlayer(int playerId)
		{
			lock (LoginMgr.object_0)
			{
				if (LoginMgr.dictionary_0.ContainsKey(playerId))
				{
					return LoginMgr.dictionary_0[playerId];
				}
			}
			return null;
		}
		public static ServerClient GetServerClient(int playerId)
		{
			Player player = LoginMgr.GetPlayer(playerId);
			if (player != null)
			{
				return player.CurrentServer;
			}
			return null;
		}
		public static int GetOnlineCount()
		{
			Player[] allPlayer = LoginMgr.GetAllPlayer();
			int num = 0;
			Player[] array = allPlayer;
			for (int i = 0; i < array.Length; i++)
			{
				Player player = array[i];
				if (player.State != ePlayerState.NotLogin)
				{
					num++;
				}
			}
			return num;
		}
		public static System.Collections.Generic.Dictionary<int, int> GetOnlineForLine()
		{
			System.Collections.Generic.Dictionary<int, int> dictionary = new System.Collections.Generic.Dictionary<int, int>();
			Player[] allPlayer = LoginMgr.GetAllPlayer();
			Player[] array = allPlayer;
			for (int i = 0; i < array.Length; i++)
			{
				Player player = array[i];
				if (player.CurrentServer != null)
				{
					if (dictionary.ContainsKey(player.CurrentServer.Info.ID))
					{
						System.Collections.Generic.Dictionary<int, int> dictionary2;
						int iD;
						(dictionary2 = dictionary)[iD = player.CurrentServer.Info.ID] = dictionary2[iD] + 1;
					}
					else
					{
						dictionary.Add(player.CurrentServer.Info.ID, 1);
					}
				}
			}
			return dictionary;
		}
		public static System.Collections.Generic.List<Player> GetServerPlayers(ServerClient server)
		{
			System.Collections.Generic.List<Player> list = new System.Collections.Generic.List<Player>();
			Player[] allPlayer = LoginMgr.GetAllPlayer();
			Player[] array = allPlayer;
			for (int i = 0; i < array.Length; i++)
			{
				Player player = array[i];
				if (player.CurrentServer == server)
				{
					list.Add(player);
				}
			}
			return list;
		}
		public LoginMgr()
		{
			
			
		}
		static LoginMgr()
		{
			
			LoginMgr.dictionary_0 = new System.Collections.Generic.Dictionary<int, Player>();
			LoginMgr.object_0 = new object();
		}
	}
}
