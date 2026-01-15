using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class ConsortionAddEffectTurnBuffer : AbstractBuffer
	{
		public ConsortionAddEffectTurnBuffer(BufferInfo buffer)
			: base(buffer)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(ConsortionAddEffectTurnBuffer)) is ConsortionAddEffectTurnBuffer consortionAddEffectTurnBuffer)
			{
				consortionAddEffectTurnBuffer.Info.ValidDate += m_info.ValidDate;
				consortionAddEffectTurnBuffer.Info.TemplateID = m_info.TemplateID;
				player.BufferList.UpdateBuffer(consortionAddEffectTurnBuffer);
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
