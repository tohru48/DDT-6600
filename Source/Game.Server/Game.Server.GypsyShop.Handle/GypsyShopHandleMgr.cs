using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.GypsyShop.Handle
{
	public class GypsyShopHandleMgr
	{
		private Dictionary<int, IGypsyShopCommandHadler> dictionary_0;

		public IGypsyShopCommandHadler LoadCommandHandler(int code)
		{
			return dictionary_0[code];
		}

		public GypsyShopHandleMgr()
		{
			dictionary_0 = new Dictionary<int, IGypsyShopCommandHadler>();
			dictionary_0.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
		}

		protected int SearchCommandHandlers(Assembly assembly)
		{
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.GypsyShop.Handle.IGypsyShopCommandHadler") == null))
				{
					Attribute8[] array = (Attribute8[])type.GetCustomAttributes(typeof(Attribute8), inherit: true);
					if (array.Length > 0)
					{
						num++;
						RegisterCommandHandler(array[0].method_0(), Activator.CreateInstance(type) as IGypsyShopCommandHadler);
					}
				}
			}
			return num;
		}

		protected void RegisterCommandHandler(int code, IGypsyShopCommandHadler handle)
		{
			dictionary_0.Add(code, handle);
		}
	}
}
