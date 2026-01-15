using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.ActiveSystem.Handle
{
	public class ActiveSystemHandleMgr
	{
		private Dictionary<int, IActiveSystemCommandHadler> dictionary_0;

		public IActiveSystemCommandHadler LoadCommandHandler(int code)
		{
			return dictionary_0[code];
		}

		public ActiveSystemHandleMgr()
		{
			dictionary_0 = new Dictionary<int, IActiveSystemCommandHadler>();
			dictionary_0.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
		}

		protected int SearchCommandHandlers(Assembly assembly)
		{
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.ActiveSystem.Handle.IActiveSystemCommandHadler") == null))
				{
					Attribute0[] array = (Attribute0[])type.GetCustomAttributes(typeof(Attribute0), inherit: true);
					if (array.Length > 0)
					{
						num++;
						RegisterCommandHandler(array[0].method_0(), Activator.CreateInstance(type) as IActiveSystemCommandHadler);
					}
				}
			}
			return num;
		}

		protected void RegisterCommandHandler(int code, IActiveSystemCommandHadler handle)
		{
			dictionary_0.Add(code, handle);
		}
	}
}
