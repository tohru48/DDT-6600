using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class HonorBuffer : AbstractBuffer
	{
		public HonorBuffer(BufferInfo info)
			: base(info)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(HonorBuffer)) is HonorBuffer honorBuffer)
			{
				honorBuffer.Info.ValidDate += base.Info.ValidDate;
				player.BufferList.UpdateBuffer(honorBuffer);
			}
			else
			{
				base.Start(player);
				player.OfferAddPlus *= base.Info.Value;
			}
		}

		public override void Stop()
		{
			m_player.OfferAddPlus = 0.0;
			base.Stop();
		}
	}
}
