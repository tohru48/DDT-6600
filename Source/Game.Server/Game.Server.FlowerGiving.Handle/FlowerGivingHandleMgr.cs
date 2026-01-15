using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.FlowerGiving.Handle
{
	public class FlowerGivingHandleMgr
	{
		private Dictionary<int, IFlowerGivingCommandHadler> dictionary_0;

		public IFlowerGivingCommandHadler LoadCommandHandler(int code)
		{
			return dictionary_0[code];
		}

		public FlowerGivingHandleMgr()
		{
			dictionary_0 = new Dictionary<int, IFlowerGivingCommandHadler>();
			dictionary_0.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
		}

		protected int SearchCommandHandlers(Assembly assembly)
		{
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.FlowerGiving.Handle.IFlowerGivingCommandHadler") == null))
				{
					Attribute6[] array = (Attribute6[])type.GetCustomAttributes(typeof(Attribute6), inherit: true);
					if (array.Length > 0)
					{
						num++;
						RegisterCommandHandler(array[0].method_0(), Activator.CreateInstance(type) as IFlowerGivingCommandHadler);
					}
				}
			}
			return num;
		}

		protected void RegisterCommandHandler(int code, IFlowerGivingCommandHadler handle)
		{
			dictionary_0.Add(code, handle);
		}
	}
}
