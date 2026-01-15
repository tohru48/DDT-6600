using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.Pet.Handle
{
	public class PetHandleMgr
	{
		private Dictionary<int, IPetCommandHadler> dictionary_0;

		public IPetCommandHadler LoadCommandHandler(int code)
		{
			return dictionary_0[code];
		}

		public PetHandleMgr()
		{
			dictionary_0 = new Dictionary<int, IPetCommandHadler>();
			dictionary_0.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
		}

		protected int SearchCommandHandlers(Assembly assembly)
		{
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.Pet.Handle.IPetCommandHadler") == null))
				{
					Attribute14[] array = (Attribute14[])type.GetCustomAttributes(typeof(Attribute14), inherit: true);
					if (array.Length > 0)
					{
						num++;
						RegisterCommandHandler(array[0].method_0(), Activator.CreateInstance(type) as IPetCommandHadler);
					}
				}
			}
			return num;
		}

		protected void RegisterCommandHandler(int code, IPetCommandHadler handle)
		{
			dictionary_0.Add(code, handle);
		}
	}
}
