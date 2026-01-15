using System.Threading;

namespace Game.Server.RingStation
{
	public class RingStationConfiguration
	{
		public static int ServerID;

		public static string ServerName;

		public static int roomID;

		public static int PlayerID;

		public static int NextRoomId()
		{
			return Interlocked.Increment(ref roomID);
		}

		public static int NextPlayerID()
		{
			return Interlocked.Increment(ref PlayerID);
		}

		static RingStationConfiguration()
		{
			ServerID = 103;
			ServerName = "AutoBot";
			roomID = 1000;
			PlayerID = 1000;
		}
	}
}
