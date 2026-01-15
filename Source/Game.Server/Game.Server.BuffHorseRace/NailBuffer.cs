using SqlDataProvider.Data;

namespace Game.Server.BuffHorseRace
{
	public class NailBuffer : AbstractHorseRaceBuffer
	{
		public NailBuffer(BuffHorseRaceInfo buffer)
			: base(buffer)
		{
		}

		public override void Start(UserHorseRaceInfo player, UserHorseRaceInfo ower)
		{
			if (!(player.BuffList.GetOfType(typeof(NailBuffer)) is NailBuffer))
			{
				base.Start(player, ower);
				if (player.UserID != ower.UserID)
				{
					double num = (double)player.Speed / 100.0 * 40.0;
					player.Speed -= (int)num;
				}
			}
		}

		public override void Stop()
		{
			m_player.Speed = m_player.DefaultSpeed;
			base.Stop();
		}
	}
}
