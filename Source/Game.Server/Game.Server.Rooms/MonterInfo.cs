using System.Drawing;

namespace Game.Server.Rooms
{
	public class MonterInfo
	{
		public int ID { get; set; }

		public int state { get; set; }

		public Point MonsterPos { get; set; }

		public Point MonsterNewPos { get; set; }

		public int type { get; set; }

		public int PlayerID { get; set; }
	}
}
