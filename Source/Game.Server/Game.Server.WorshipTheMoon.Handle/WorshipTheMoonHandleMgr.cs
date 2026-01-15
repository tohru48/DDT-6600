using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.WorshipTheMoon.Handle
{
	public class WorshipTheMoonHandleMgr
	{
		private Dictionary<int, IWorshipTheMoonCommandHadler> dictionary_0;

		public IWorshipTheMoonCommandHadler LoadCommandHandler(int code)
		{
			return dictionary_0[code];
		}

		public WorshipTheMoonHandleMgr()
		{
			dictionary_0 = new Dictionary<int, IWorshipTheMoonCommandHadler>();
			dictionary_0.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
		}

		protected int SearchCommandHandlers(Assembly assembly)
		{
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.WorshipTheMoon.Handle.IWorshipTheMoonCommandHadler") == null))
				{
					Attribute16[] array = (Attribute16[])type.GetCustomAttributes(typeof(Attribute16), inherit: true);
					if (array.Length > 0)
					{
						num++;
						RegisterCommandHandler(array[0].method_0(), Activator.CreateInstance(type) as IWorshipTheMoonCommandHadler);
					}
				}
			}
			return num;
		}

		protected void RegisterCommandHandler(int code, IWorshipTheMoonCommandHadler handle)
		{
			dictionary_0.Add(code, handle);
		}
	}
}
