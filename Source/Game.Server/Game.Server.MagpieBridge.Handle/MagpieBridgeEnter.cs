using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagpieBridge.Handle
{
	[Attribute12(1)]
	public class MagpieBridgeEnter : IMagpieBridgeCommandHadler
	{
		private static ThreadSafeRandom threadSafeRandom_0;

		private readonly int[] int_0;

		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			threadSafeRandom_0.Shuffer(int_0);
			Player.Extra.GetMagpieBridgeItemsDb();
			int num = threadSafeRandom_0.Next(int_0.Length);
			Player.Extra.MapId = int_0[num];
			Player.Extra.SendMagpieBridgeEnter();
			return false;
		}

		public MagpieBridgeEnter()
		{
			int_0 = new int[3] { 1, 2, 3 };
		}

		static MagpieBridgeEnter()
		{
			threadSafeRandom_0 = new ThreadSafeRandom();
		}
	}
}
