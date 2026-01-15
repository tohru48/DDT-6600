using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class ConsortionAddPercentGoldOrGPBuffer : AbstractBuffer
	{
		public ConsortionAddPercentGoldOrGPBuffer(BufferInfo buffer)
			: base(buffer)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(ConsortionAddPercentGoldOrGPBuffer)) is ConsortionAddPercentGoldOrGPBuffer consortionAddPercentGoldOrGPBuffer)
			{
				consortionAddPercentGoldOrGPBuffer.Info.ValidDate += m_info.ValidDate;
				consortionAddPercentGoldOrGPBuffer.Info.TemplateID = m_info.TemplateID;
				player.BufferList.UpdateBuffer(consortionAddPercentGoldOrGPBuffer);
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
