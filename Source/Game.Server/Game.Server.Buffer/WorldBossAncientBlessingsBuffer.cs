using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class WorldBossAncientBlessingsBuffer : AbstractBuffer
	{
		public WorldBossAncientBlessingsBuffer(BufferInfo buffer)
			: base(buffer)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(WorldBossAncientBlessingsBuffer)) is WorldBossAncientBlessingsBuffer worldBossAncientBlessingsBuffer)
			{
				worldBossAncientBlessingsBuffer.Info.ValidDate = base.Info.ValidDate;
				player.BufferList.UpdateBuffer(worldBossAncientBlessingsBuffer);
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
