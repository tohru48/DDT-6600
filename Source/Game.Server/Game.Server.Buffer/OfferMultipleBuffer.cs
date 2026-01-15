using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class OfferMultipleBuffer : AbstractBuffer
	{
		public OfferMultipleBuffer(BufferInfo info)
			: base(info)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(OfferMultipleBuffer)) is OfferMultipleBuffer offerMultipleBuffer)
			{
				offerMultipleBuffer.Info.ValidDate += base.Info.ValidDate;
				player.BufferList.UpdateBuffer(offerMultipleBuffer);
			}
			else
			{
				base.Start(player);
				player.OfferAddPlus *= base.Info.Value;
			}
		}

		public override void Stop()
		{
			m_player.OfferAddPlus /= m_info.Value;
			base.Stop();
		}
	}
}
