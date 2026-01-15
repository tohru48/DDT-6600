using System;

namespace Game.Server.Horse
{
	public class HorseProcessorAtribute : Attribute
	{
		private byte byte_0;

		private string string_0;

		public byte Code => byte_0;

		public string Description => string_0;

		public HorseProcessorAtribute(byte code, string description)
		{
			byte_0 = code;
			string_0 = description;
		}
	}
}
