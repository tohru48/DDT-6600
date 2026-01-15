using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.WorshipTheMoon
{
	public class WorshipTheMoonProcessor
	{
		private static object object_0;

		private IWorshipTheMoonProcessor iworshipTheMoonProcessor_0;

		public WorshipTheMoonProcessor(IWorshipTheMoonProcessor processor)
		{
			iworshipTheMoonProcessor_0 = processor;
		}

		public void ProcessData(GamePlayer player, GSPacketIn data)
		{
			lock (object_0)
			{
				iworshipTheMoonProcessor_0.OnGameData(player, data);
			}
		}

		static WorshipTheMoonProcessor()
		{
			object_0 = new object();
		}
	}
}
