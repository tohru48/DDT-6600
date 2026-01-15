using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.Farm.Handle
{
	public class FarmHandleMgr
	{
		private Dictionary<int, IFarmCommandHadler> dictionary_0;

		public IFarmCommandHadler LoadCommandHandler(int code)
		{
			return dictionary_0[code];
		}

		public FarmHandleMgr()
		{
			dictionary_0 = new Dictionary<int, IFarmCommandHadler>();
			dictionary_0.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
		}

		protected int SearchCommandHandlers(Assembly assembly)
		{
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.Farm.Handle.IFarmCommandHadler") == null))
				{
					Attribute5[] array = (Attribute5[])type.GetCustomAttributes(typeof(Attribute5), inherit: true);
					if (array.Length > 0)
					{
						num++;
						RegisterCommandHandler(array[0].method_0(), Activator.CreateInstance(type) as IFarmCommandHadler);
					}
				}
			}
			return num;
		}

		protected void RegisterCommandHandler(int code, IFarmCommandHadler handle)
		{
			dictionary_0.Add(code, handle);
		}
	}
}
