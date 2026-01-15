using SqlDataProvider.Data;

namespace Game.Server.BuffHorseRace
{
	public class MagnetBuffer : AbstractHorseRaceBuffer
	{
		public MagnetBuffer(BuffHorseRaceInfo buffer)
			: base(buffer)
		{
		}

		public override void Start(UserHorseRaceInfo player, UserHorseRaceInfo ower)
		{
			if (!(player.BuffList.GetOfType(typeof(MagnetBuffer)) is MagnetBuffer))
			{
				base.Start(player, ower);
				if (player.UserID != ower.UserID)
				{
					double num = (double)player.Speed / 100.0 * 20.0;
					player.Speed -= (int)num;
				}
				else
				{
					double num2 = (double)player.Speed / 100.0 * 30.0;
					player.Speed += (int)num2;
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
