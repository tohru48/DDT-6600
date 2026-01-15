using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.AvatarCollection.Handle
{
	public class AvatarCollectionHandleMgr
	{
		private Dictionary<int, IAvatarCollectionCommandHadler> dictionary_0;

		public IAvatarCollectionCommandHadler LoadCommandHandler(int code)
		{
			return dictionary_0[code];
		}

		public AvatarCollectionHandleMgr()
		{
			dictionary_0 = new Dictionary<int, IAvatarCollectionCommandHadler>();
			dictionary_0.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
		}

		protected int SearchCommandHandlers(Assembly assembly)
		{
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.AvatarCollection.Handle.IAvatarCollectionCommandHadler") == null))
				{
					Attribute1[] array = (Attribute1[])type.GetCustomAttributes(typeof(Attribute1), inherit: true);
					if (array.Length > 0)
					{
						num++;
						RegisterCommandHandler(array[0].method_0(), Activator.CreateInstance(type) as IAvatarCollectionCommandHadler);
					}
				}
			}
			return num;
		}

		protected void RegisterCommandHandler(int code, IAvatarCollectionCommandHadler handle)
		{
			dictionary_0.Add(code, handle);
		}
	}
}
