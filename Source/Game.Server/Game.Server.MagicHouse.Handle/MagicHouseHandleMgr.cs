using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.MagicHouse.Handle
{
	public class MagicHouseHandleMgr
	{
		private Dictionary<int, IMagicHouseCommandHadler> dictionary_0;

		public IMagicHouseCommandHadler LoadCommandHandler(int code)
		{
			return dictionary_0[code];
		}

		public MagicHouseHandleMgr()
		{
			dictionary_0 = new Dictionary<int, IMagicHouseCommandHadler>();
			dictionary_0.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
		}

		protected int SearchCommandHandlers(Assembly assembly)
		{
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.MagicHouse.Handle.IMagicHouseCommandHadler") == null))
				{
					Attribute10[] array = (Attribute10[])type.GetCustomAttributes(typeof(Attribute10), inherit: true);
					if (array.Length > 0)
					{
						num++;
						RegisterCommandHandler(array[0].method_0(), Activator.CreateInstance(type) as IMagicHouseCommandHadler);
					}
				}
			}
			return num;
		}

		protected void RegisterCommandHandler(int code, IMagicHouseCommandHadler handle)
		{
			dictionary_0.Add(code, handle);
		}
	}
}
