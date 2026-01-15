using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Horse
{
	public class HorseProcessor
	{
		private static object object_0;

		private IHorseProcessor ihorseProcessor_0;

		public HorseProcessor(IHorseProcessor processor)
		{
			ihorseProcessor_0 = processor;
		}

		public void ProcessData(GamePlayer player, GSPacketIn data)
		{
			lock (object_0)
			{
				ihorseProcessor_0.OnGameData(player, data);
			}
		}

		static HorseProcessor()
		{
			object_0 = new object();
		}
	}
}
