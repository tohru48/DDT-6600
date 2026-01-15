using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.GameRoom.Handle
{
	public class GameRoomHandleMgr
	{
		private Dictionary<int, IGameRoomCommandHadler> dictionary_0;

		public IGameRoomCommandHadler LoadCommandHandler(int code)
		{
			return dictionary_0[code];
		}

		public GameRoomHandleMgr()
		{
			dictionary_0 = new Dictionary<int, IGameRoomCommandHadler>();
			dictionary_0.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
		}

		protected int SearchCommandHandlers(Assembly assembly)
		{
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.GameRoom.Handle.IGameRoomCommandHadler") == null))
				{
					Attribute7[] array = (Attribute7[])type.GetCustomAttributes(typeof(Attribute7), inherit: true);
					if (array.Length > 0)
					{
						num++;
						RegisterCommandHandler(array[0].method_0(), Activator.CreateInstance(type) as IGameRoomCommandHadler);
					}
				}
			}
			return num;
		}

		protected void RegisterCommandHandler(int code, IGameRoomCommandHadler handle)
		{
			dictionary_0.Add(code, handle);
		}
	}
}
