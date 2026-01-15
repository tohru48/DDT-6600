using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.CollectionTask.Handle
{
	public class CollectionTaskHandleMgr
	{
		private Dictionary<int, ICollectionTaskCommandHadler> dictionary_0;

		public ICollectionTaskCommandHadler LoadCommandHandler(int code)
		{
			return dictionary_0[code];
		}

		public CollectionTaskHandleMgr()
		{
			dictionary_0 = new Dictionary<int, ICollectionTaskCommandHadler>();
			dictionary_0.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
		}

		protected int SearchCommandHandlers(Assembly assembly)
		{
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.CollectionTask.Handle.ICollectionTaskCommandHadler") == null))
				{
					Attribute3[] array = (Attribute3[])type.GetCustomAttributes(typeof(Attribute3), inherit: true);
					if (array.Length > 0)
					{
						num++;
						RegisterCommandHandler(array[0].method_0(), Activator.CreateInstance(type) as ICollectionTaskCommandHadler);
					}
				}
			}
			return num;
		}

		protected void RegisterCommandHandler(int code, ICollectionTaskCommandHadler handle)
		{
			dictionary_0.Add(code, handle);
		}
	}
}
