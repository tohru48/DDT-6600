using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.NewHall.Handle
{
	public class NewHallHandleMgr
	{
		private Dictionary<int, INewHallCommandHadler> dictionary_0;

		public INewHallCommandHadler LoadCommandHandler(int code)
		{
			return dictionary_0[code];
		}

		public NewHallHandleMgr()
		{
			dictionary_0 = new Dictionary<int, INewHallCommandHadler>();
			dictionary_0.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
		}

		protected int SearchCommandHandlers(Assembly assembly)
		{
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.NewHall.Handle.INewHallCommandHadler") == null))
				{
					Attribute13[] array = (Attribute13[])type.GetCustomAttributes(typeof(Attribute13), inherit: true);
					if (array.Length > 0)
					{
						num++;
						RegisterCommandHandler(array[0].method_0(), Activator.CreateInstance(type) as INewHallCommandHadler);
					}
				}
			}
			return num;
		}

		protected void RegisterCommandHandler(int code, INewHallCommandHadler handle)
		{
			dictionary_0.Add(code, handle);
		}
	}
}
