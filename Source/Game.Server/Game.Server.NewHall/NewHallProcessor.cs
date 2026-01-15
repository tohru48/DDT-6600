using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.NewHall
{
	public class NewHallProcessor
	{
		private static object object_0;

		private INewHallProcessor inewHallProcessor_0;

		public NewHallProcessor(INewHallProcessor processor)
		{
			inewHallProcessor_0 = processor;
		}

		public void ProcessData(GamePlayer player, GSPacketIn data)
		{
			lock (object_0)
			{
				inewHallProcessor_0.OnGameData(player, data);
			}
		}

		static NewHallProcessor()
		{
			object_0 = new object();
		}
	}
}
