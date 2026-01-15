using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class ConsortionReduceDanderBuffer : AbstractBuffer
	{
		public ConsortionReduceDanderBuffer(BufferInfo buffer)
			: base(buffer)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(ConsortionReduceDanderBuffer)) is ConsortionReduceDanderBuffer consortionReduceDanderBuffer)
			{
				consortionReduceDanderBuffer.Info.ValidDate += m_info.ValidDate;
				consortionReduceDanderBuffer.Info.TemplateID = m_info.TemplateID;
				player.BufferList.UpdateBuffer(consortionReduceDanderBuffer);
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
