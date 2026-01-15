using System;

namespace Game.Base.Packets
{
	[AttributeUsage(AttributeTargets.Class, AllowMultiple = true, Inherited = false)]
	public class PacketLibAttribute : Attribute
	{
		private int int_0;

		public int RawVersion => int_0;

		public PacketLibAttribute(int rawVersion)
		{
			int_0 = rawVersion;
		}
	}
}
