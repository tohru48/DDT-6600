using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.MagicStone.Handle
{
	public class MagicStoneHandleMgr
	{
		private Dictionary<int, IMagicStoneCommandHadler> dictionary_0;

		public IMagicStoneCommandHadler LoadCommandHandler(int code)
		{
			return dictionary_0[code];
		}

		public MagicStoneHandleMgr()
		{
			dictionary_0 = new Dictionary<int, IMagicStoneCommandHadler>();
			dictionary_0.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
		}

		protected int SearchCommandHandlers(Assembly assembly)
		{
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.MagicStone.Handle.IMagicStoneCommandHadler") == null))
				{
					Attribute11[] array = (Attribute11[])type.GetCustomAttributes(typeof(Attribute11), inherit: true);
					if (array.Length > 0)
					{
						num++;
						RegisterCommandHandler(array[0].method_0(), Activator.CreateInstance(type) as IMagicStoneCommandHadler);
					}
				}
			}
			return num;
		}

		protected void RegisterCommandHandler(int code, IMagicStoneCommandHadler handle)
		{
			dictionary_0.Add(code, handle);
		}
	}
}
