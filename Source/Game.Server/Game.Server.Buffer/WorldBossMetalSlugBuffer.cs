using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class WorldBossMetalSlugBuffer : AbstractBuffer
	{
		public WorldBossMetalSlugBuffer(BufferInfo buffer)
			: base(buffer)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(WorldBossMetalSlugBuffer)) is WorldBossMetalSlugBuffer worldBossMetalSlugBuffer)
			{
				worldBossMetalSlugBuffer.Info.ValidDate = base.Info.ValidDate;
				player.BufferList.UpdateBuffer(worldBossMetalSlugBuffer);
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
