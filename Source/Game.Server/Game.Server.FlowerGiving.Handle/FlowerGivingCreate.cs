using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.FlowerGiving.Handle
{
	[Attribute6(7)]
	public class FlowerGivingCreate : IFlowerGivingCommandHadler
	{
		protected FlowerGivingLogicProcessor m_FlowerGivingProcessor;

		private FlowerGivingProcessor flowerGivingProcessor_0;

		public FlowerGivingProcessor FlowerGivingHandler => flowerGivingProcessor_0;

		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			flowerGivingProcessor_0 = new FlowerGivingProcessor(m_FlowerGivingProcessor);
			return true;
		}

		public FlowerGivingCreate()
		{
			m_FlowerGivingProcessor = new FlowerGivingLogicProcessor();
		}
	}
}
