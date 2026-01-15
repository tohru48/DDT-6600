using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class ConsortionAddSpellCountBuffer : AbstractBuffer
	{
		public ConsortionAddSpellCountBuffer(BufferInfo buffer)
			: base(buffer)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(ConsortionAddSpellCountBuffer)) is ConsortionAddSpellCountBuffer consortionAddSpellCountBuffer)
			{
				consortionAddSpellCountBuffer.Info.ValidDate += m_info.ValidDate;
				consortionAddSpellCountBuffer.Info.TemplateID = m_info.TemplateID;
				player.BufferList.UpdateBuffer(consortionAddSpellCountBuffer);
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
