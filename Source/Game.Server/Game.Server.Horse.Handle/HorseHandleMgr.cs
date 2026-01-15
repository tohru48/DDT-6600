using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.Horse.Handle
{
	public class HorseHandleMgr
	{
		private Dictionary<int, IHorseCommandHadler> dictionary_0;

		public IHorseCommandHadler LoadCommandHandler(int code)
		{
			return dictionary_0[code];
		}

		public HorseHandleMgr()
		{
			dictionary_0 = new Dictionary<int, IHorseCommandHadler>();
			dictionary_0.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
		}

		protected int SearchCommandHandlers(Assembly assembly)
		{
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.Horse.Handle.IHorseCommandHadler") == null))
				{
					Attribute9[] array = (Attribute9[])type.GetCustomAttributes(typeof(Attribute9), inherit: true);
					if (array.Length > 0)
					{
						num++;
						RegisterCommandHandler(array[0].method_0(), Activator.CreateInstance(type) as IHorseCommandHadler);
					}
				}
			}
			return num;
		}

		protected void RegisterCommandHandler(int code, IHorseCommandHadler handle)
		{
			dictionary_0.Add(code, handle);
		}
	}
}
