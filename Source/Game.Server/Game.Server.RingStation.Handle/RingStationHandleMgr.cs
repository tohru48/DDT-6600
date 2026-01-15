using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.RingStation.Handle
{
	public class RingStationHandleMgr
	{
		private Dictionary<int, IRingStationCommandHadler> dictionary_0;

		public IRingStationCommandHadler LoadCommandHandler(int code)
		{
			return dictionary_0[code];
		}

		public RingStationHandleMgr()
		{
			dictionary_0 = new Dictionary<int, IRingStationCommandHadler>();
			dictionary_0.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
		}

		protected int SearchCommandHandlers(Assembly assembly)
		{
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.RingStation.Handle.IRingStationCommandHadler") == null))
				{
					Attribute15[] array = (Attribute15[])type.GetCustomAttributes(typeof(Attribute15), inherit: true);
					if (array.Length > 0)
					{
						num++;
						RegisterCommandHandler(array[0].method_0(), Activator.CreateInstance(type) as IRingStationCommandHadler);
					}
				}
			}
			return num;
		}

		protected void RegisterCommandHandler(int code, IRingStationCommandHadler handle)
		{
			dictionary_0.Add(code, handle);
		}
	}
}
