using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.BombKing.Handle
{
	public class BombKingHandleMgr
	{
		private Dictionary<int, IBombKingCommandHadler> dictionary_0;

		public IBombKingCommandHadler LoadCommandHandler(int code)
		{
			return dictionary_0[code];
		}

		public BombKingHandleMgr()
		{
			dictionary_0 = new Dictionary<int, IBombKingCommandHadler>();
			dictionary_0.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
		}

		protected int SearchCommandHandlers(Assembly assembly)
		{
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.BombKing.Handle.IBombKingCommandHadler") == null))
				{
					Attribute2[] array = (Attribute2[])type.GetCustomAttributes(typeof(Attribute2), inherit: true);
					if (array.Length > 0)
					{
						num++;
						RegisterCommandHandler(array[0].method_0(), Activator.CreateInstance(type) as IBombKingCommandHadler);
					}
				}
			}
			return num;
		}

		protected void RegisterCommandHandler(int code, IBombKingCommandHadler handle)
		{
			dictionary_0.Add(code, handle);
		}
	}
}
