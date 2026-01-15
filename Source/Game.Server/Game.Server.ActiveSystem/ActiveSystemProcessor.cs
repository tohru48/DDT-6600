using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ActiveSystem
{
	public class ActiveSystemProcessor
	{
		private static object object_0;

		private IActiveSystemProcessor iactiveSystemProcessor_0;

		public ActiveSystemProcessor(IActiveSystemProcessor processor)
		{
			iactiveSystemProcessor_0 = processor;
		}

		public void ProcessData(GamePlayer player, GSPacketIn data)
		{
			lock (object_0)
			{
				iactiveSystemProcessor_0.OnGameData(player, data);
			}
		}

		static ActiveSystemProcessor()
		{
			object_0 = new object();
		}
	}
}
