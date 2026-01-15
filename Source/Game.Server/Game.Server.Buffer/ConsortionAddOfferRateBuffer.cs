using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class ConsortionAddOfferRateBuffer : AbstractBuffer
	{
		public ConsortionAddOfferRateBuffer(BufferInfo buffer)
			: base(buffer)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(ConsortionAddOfferRateBuffer)) is ConsortionAddOfferRateBuffer consortionAddOfferRateBuffer)
			{
				consortionAddOfferRateBuffer.Info.ValidDate += m_info.ValidDate;
				consortionAddOfferRateBuffer.Info.TemplateID = m_info.TemplateID;
				player.BufferList.UpdateBuffer(consortionAddOfferRateBuffer);
				player.UpdateFightBuff(base.Info);
			}
			else
			{
				base.Start(player);
				player.FightBuffs.Add(base.Info);
			}
		}

		public override void Stop()
		{
			m_player.FightBuffs.Remove(base.Info);
			base.Stop();
		}
	}
}
