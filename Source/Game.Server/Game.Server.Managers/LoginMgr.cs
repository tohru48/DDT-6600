using System.Collections.Generic;
using Bussiness;
using Game.Server.GameObjects;

namespace Game.Server.Managers
{
	public class LoginMgr
	{
		private static Dictionary<int, GameClient> dictionary_0;

		private static object object_0;

		public static void Add(int player, GameClient server)
		{
			GameClient gameClient = null;
			lock (object_0)
			{
				if (dictionary_0.ContainsKey(player))
				{
					GameClient gameClient2 = dictionary_0[player];
					if (gameClient2 != null)
					{
						gameClient = gameClient2;
					}
					dictionary_0[player] = server;
				}
				else
				{
					dictionary_0.Add(player, server);
				}
			}
			if (gameClient != null)
			{
				gameClient.Out.SendKitoff(LanguageMgr.GetTranslation("Game.Server.LoginNext"));
				gameClient.Disconnect();
			}
		}

		public static void Remove(int player)
		{
			lock (object_0)
			{
				if (dictionary_0.ContainsKey(player))
				{
					dictionary_0.Remove(player);
				}
			}
		}

		public static GamePlayer LoginClient(int playerId)
		{
			GameClient gameClient = null;
			lock (object_0)
			{
				if (dictionary_0.ContainsKey(playerId))
				{
					gameClient = dictionary_0[playerId];
					dictionary_0.Remove(playerId);
				}
			}
			return gameClient?.Player;
		}

		public static void ClearLoginPlayer(int playerId)
		{
			GameClient gameClient = null;
			lock (object_0)
			{
				if (dictionary_0.ContainsKey(playerId))
				{
					gameClient = dictionary_0[playerId];
					dictionary_0.Remove(playerId);
				}
			}
			if (gameClient != null)
			{
				gameClient.Out.SendKitoff(LanguageMgr.GetTranslation("Game.Server.LoginNext"));
				gameClient.Disconnect();
			}
		}

		public static void ClearLoginPlayer(int playerId, GameClient client)
		{
			lock (object_0)
			{
				if (dictionary_0.ContainsKey(playerId) && dictionary_0[playerId] == client)
				{
					dictionary_0.Remove(playerId);
				}
			}
		}

		public static bool ContainsUser(int playerId)
		{
			lock (object_0)
			{
				if (dictionary_0.ContainsKey(playerId) && dictionary_0[playerId].IsConnected)
				{
					return true;
				}
				return false;
			}
		}

		public static bool ContainsUser(string account)
		{
			bool result;
			lock (object_0)
			{
				foreach (GameClient value in dictionary_0.Values)
				{
					if (value != null && value.Player != null && value.Player.Account == account)
					{
						result = true;
						return result;
					}
				}
				result = false;
			}
			return result;
		}

		static LoginMgr()
		{
			dictionary_0 = new Dictionary<int, GameClient>();
			object_0 = new object();
		}
	}
}
