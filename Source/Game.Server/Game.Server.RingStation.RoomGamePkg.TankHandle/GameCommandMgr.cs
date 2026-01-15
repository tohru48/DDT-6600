using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.RingStation.RoomGamePkg.TankHandle
{
	public class GameCommandMgr
	{
		private Dictionary<int, IGameCommandHandler> dictionary_0;

		public GameCommandMgr()
		{
			dictionary_0 = new Dictionary<int, IGameCommandHandler>();
			dictionary_0.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
		}

		public IGameCommandHandler LoadCommandHandler(int code)
		{
			return dictionary_0[code];
		}

		protected void RegisterCommandHandler(int code, IGameCommandHandler handle)
		{
			dictionary_0.Add(code, handle);
		}

		protected int SearchCommandHandlers(Assembly assembly)
		{
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && type.GetInterface("Game.Server.RingStation.RoomGamePkg.TankHandle.IGameCommandHandler") != null)
				{
					GameCommandAttbute[] array = (GameCommandAttbute[])type.GetCustomAttributes(typeof(GameCommandAttbute), inherit: true);
					if (array.Length > 0)
					{
						num++;
						RegisterCommandHandler(array[0].Code, Activator.CreateInstance(type) as IGameCommandHandler);
					}
				}
			}
			return num;
		}
	}
}
